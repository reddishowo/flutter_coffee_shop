import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';

// Handler untuk Background Message (Harus Top-Level Function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // Kita tidak perlu menampilkan Local Notification di sini secara manual 
  // karena Firebase SDK otomatis menanganinya jika ada payload 'notification'.
}

class NotificationService extends GetxService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  // ID Channel Android
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
      
      // 2. Setup Local Notifications (Untuk Foreground)
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      
      // Setup iOS/Darwin
      final DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) async {},
      );

      final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
      );

      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          // Handle klik notifikasi saat aplikasi di Foreground (Local Notif Click)
          if (response.payload != null) {
            _handleMessageNavigation(response.payload!);
          }
        },
      );

      // Buat Channel Android
      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_androidChannel);

      // 3. Setup FCM Listeners
      
      // Listener: Background Handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Listener: Foreground (Aplikasi sedang dibuka)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        // Tampilkan Heads-up Notification manual via Local Notifications
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

      // Listener: Opened App (Dari Background/Minimized)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A notification was opened form background!');
        if (message.data.isNotEmpty) {
           _handleMessageNavigation(_encodePayload(message.data));
        }
      });

      // Get Token (Untuk testing via Firebase Console)
      String? token = await _firebaseMessaging.getToken();
      print("FCM Token: $token");
    }
  }

  // 4. Handle Terminated State (Aplikasi mati total lalu dibuka via notif)
  Future<void> checkInitialMessage() async {
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print('A notification was opened from terminated state!');
      if (initialMessage.data.isNotEmpty) {
        // Beri sedikit delay agar GetX routing siap
        Future.delayed(const Duration(milliseconds: 500), () {
          _handleMessageNavigation(_encodePayload(initialMessage.data));
        });
      }
    }
  }

  // Helper untuk navigasi berdasarkan payload
  // Contoh payload di Firebase Console (Key-Value): 
  // route: /product-detail
  // arg_id: 1
  void _handleMessageNavigation(String payloadString) {
    // Parsing sederhana string payload key:value
    // Di real production gunakan jsonEncode/Decode
    
    // Asumsi payloadString format: "route:/product-detail,arg_id:1"
    // Untuk simplifikasi modul ini, kita anggap payload dikirim via data FCM langsung
    // dan fungsi ini menerima representasi string atau kita parse manual data map.
    
    // Kita ubah logika: Parameter function menerima Raw Map Data encoded string?
    // Mari kita parsing manual Map dari FCM data.
    
    // Implementasi Sederhana:
    // Cek isi string (Encode manual di fungsi pemanggil)
    // Format simulasi: "route|/product-detail|id|1"
    
    final parts = payloadString.split('|');
    String? route;
    String? id;
    
    for(int i=0; i<parts.length; i+=2) {
      if(parts[i] == 'route') route = parts[i+1];
      if(parts[i] == 'id') id = parts[i+1];
    }

    if (route != null) {
      if (route == '/product-detail' && id != null) {
        // Kita butuh data produk lengkap. 
        // Untuk simulasi, kita cari dari sampleProducts berdasarkan ID.
        // Import sample data dulu jika perlu, atau kirim objek dummy.
        // Di sini kita arahkan ke halaman promo khusus saja untuk mempermudah.
        Get.toNamed(Routes.PROMO_NOTIF, arguments: {'id': id});
      } else {
        Get.toNamed(route);
      }
    }
  }

  String _encodePayload(Map<String, dynamic> data) {
    // Ubah Map ke string sederhana "key|value|key|value" agar bisa masuk payload local notif string
    List<String> buffer = [];
    data.forEach((key, value) {
      buffer.add(key);
      buffer.add(value.toString());
    });
    return buffer.join('|');
  }
}