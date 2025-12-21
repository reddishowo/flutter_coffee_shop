part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const HOME_TAB = _Paths.HOME_TAB;
  static const MENU = _Paths.MENU;
  static const SEARCH = _Paths.SEARCH;
  static const ACCOUNT = _Paths.ACCOUNT;
  static const APIEXPERIMENT = _Paths.APIEXPERIMENT;
  static const CART = _Paths.CART;
  static const PRODUCT_DETAIL = _Paths.PRODUCT_DETAIL;
  static const LOCATION_EXPERIMENT = _Paths.LOCATION_EXPERIMENT;
  static const PROMO_NOTIF = _Paths.PROMO_NOTIF;
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
  static const ORDER_HISTORY = _Paths.ORDER_HISTORY;
  static const WELCOME = _Paths.WELCOME; // Add
  static const LOGIN = _Paths.LOGIN;     // Add
  static const SIGNUP = _Paths.SIGNUP;   // Add
  static const ADD_PRODUCT = _Paths.ADD_PRODUCT;
  static const ADMIN_DASHBOARD = _Paths.ADMIN_DASHBOARD; // Baru
  static const MANAGE_PRODUCT = _Paths.MANAGE_PRODUCT;   // Baru
  static const EDIT_PRODUCT = _Paths.EDIT_PRODUCT;       // Baru
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const HOME_TAB = '/home-tab';
  static const MENU = '/menu';
  static const SEARCH = '/search';
  static const ACCOUNT = '/account';
  static const APIEXPERIMENT = '/apiexperiment';
  static const CART = '/cart';
  static const PRODUCT_DETAIL = '/product-detail';
  static const LOCATION_EXPERIMENT = '/location-experiment';
  static const PROMO_NOTIF = '/promo-notif';
  static const EDIT_PROFILE = '/edit-profile';
  static const ORDER_HISTORY = '/order-history';
  static const WELCOME = '/welcome';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const ADD_PRODUCT = '/add-product';
  static const ADMIN_DASHBOARD = '/admin-dashboard';
  static const MANAGE_PRODUCT = '/manage-product';
  static const EDIT_PRODUCT = '/edit-product';
}