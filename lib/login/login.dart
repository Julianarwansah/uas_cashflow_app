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
  late Animation<double> fadeAnim;
  late Animation<double> scaleAnim;

  @override
  void initState() {
    super.initState();

    fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    scaleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

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
        child: SafeArea(
          child: FadeTransition(
            opacity: fadeAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 80),

                    ScaleTransition(
                      scale: scaleAnim,
                      child: const Icon(Icons.person, size: 100, color: Colors.white),
                    ),

                    const SizedBox(height: 30),

                    _inputField(
                      hint: "Email / Username",
                      icon: Icons.email_outlined,
                      controller: emailController,
                    ),
                    const SizedBox(height: 20),
                    _inputField(
                      hint: "Password",
                      icon: Icons.lock_outline,
                      controller: passController,
                      password: true,
                    ),

                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      ),
                      child: const Text("Masuk"),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}