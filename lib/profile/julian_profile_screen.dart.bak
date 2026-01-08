import 'package:flutter/material.dart';

class JulianProfileScreen extends StatelessWidget {
  const JulianProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const skyBlue = Colors.lightBlue;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
          color: skyBlue,
        ),
        title: const Text(
          'Profile Developer',
          style: TextStyle(color: skyBlue, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Profile Section with Circle Design
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      'assets/images/juli.jpg',
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person_pin_rounded,
                          size: 100,
                          color: skyBlue,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Name Section
            const Text(
              'Julian Arwansyah',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2C3E50),
              ),
            ),
            const Text(
              'JUNIOR SOFTWARE ANTUSIAS',
              style: TextStyle(
                fontSize: 16,
                color: skyBlue,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 40),

            // Grid Info Section (2x2)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildGridCard(
                    icon: Icons.badge_outlined,
                    title: 'NIM',
                    value: '1123150112',
                    color: skyBlue,
                  ),
                  _buildGridCard(
                    icon: Icons.account_balance_outlined,
                    title: 'Kampus',
                    value: 'Global',
                    color: skyBlue,
                  ),
                  _buildGridCard(
                    icon: Icons.terminal_rounded,
                    title: 'Role',
                    value: 'JUNIOR SOFTWARE DEVELOPER',
                    color: skyBlue,
                  ),
                  _buildGridCard(
                    icon: Icons.auto_graph_rounded,
                    title: 'Skill',
                    value: 'LARAVEL, DAN FLUTTER',
                    color: skyBlue,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Motivation "Speech Bubble" Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: skyBlue.withValues(alpha: 0.08),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                border: Border.all(color: skyBlue.withValues(alpha: 0.2)),
              ),
              child: const Column(
                children: [
                  Icon(Icons.format_quote_rounded, color: skyBlue, size: 32),
                  SizedBox(height: 12),
                  Text(
                    "Jangan menunggu kesempatan, ciptakanlah kesempatan itu sendiri.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF34495E),
                      height: 1.5,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildGridCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
