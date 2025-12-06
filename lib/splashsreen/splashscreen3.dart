import 'package:flutter/material.dart';

class SplashScreen3 extends StatefulWidget {
  const SplashScreen3({super.key});

  @override
  State<SplashScreen3> createState() => _SplashScreen3State();
}

class _SplashScreen3State extends State<SplashScreen3> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _rotateController;
  late AnimationController _particlesController;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _rotateController.dispose();
    _particlesController.dispose();
    super.dispose();
  }


c@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F24),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // ROTATING CIRCLE
          AnimatedBuilder(
            animation: _rotateController,
            builder: (_, child) {
              return Transform.rotate(
                angle: _rotateController.value * 6.2831,
                child: child,
              );
            },
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    Colors.blue.shade800,
                    Colors.blue.shade400,
                    Colors.blue.shade800,
                  ],
                ),
              ),
            ),
          ),

          const Text(
            "Splash Screen 3",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}