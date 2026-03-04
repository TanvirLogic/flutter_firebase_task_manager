import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../tasks/presentation/pages/home_page.dart';
import '../providers/auth_provider.dart';
import 'login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (auth.user == null) {
          return const LoginPage();
        }

        return const HomePage(); // will build later
      },
    );
  }
}
