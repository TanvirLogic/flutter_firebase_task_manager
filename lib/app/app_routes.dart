import 'package:flutter/material.dart';
import '../features/auth/presentation/pages/auth_gate.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/sign_up_page.dart';
import '../features/tasks/presentation/pages/home_page.dart';

class AppRoutes {
  static Route<dynamic> routes(RouteSettings setting) {
    Widget widget = SizedBox();
    if (setting.name == AuthGate.name) {
      widget = AuthGate();
    } else if (setting.name == HomePage.name) {
      widget = HomePage();
    } else if (setting.name == LoginPage.name) {
      widget = LoginPage();
    } else if (setting.name == SignupPage.name) {
      widget = SignupPage();
    }

    // if (setting)
    return MaterialPageRoute(builder: (context) => widget);
  }
}
