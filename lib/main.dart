import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth/login.dart';
import 'auth/signup.dart';
import 'splash/splashscreen1.dart';
import 'splash/splashscreen2.dart';
import 'splash/splashscreen3.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cashflow App',
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      // Home pertama
      home: const SplashScreen1(),
      // Daftarkan route bernama untuk SplashScreen2
      routes: {
        '/splash2': (context) => const SplashScreen2(),
        '/splash3': (context) => const SplashScreen3(),
        // Jika nanti ada login atau halaman lain, tambahkan di sini
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
      },
    );
  }
}
