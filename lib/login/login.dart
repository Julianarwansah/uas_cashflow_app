import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool hidePassword = true;

  late AnimationController fadeCtrl;
  late AnimationController scaleCtrl;
  late AnimationController rotateCtrl;
  late Animation<double> fadeAnim;
  late Animation<double> scaleAnim;

  @override
  void initState() {
    super.initState();

    fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    scaleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    rotateCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 40))
      ..repeat();

    fadeAnim = Tween<double>(begin: 0, end: 1).animate(fadeCtrl);
    scaleAnim = Tween<double>(begin: 0.8, end: 1).animate(CurvedAnimation(
      parent: scaleCtrl,
      curve: Curves.elasticOut,
    ));

    fadeCtrl.forward();
    scaleCtrl.forward();
  }

  @override
  void dispose() {
    fadeCtrl.dispose();
    scaleCtrl.dispose();
    rotateCtrl.dispose();
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  Widget _inputField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool password = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: TextField(
        controller: controller,
        obscureText: password ? hidePassword : false,
       decoration: InputDecoration(
          icon: Icon(icon, color: Colors.blue),
          hintText: hint,
          border: InputBorder.none,
          suffixIcon: password
              ? IconButton(
                  icon: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.blue,
                  ),
                  onPressed: () => setState(() => hidePassword = !hidePassword),
                )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF3B82F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Stack(
          children: [
            // rotating circles
            for (int index = 0; index < 3; index++)
              AnimatedBuilder(
                animation: rotateCtrl,
                builder: (context, child) {
                  final direction = (index % 2 == 0) ? 1 : -1;
                  return Transform.rotate(
                    angle: rotateCtrl.value * 2 * math.pi * direction,
                    child: child,
                  );
                },

                child: Center(
                  child: Container(
                    width: 220.0 + (index * 120),
                    height: 220.0 + (index * 120),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.05),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

              for (int i = 0; i < 6; i++)
              Positioned(
                top: 80.0 + i * 100,
                left: (i % 2 == 0) ? 24.0 : null,
                right: (i % 2 != 0) ? 24.0 : null,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 1800 + i * 250),
                  curve: Curves.easeInOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: (value * 0.35).clamp(0.0, 0.35),
                      child: Transform.translate(
                        offset: Offset(0, -20 * value),
                        child: Container(
                          width: 8.0 + (i % 3) * 4.0,
                          height: 8.0 + (i % 3) * 4.0,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.2),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
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

         SafeArea(
              child: FadeTransition(
                opacity: fadeAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                        Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFF60A5FA).withOpacity(0.28),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF3B82F6).withOpacity(0.35),
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
                        ],
                      ),

                      const SizedBox(height: 30),

                      ScaleTransition(
                        scale: scaleAnim,
                        child: const Text(
                          "Selamat Datang!",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      _inputField(
                        hint: "Email / Username",
                        icon: Icons.email_outlined,
                        controller: emailController,
                      ),
                      const SizedBox(height: 18),
                      _inputField(
                        hint: "Password",
                        icon: Icons.lock_outline,
                        controller: passController,
                        password: true,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        ),
                        child: const Text("Masuk"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}