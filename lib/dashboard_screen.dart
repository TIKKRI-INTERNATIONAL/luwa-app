import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
        title: _buildStories(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildPostCard(
            context,
            'https://images.unsplash.com/photo-1594223274512-ad4803739b7c?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            'Title',
            'Post',
          ),
          const SizedBox(height: 20),
          _buildPostCard(
            context,
            'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?q=80&w=2080&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            'Title',
            'Auction',
          ),
          const SizedBox(height: 20),
          _buildPostCard(
            context,
            'https://images.unsplash.com/photo-1546059593-3a8e1a7e2832?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            'Title',
            'Product',
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildStories() {
    final stories = [
      {'image': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 'name': 'Ali', 'live': false},
      {'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 'name': 'Sara', 'live': true},
      {'image': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 'name': 'Noor', 'live': false},
      {'image': 'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 'name': 'Huda', 'live': false},
      {'image': 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 'name': 'Dana', 'live': false},
      {'image': 'https://images.unsplash.com/photo-1580489944761-15a19d654956?q=80&w=1961&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 'name': 'Alya', 'live': false},
    ];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(story['image'] as String),
                    ),
                    if (story['live'] as bool)
                      Positioned(
                        bottom: -5,
                        left: 15,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: const Color(0xFFEAE8E1), width: 2),
                          ),
                          child: const Text('live', style: TextStyle(color: Colors.white, fontSize: 10)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  story['name'] as String,
                  style: GoogleFonts.notoSerif(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, String imageUrl, String avatarUrl, String title, String tag) {
    return GestureDetector(
      onTap: () {
        if (tag == 'Product') {
          GoRouter.of(context).go('/product');
        } else if (tag == 'Post') {
          GoRouter.of(context).go('/post-view');
        }
      },
      child: Card(
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
            // Gradient overlay for better text visibility
            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.topLeft,
                  end: Alignment.center,
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(avatarUrl),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: GoogleFonts.notoSerif(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 20,
              child: _buildTag(tag),
            ),
          ],
        ),
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

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFFC8C8C8),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, Icons.home_outlined, 0),
            _buildNavItem(context, Icons.search, 1),
            const SizedBox(width: 40), // The notch
            _buildNavItem(context, Icons.storefront_outlined, 2),
            _buildNavItem(context, Icons.gavel_outlined, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, int index) {
    return IconButton(
      icon: Icon(icon, color: Colors.black54, size: 30),
      onPressed: () {
        if (index == 2) {
          GoRouter.of(context).go('/stores');
        } else if (index == 3) {
          GoRouter.of(context).go('/auction');
        }
      },
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
