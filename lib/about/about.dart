import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile UI',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF3F8FE), // Background biru muda
        primarySwatch: Colors.blue,
        fontFamily: 'sans-serif',
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Header ---
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Profil", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                   // ... Header code ...
                
                // --- Kartu Biru User ---
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2B65F0), Color(0xFF5C8DF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF2B65F0).withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Row(children: []), // Isi Row Kosong dulu
                ),
                const SizedBox(height: 25),
                      child: const Icon(Icons.notifications_none, color: Colors.blue),
                  ]
                    )
              ]

                ),
                const SizedBox(height: 20),
          
                      ),
                    ),
                  
                ),
      )
    
    
            
  }
}