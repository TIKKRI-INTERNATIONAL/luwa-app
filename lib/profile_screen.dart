import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAE8E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAE8E1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black, size: 30),
          onPressed: () {},
        ),
        title: _buildProfileHeader(),
        actions: [
          IconButton(
            icon: const Icon(Icons.mail_outline, color: Colors.black, size: 30),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildPostCard(
            context,
            'https://images.unsplash.com/photo-1594223274512-ad4803739b7c?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            'Title',
            'Post',
          ),
          const SizedBox(height: 20),
          _buildPostCard(
            context,
            'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?q=80&w=2080&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            'Title',
            'Auction',
          ),
          const SizedBox(height: 20),
          _buildPostCard(
            context,
            'https://images.unsplash.com/photo-1546059593-3a8e1a7e2832?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            'Title',
            'Product',
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage('https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ali',
              style: GoogleFonts.notoSerif(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            Text(
              'Bio Owner of Aldanah Auction',
              style: GoogleFonts.notoSerif(fontSize: 12, color: Colors.black54),
            ),
            Row(
              children: [
                const Icon(Icons.language, size: 16, color: Colors.black54),
                const SizedBox(width: 4),
                Text(
                  'Boxbee.com/Test',
                  style: GoogleFonts.notoSerif(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                minimumSize: const Size(0, 30),
              ),
              child: Text(
                'Edit Profile',
                style: GoogleFonts.notoSerif(fontSize: 12),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildPostCard(BuildContext context, String imageUrl, String title, String tag) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            height: 250,
            width: double.infinity,
          ),
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                begin: Alignment.topLeft,
                end: Alignment.center,
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              title,
              style: GoogleFonts.notoSerif(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 20,
            child: _buildTag(tag),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String tag) {
    return CustomPaint(
      painter: _TagPainter(color: const Color(0xFFD4C2B4)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Text(
          tag,
          style: GoogleFonts.notoSerif(fontSize: 14, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomAppBar(
      color: const Color(0xFFC8C8C8),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, 0),
            _buildNavItem(Icons.search, 1),
            const SizedBox(width: 40), // The notch
            _buildNavItem(Icons.storefront_outlined, 2),
            _buildNavItem(Icons.gavel_outlined, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return IconButton(
      icon: Icon(icon, color: Colors.black54, size: 30),
      onPressed: () {},
    );
  }
}

class _TagPainter extends CustomPainter {
  final Color color;
  _TagPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2, size.height - 15)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
