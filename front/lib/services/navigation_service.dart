import 'package:flutter/cupertino.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  static NavigationService get instance => _instance;

  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> navigateToLogin() async {
    await navigatorKey.currentState
        ?.pushNamedAndRemoveUntil('/login', (route) => false);
  }
}
