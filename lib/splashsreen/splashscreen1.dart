import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math;

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({super.key});

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}
late AnimationController _fadeController;
late AnimationController _scaleController;
late AnimationController _rotateController;
late AnimationController _pulseController;
late Animation<double> _fadeAnimation;
late Animation<double> _scaleAnimation;
late Animation<double> _pulseAnimation;

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

  _rotateController = AnimationController(
    duration: const Duration(seconds: 20),
    vsync: this,
  )..repeat();

  _pulseController = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  )..repeat(reverse: true);

  _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
  );

  _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
    CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
  );

  _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
    CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
  );

  _fadeController.forward();
  _scaleController.forward();

  Future.delayed(const Duration(seconds: 10), () {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/splash2');
  });
}


class _SplashScreen1State extends State<SplashScreen1>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0F172A),
                Color(0xFF1E40AF),
                Color(0xFF3B82F6),
                Color(0xFF60A5FA),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
Stack(
  children: [
    for (int index = 0; index < 3; index++)
      AnimatedBuilder(
        animation: _rotateController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotateController.value * 2 * math.pi * (index % 2 == 0 ? 1 : -1),
            child: child,
          );
        },
        child: Center(
          child: Container(
            width: 300.0 + (index * 100),
            height: 300.0 + (index * 100),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
                width: 2,
              ),
            ),
          ),
        ),
      ),
  ],
)
for (int index = 0; index < 8; index++)
  Positioned(
    top: 50.0 + (index * 80),
    left: (index % 2 == 0) ? 30.0 : null,
    right: (index % 2 != 0) ? 30.0 : null,
    child: TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1500 + (index * 200)),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: (value * 0.6).clamp(0.0, 0.6),
          child: Transform.translate(
            offset: Offset(0, -20 * value),
            child: Container(
              width: 8 + (index % 3) * 4.0,
              height: 8 + (index % 3) * 4.0,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
      onEnd: () {
        if (mounted) setState(() {});
      },
    ),
  ),
