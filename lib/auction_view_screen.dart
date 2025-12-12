import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuctionViewScreen extends StatelessWidget {
  const AuctionViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAE8E1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black, size: 30),
        title: _buildProfileHeader(),
        actions: const [Icon(Icons.email_outlined, color: Colors.black, size: 30), SizedBox(width: 16)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAuctionCard(),
            const SizedBox(height: 20),
            _buildBiddingSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage('https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ali', style: GoogleFonts.lora(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            Text('Bio Owner of Aldanah Auction', style: GoogleFonts.lora(fontSize: 12, color: Colors.black54)),
            Row(
              children: [
                const Icon(Icons.public, size: 14, color: Colors.black54),
                const SizedBox(width: 4),
                Text('Boxbee.com/Test', style: GoogleFonts.lora(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ],
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildAuctionCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?q=80&w=2080&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            fit: BoxFit.cover,
            height: 250,
            width: double.infinity,
          ),
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, color: Colors.white, size: 20),
                const SizedBox(width: 5),
                Text('11 : 45', style: GoogleFonts.lora(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 20,
            child: _buildTag('Auction'),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Product Title', style: GoogleFonts.lora(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.favorite_border, color: Colors.white, size: 30),
                    Text('start 100 kd', style: GoogleFonts.lora(color: Colors.white, fontSize: 18)),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Bid', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiddingSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBiddersList(),
        const SizedBox(width: 20),
        _buildCurrentBid(),
      ],
    );
  }

  Widget _buildBiddersList() {
    final bidders = [
      {'image': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 'amount': '1000 kd'},
      {'image': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 'amount': '700 kd'},
      {'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 'amount': '300 kd'},
    ];

    return Container(
      width: 150,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)],
      ),
      child: Column(
        children: bidders.map((bidder) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(bidder['image']!),
                ),
                const SizedBox(width: 8),
                Text(bidder['amount']!, style: GoogleFonts.lora(fontSize: 14)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCurrentBid() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.shopping_basket_outlined, size: 30, color: Colors.black54),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)],
              ),
              child: const Text('1400 kd', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Row(
          children: [
            Icon(Icons.timer, size: 30, color: Colors.red),
            SizedBox(width: 10),
            Text('14 : 20', style: TextStyle(fontSize: 22, color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
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
            IconButton(icon: const Icon(Icons.home_outlined, color: Colors.black54, size: 30), onPressed: () {}),
            IconButton(icon: const Icon(Icons.search, color: Colors.black54, size: 30), onPressed: () {}),
            const SizedBox(width: 40), // The notch
            IconButton(icon: const Icon(Icons.storefront_outlined, color: Colors.black54, size: 30), onPressed: () {}),
            IconButton(icon: const Icon(Icons.gavel_outlined, color: Colors.black54, size: 30), onPressed: () {}),
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
