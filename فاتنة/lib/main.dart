
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/grades_screen.dart';
import 'screens/programs_screen.dart';
import 'screens/teacher_screen.dart';
import 'screens/admin_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // for web, configure via index.html or use options
  runApp(const FatinaApp());
}

class FatinaApp extends StatelessWidget {
  const FatinaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'معهد فاتنة',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        routes: {
          '/': (_) => const LoginScreen(),
          '/home': (_) => const HomeScreen(),
          '/grades': (_) => const GradesScreen(),
          '/programs': (_) => const ProgramsScreen(),
          '/teacher': (_) => const TeacherScreen(),
          '/admin': (_) => const AdminScreen(),
        },
      ),
    );
  }
}
