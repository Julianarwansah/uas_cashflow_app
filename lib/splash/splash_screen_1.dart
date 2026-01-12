import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({super.key});

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_fadeController);
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(_scaleController);

    _fadeController.forward();
    _scaleController.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      // Pastikan rute '/splash2' sudah didefinisikan di main.dart
      Navigator.pushReplacementNamed(context, '/splash2');
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  // --- PERUBAHAN DI SINI ---
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    // Menggunakan Image.asset sebagai pengganti Lottie.asset
                    // Pastikan path 'assets/images/logo_global.png' sesuai
                    // dengan lokasi file Anda dan sudah didaftarkan di pubspec.yaml
                    child: Image.asset(
                      'assets/images/logoapp.png',
                      fit: BoxFit.contain, // Agar gambar pas di dalam kotaknya
                    ),
                  ),
                  // -------------------------
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Pengeluaran Harian",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "M A N D I R I",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 32),
              // Lottie loading animation di bawah tetap dipertahankan
              SizedBox(
                width: 70,
                height: 70,
                child: Lottie.asset('assets/animation/Sandy_Loading.json'),
              ),
              const SizedBox(height: 8),
              const Text(
                "Memuat aplikasi...",
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
