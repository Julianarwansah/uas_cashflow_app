import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _error;

  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
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

    _rotateController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (passController.text != confirmPassController.text) {
        throw Exception('Password tidak cocok!');
      }

      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passController.text,
          );
      final user = credential.user;

      if (!mounted) return;

      // Kembali ke halaman login setelah signup berhasil
      Navigator.pop(context);

      // Tampilkan snackbar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Akun berhasil dibuat! Silakan login dengan email: ${user?.email}',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Stack(
          children: [
            // Animated rotating circles background
            for (int index = 0; index < 3; index++)
              AnimatedBuilder(
                animation: _rotateController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle:
                        _rotateController.value *
                        2 *
                        math.pi *
                        (index % 2 == 0 ? 1 : -1),
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

            // Floating particles
            for (int index = 0; index < 6; index++)
              Positioned(
                top: 100.0 + (index * 120),
                left: (index % 2 == 0) ? 30.0 : null,
                right: (index % 2 != 0) ? 30.0 : null,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 2000 + (index * 300)),
                  curve: Curves.easeInOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: (value * 0.4).clamp(0.0, 0.4),
                      child: Transform.translate(
                        offset: Offset(0, -30 * value),
                        child: Container(
                          width: 10 + (index % 3) * 5.0,
                          height: 10 + (index % 3) * 5.0,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.4),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  onEnd: () {
                    if (mounted) {
                      setState(() {});
                    }
                  },
                ),
              ),

            // Main content
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),

                        // Logo with glow effect
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Glow effect
                            Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    const Color(
                                      0xFF60A5FA,
                                    ).withValues(alpha: 0.3),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),

                            // Logo container
                            ScaleTransition(
                              scale: _scaleAnimation,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF3B82F6,
                                      ).withValues(alpha: 0.4),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Lottie.asset(
                                  "assets/animation/Manage_Money.json",
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Title
                        Text(
                          "Daftar Sekarang!",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                offset: const Offset(0, 4),
                                blurRadius: 10,
                              ),
                              Shadow(
                                color: const Color(
                                  0xFF60A5FA,
                                ).withValues(alpha: 0.5),
                                offset: const Offset(0, 0),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Buat akun untuk mulai mengatur keuangan Anda",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withValues(alpha: 0.85),
                            letterSpacing: 0.3,
                          ),
                        ),

                        const SizedBox(height: 45),

                        // Name Field
                        _buildInputField(
                          controller: nameController,
                          icon: Icons.person_outline,
                          hint: "Nama Lengkap",
                        ),

                        const SizedBox(height: 20),

                        // Email Field
                        _buildInputField(
                          controller: emailController,
                          icon: Icons.email_outlined,
                          hint: "Email",
                        ),

                        const SizedBox(height: 20),

                        // Password Field
                        _buildInputField(
                          controller: passController,
                          icon: Icons.lock_outline,
                          hint: "Kata Sandi",
                          isPassword: true,
                        ),

                        const SizedBox(height: 20),

                        // Confirm Password Field
                        _buildInputField(
                          controller: confirmPassController,
                          icon: Icons.lock_outline,
                          hint: "Konfirmasi Kata Sandi",
                          isConfirmPassword: true,
                        ),

                        const SizedBox(height: 35),

                        // Signup Button
                        GestureDetector(
                          onTap: _isLoading ? null : _signup,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF60A5FA),
                                  Color(0xFF3B82F6),
                                  Color(0xFF2563EB),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF3B82F6,
                                  ).withValues(alpha: 0.5),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 8),
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: _isLoading
                                ? const Center(
                                    child: SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Daftar",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Error Message
                        if (_error != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.red.withValues(alpha: 0.5),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _error!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom Input Field
  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool isPassword = false,
    bool isConfirmPassword = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword
            ? _obscurePassword
            : (isConfirmPassword ? _obscureConfirmPassword : false),
        style: const TextStyle(color: Color(0xFF0F172A), fontSize: 16),
        decoration: InputDecoration(
          icon: Icon(icon, color: const Color(0xFF3B82F6), size: 24),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.black.withValues(alpha: 0.4),
            fontSize: 15,
          ),
          border: InputBorder.none,
          suffixIcon: (isPassword || isConfirmPassword)
              ? IconButton(
                  icon: Icon(
                    (isPassword ? _obscurePassword : _obscureConfirmPassword)
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: const Color(0xFF3B82F6),
                    size: 22,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isPassword) {
                        _obscurePassword = !_obscurePassword;
                      } else {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      }
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
