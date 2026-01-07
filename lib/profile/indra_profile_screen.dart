import 'package:flutter/material.dart';
import '../theme/app_theme.dart'; // Pastikan path ini benar sesuai struktur foldermu

class IndraProfileScreen extends StatelessWidget {
  const IndraProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppTheme.softShadow,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: AppTheme.textPrimary,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Detail Anggota', style: AppTheme.titleLarge),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // --- BAGIAN FOTO PROFIL (Stack + ClipOval) ---
            Center(
              child: Container(
                width: 180, // Ukuran lingkaran (Diameter)
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: AppTheme.softShadow,
                  border: Border.all(color: Colors.white, width: 4), 
                ),
                child: ClipOval(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Layer 1: Background Warna (Jika foto transparan)
                      Container(color: Colors.orange.shade100),

                      // Layer 2: Icon Placeholder (Di tengah belakang foto)
                      const Center(
                        child: Icon(
                          Icons.person,
                          size: 80, 
                          color: Colors.orange,
                        ),
                      ),

                      // Layer 3: Foto Asli
                      Image.asset(
                        'assets/images/indra.png', // Pastikan nama file sesuai
                        fit: BoxFit.cover, 
                        alignment: Alignment.topCenter, // Agar wajah tidak terpotong
                        errorBuilder: (context, error, stackTrace) {
                          // Jika error, tampilkan transparan agar icon di Layer 2 terlihat
                          return Container(); 
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ------------------------------------------

            const SizedBox(height: 24),
            
            // Info Utama
            Text(
              "Indra Nurul Kusuma",
              style: AppTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "NIM: 1123150032",
                style: AppTheme.titleMedium.copyWith(color: Colors.orange[800]),
              ),
            ),

            const SizedBox(height: 32),

            // Detail Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppTheme.softShadow,
              ),
              child: Column(
                children: [
                  _buildDetailItem(
                    icon: Icons.school_rounded,
                    title: "Universitas",
                    value: "Bina Sarana Global",
                    color: Colors.blue,
                  ),
                  const Divider(height: 30),
                  _buildDetailItem(
                    icon: Icons.code_rounded,
                    title: "Peran",
                    value: "Mobile Developer",
                    color: Colors.purple,
                  ),
                  const Divider(height: 30),
                  _buildDetailItem(
                    icon: Icons.favorite_rounded,
                    title: "Hobi",
                    value: "Mancing & Strike!",
                    color: Colors.red,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Motivasi
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade400, Colors.orange.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                children: [
                  const Icon(Icons.format_quote_rounded, color: Colors.white, size: 30),
                  const SizedBox(height: 10),
                  Text(
                    "Kesuksesan adalah hasil dari persiapan kecil yang dilakukan setiap hari.",
                    textAlign: TextAlign.center,
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTheme.bodyMedium.copyWith(color: Colors.grey)),
            Text(value, style: AppTheme.titleMedium),
          ],
        ),
      ],
    );
  }
}