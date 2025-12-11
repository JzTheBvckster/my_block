import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/data/auth_provider.dart' as my_auth;
import 'features/profile/data/profile_repository.dart';
import 'core/utils/firestore_service.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/feed/presentation/feed_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (_) => AuthRepository(FirebaseAuth.instance),
        ),
        Provider<FirestoreService>(
          create: (_) => FirestoreService(FirebaseFirestore.instance),
        ),
        Provider<ProfileRepository>(
          create: (ctx) => ProfileRepository(ctx.read<FirestoreService>()),
        ),
        ChangeNotifierProvider<my_auth.AuthProvider>(
          create: (ctx) => my_auth.AuthProvider(
            ctx.read<AuthRepository>(),
            ctx.read<ProfileRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2EC4B6)),
        ),
        home: const _AuthGate(),
      ),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snapshot.data;
        if (user == null) {
          return const LoginPage();
        }
        return const FeedPage();
      },
    );
  }
}
