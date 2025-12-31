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
                // --- Header Header (Profil & Notif) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Profil",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1), // Fix: withValues
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.notifications_none, color: Colors.blue),
                    )
                  ],
                ),
                const SizedBox(height: 20),

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
                      BoxShadow(
                        color: const Color(0xFF2B65F0).withValues(alpha: 0.3), // Fix: withValues
                        blurRadius: 15,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          image: const DecorationImage(
                            image: NetworkImage('https://i.pravatar.cc/150?img=11'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Info User
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "test",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "test@gmail.com",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // --- Container Menu Putih ---
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.05), // Fix: withValues
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // 1. Menu Edit Profil
                      _buildMenuItem(
                        icon: Icons.person_outline,
                        iconColor: Colors.blue,
                        bgIconColor: Colors.blue.withValues(alpha: 0.1), // Fix: withValues
                        title: "Edit Profil",
                        subtitle: "Ubah foto dan nama",
                        onTap: () {
                          // Aksi edit profil
                        },
                      ),
                      
                      const Divider(height: 1, indent: 70, endIndent: 20),

                      // 2. Menu ABOUT
                      _buildMenuItem(
                        icon: Icons.info_outline,
                        iconColor: Colors.purple,
                        bgIconColor: Colors.purple.withValues(alpha: 0.1), // Fix: withValues
                        title: "About",
                        subtitle: "Informasi Mahasiswa",
                        onTap: () {
                          _showAboutBottomSheet(context);
                        },
                      ),

                      const Divider(height: 1, indent: 70, endIndent: 20),

                      // 3. Menu Keluar
                      _buildMenuItem(
                        icon: Icons.logout,
                        iconColor: Colors.red,
                        bgIconColor: Colors.red.withValues(alpha: 0.1), // Fix: withValues
                        title: "Keluar",
                        subtitle: "Logout dari akun",
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // --- Bottom Navigation Bar ---
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
  }

  // Widget Helper untuk Item Menu
  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required Color bgIconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgIconColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey, fontSize: 13),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  // --- LOGIC POPUP ABOUT ---
  void _showAboutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Garis handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                "About Team",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // --- DATA 1: Julian Arwansyah ---
              _buildStudentInfo(
                name: "Julian Arwansyah",
                nim: "1123150112",
                motivation: "\"Jangan menunggu kesempatan, ciptakanlah kesempatan itu sendiri.\"",
                color: Colors.blue,
              ),

              const SizedBox(height: 10),

              // --- DATA 2: Indra Nurul Kusuma ---
              _buildStudentInfo(
                name: "Indra Nurul Kusuma",
                nim: "1123150032",
                motivation: "\"Kesuksesan adalah hasil dari persiapan kecil yang dilakukan setiap hari.\"",
                color: Colors.orange,
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // Widget Helper untuk List Mahasiswa
  Widget _buildStudentInfo({
    required String name,
    required String nim,
    required String motivation,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)), // Fix: withValues
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2), // Fix: withValues
          child: Text(
            name[0], 
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          Row(
            children: [
              const Icon(Icons.badge, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                "NIM: $nim",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1), // Fix: withValues
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withValues(alpha: 0.2)), // Fix: withValues
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Motivation:",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                    // Error "uppercase" dihapus dari sini
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  motivation,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}