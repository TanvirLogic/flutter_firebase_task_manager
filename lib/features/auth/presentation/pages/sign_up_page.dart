import 'package:flutter/material.dart';
import 'package:flutter_firebase_task_manager/features/auth/presentation/pages/login_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  static const String name = '/signup';
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Sign Up"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (value) =>
                      value!.contains("@") ? null : "Enter valid email",
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  validator: (value) =>
                      value!.length >= 6 ? null : "Min 6 characters",
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: auth.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            await auth.register(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                            if (auth.error != null) {
                              Fluttertoast.showToast(
                                msg: auth.error!,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: 'Registered Successfully',
                              );
                            }
                          }
                        },
                  child: auth.isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Sign Up"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
