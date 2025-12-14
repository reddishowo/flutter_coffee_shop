// File: /lib/app/services/notification_service.dart

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';

// Handler for Background Message (Must be Top-Level Function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class NotificationService extends GetxService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  // Android Channel ID
  final AndroidNotificationChannel _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('notif_sound'), // Custom Sound
  );

  Future<void> init() async {
    // 1. Request Permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      
      // 2. Setup Local Notifications (For Foreground)
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      
      // Setup iOS/Darwin - FIXED: Removed onDidReceiveLocalNotification
      final DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings();

      final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
      );

      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          // Handle notification click when app is in Foreground
          if (response.payload != null) {
            _handleMessageNavigation(response.payload!);
          }
        },
      );

      // Create Android Channel
      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_androidChannel);

      // 3. Setup FCM Listeners
      
      // Listener: Background Handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Listener: Foreground (App is open)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        // Show Heads-up Notification manually via Local Notifications
        if (notification != null && android != null) {
          _localNotifications.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                _androidChannel.id,
                _androidChannel.name,
                channelDescription: _androidChannel.description,
                icon: '@mipmap/ic_launcher',
                playSound: true,
                sound: const RawResourceAndroidNotificationSound('notif_sound'),
                importance: Importance.max,
                priority: Priority.high,
              ),
            ),
            payload: _encodePayload(message.data),
          );
        }
      });

      // Listener: Opened App (From Background/Minimized)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A notification was opened form background!');
        if (message.data.isNotEmpty) {
           _handleMessageNavigation(_encodePayload(message.data));
        }
      });

      // Get Token (For testing via Firebase Console)
      String? token = await _firebaseMessaging.getToken();
      print("FCM Token: $token");
    }
  }

  // 4. Handle Terminated State (App completely closed then opened via notif)
  Future<void> checkInitialMessage() async {
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print('A notification was opened from terminated state!');
      if (initialMessage.data.isNotEmpty) {
        // Add slight delay for GetX routing to be ready
        Future.delayed(const Duration(milliseconds: 500), () {
          _handleMessageNavigation(_encodePayload(initialMessage.data));
        });
      }
    }
  }

  void _handleMessageNavigation(String payloadString) {
    final parts = payloadString.split('|');
    String? route;
    String? id;
    
    for(int i=0; i<parts.length; i+=2) {
      if(parts[i] == 'route') route = parts[i+1];
      if(parts[i] == 'id') id = parts[i+1];
    }

    if (route != null) {
      if (route == '/product-detail' && id != null) {
        Get.toNamed(Routes.PROMO_NOTIF, arguments: {'id': id});
      } else {
        Get.toNamed(route);
      }
    }
  }

  String _encodePayload(Map<String, dynamic> data) {
    List<String> buffer = [];
    data.forEach((key, value) {
      buffer.add(key);
      buffer.add(value.toString());
    });
    return buffer.join('|');
  }
}