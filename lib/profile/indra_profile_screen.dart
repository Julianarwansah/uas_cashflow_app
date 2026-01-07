import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppTheme.textPrimary),
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
            // Mengganti Container awal dengan struktur Stack + ClipOval
            Center(
              child: Container(
                width: 180,
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
                      Container(color: Colors.orange.shade100),
                      const Center(
                        child: Icon(Icons.person, size: 80, color: Colors.orange),
                      ),
                      Image.asset(
                        'assets/images/indra.png',
                        fit: BoxFit.cover, 
                        alignment: Alignment.topCenter,
                        errorBuilder: (context, error, stackTrace) => Container(), 
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 24),
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

            
    Widget _buildAboutCard({
    required String name,
    required String nim,
    required String motivation,
    required Color color,
    VoidCallback? onTap, // New parameter
  }) { ... }
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // ... decoration code ...
        child: Column(
          children: [
             Row(
               children: [
                 // ... avatar and text ...
                 if (onTap != null) ...[ // Tanda panah jika bisa diklik
                    const Spacer(),
                    Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color),
                 ]
               ]
             )
             // ... motivation text ...
          ]
        )
      )
    );
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTheme.bodyMedium.copyWith(color: Colors.grey)),
            Text(value, style: AppTheme.titleMedium),
          ],
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
                   // Items will go here
                ],
              ),
            ),
        ),
      ],
    );
  }
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
                    value: "Mancing dan Strike",
                    color: Colors.red,
                  ),
        ),
        const SizedBox(height: 24),
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
                  // Text akan ditambahkan nanti
                ],
              ),
            ),
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
        
      ),
    );
    
  }
}