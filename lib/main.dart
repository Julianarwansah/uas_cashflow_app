import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/firebase_options.dart';
import 'auth/login.dart';
import 'auth/signup.dart';
import 'splash/splashscreen1.dart';
import 'splash/splashscreen2.dart';
import 'splash/splashscreen3.dart';
import 'navigation/main_navigation.dart';
import 'theme/app_theme.dart';
import 'cashflow/transaction_form_screen.dart';
import 'services/notification_service.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
    url: 'https://vfpcffpceelpixyaapbx.supabase.co',
    anonKey: 'sb_publishable_6z5_C4-LOGaPeYur_lk9dA_1leKifzM',
  );

  // Initialize notification service
  await NotificationService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cashflow App',
      theme: AppTheme.themeData,
      debugShowCheckedModeBanner: false,
      // Home pertama
      home: const SplashScreen1(),
      // Daftarkan route bernama untuk SplashScreen2
      routes: {
        '/splash2': (context) => const SplashScreen2(),
        '/splash3': (context) => const SplashScreen3(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const MainNavigation(),
        '/add-transaction': (context) => const TransactionFormScreen(),
      },
    );
  }
}
