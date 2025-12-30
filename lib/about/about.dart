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
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 60, height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          image: const DecorationImage(
                            image: NetworkImage('https://i.pravatar.cc/150?img=11'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 15),

                    // ... Avatar code ...
                      
                      // Info User
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("test", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("test@gmail.com", style: TextStyle(color: Colors.white70, fontSize: 14)),
                        ],
                      ),

                    ],
                  ),

                  ),
                const SizedBox(height: 25),
                      child: const Icon(Icons.notifications_none, color: Colors.blue),
                  ]
                    )
                    // --- Container Menu Putih ---
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Column(
                    children: [],
                  ),
                ),
                
                children: [
                      _buildMenuItem(
                        icon: Icons.person_outline, iconColor: Colors.blue, bgIconColor: Colors.blue.withValues(alpha: 0.1),
                        title: "Edit Profil", subtitle: "Ubah foto dan nama", onTap: () {},
                      ),
                      const Divider(height: 1, indent: 70, endIndent: 20),
                      
                      // Disini nanti tempat About

                      _buildMenuItem(
                        icon: Icons.logout, iconColor: Colors.red, bgIconColor: Colors.red.withValues(alpha: 0.1),
                        title: "Keluar", subtitle: "Logout dari akun", onTap: () {},
                      ),
                    ],
                    
              ]
              

                ),
                const SizedBox(height: 20),
          
                      ),
                    ),
                  
                ),
      )
      return Scaffold(
      body: ..., // code body yg tadi
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        currentIndex: 2, 
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Swap'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
    
    // ... Penutup method build ...

  Widget _buildMenuItem({
    required IconData icon, required Color iconColor, required Color bgIconColor,
    required String title, required String subtitle, required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: bgIconColor, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }
}
            
  }
