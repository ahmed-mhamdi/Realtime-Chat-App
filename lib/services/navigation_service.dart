import 'package:chat_app_material3/Pages/home_page.dart';
import 'package:chat_app_material3/Pages/login_page.dart';
import 'package:chat_app_material3/Pages/signup_page.dart';
import 'package:flutter/material.dart';

class NavigationService {
  late GlobalKey<NavigatorState> _navigatorKey;
  final Map<String, Widget Function(BuildContext)> _routes = {
    "/login": (context) => const LoginPage(),
    "/home": (context) => const HomePage(),
    "/signup": (context) => const SignupPage(),
  };
  GlobalKey<NavigatorState>? get navigatorKey {
    return _navigatorKey;
  }

  Map<String, Widget Function(BuildContext)> get routes {
    return _routes;
  }

  NavigationService() {
    _navigatorKey = GlobalKey<NavigatorState>();
  }

  void pushNamed(String route) {
    _navigatorKey.currentState?.pushNamed(route);
  }

  void pushReplacementNamed(String route) {
    _navigatorKey.currentState?.pushReplacementNamed(route);
  }

  void push(MaterialPageRoute route) {
    _navigatorKey.currentState?.push(route);
  }

  void back() {
    _navigatorKey.currentState?.pop();
  }
}
