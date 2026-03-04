import 'package:cloud_firestore/cloud_firestore.dart'; // নতুন অ্যাড করা হয়েছে
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_firebase_task_manager/features/auth/presentation/pages/auth_gate.dart';
import 'package:provider/provider.dart';

import '../features/auth/data/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/tasks/data/task_repository_impl.dart';
import '../features/tasks/domain/repositories/task_repositories.dart';
import '../features/tasks/presentation/providers/task_provider.dart';
import 'app_routes.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ১. Auth Repository
        Provider<AuthRepository>(
          create: (_) => AuthRepositoryImpl(FirebaseAuth.instance),
        ),

        // ২. Task Repository (এটি আপনার কোডে মিসিং ছিল)
        Provider<TaskRepository>(
          create: (_) => TaskRepositoryImpl(FirebaseFirestore.instance),
        ),

        // ৩. Auth Provider (নির্ভর করে AuthRepository-এর ওপর)
        ChangeNotifierProvider(
          create: (context) => AuthProvider(context.read<AuthRepository>()),
        ),

        // ৪. Task Provider (নির্ভর করে TaskRepository-এর ওপর)
        ChangeNotifierProvider(
          create: (context) => TaskProvider(context.read<TaskRepository>()),
        ),
      ],
      child: MaterialApp(
        initialRoute: AuthGate.name,
        onGenerateRoute: AppRoutes.routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
