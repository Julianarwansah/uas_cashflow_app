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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(18),
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E3A8A),
              Color(0xFF3B82F6),
            ],
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

         SafeArea(
              child: FadeTransition(
                opacity: fadeAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      ScaleTransition(
                        scale: scaleAnim,
                        child: const Icon(Icons.person, size: 96, color: Colors.white),
                      ),

                    const SizedBox(height: 30),
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
                      const SizedBox(height: 28),
                      ElevatedButton(onPressed: () {}, child: const Text("Masuk")),
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
