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
   Widget _inputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool password = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: password ? hidePassword : false,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.blue),
          hintText: label,
          border: InputBorder.none,
          suffixIcon: password
              ? IconButton(
                  icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility),
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E3A8A),
              Color(0xFF3B82F6),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _inputField(
                  label: "Email",
                  icon: Icons.email,
                  controller: emailController,
                ),
                const SizedBox(height: 15),
                _inputField(
                  label: "Password",
                  icon: Icons.lock,
                  controller: passController,
                  password: true,
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                    onPressed: () {},
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 35, vertical: 12),
                      child: Text("Login"),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}