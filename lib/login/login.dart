import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        controller: controller,
        obscureText: password ? hidePassword : false,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          icon: Icon(icon, color: Colors.blue),
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
      body: FadeTransition(
        opacity: fadeAnim,
        child: Center(
          child: ScaleTransition(
            scale: scaleAnim,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _inputField(
                    hint: "Email",
                    icon: Icons.email,
                    controller: emailController,
                  ),
                  const SizedBox(height: 20),
                  _inputField(
                    hint: "Password",
                    icon: Icons.lock,
                    controller: passController,
                    password: true,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 14),
                      child: Text("Login"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}