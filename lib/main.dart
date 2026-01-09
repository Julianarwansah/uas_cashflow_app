import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'config/firebase_options.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';
import 'splash/splash_screen_1.dart';
import 'splash/splash_screen_2.dart';
import 'splash/splash_screen_3.dart';
import 'splash/splash_screen_4.dart';
import 'navigation/main_navigation.dart';
import 'theme/app_theme.dart';
import 'cashflow/transaction_form_screen.dart';
import 'services/notification_service.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('id_ID', null);

  await Supabase.initialize(
    url: 'https://vfpcffpceelpixyaapbx.supabase.co',
    anonKey: 'sb_publishable_6z5_C4-LOGaPeYur_lk9dA_1leKifzM',
  );

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
      home: const SplashScreen1(),
      routes: {
        '/splash2': (context) => const SplashScreen2(),
        '/splash3': (context) => const SplashScreen3(),
        '/splash4': (context) => const SplashScreen4(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const RegisterScreen(),
        '/home': (context) => const MainNavigation(),
        '/add-transaction': (context) => const TransactionFormScreen(),
      },
    );
  }
}
