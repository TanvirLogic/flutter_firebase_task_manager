import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_task_manager/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_firebase_task_manager/features/auth/presentation/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Accessing the AuthProvider using the provider package
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('This is Home Page'),
        actions: [
          IconButton(
            onPressed: () async {
              // Calling the logout method from your provider
              await auth.logout();

              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, ${auth.user?.email ?? "User"}'),
            if (auth.isLoading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
