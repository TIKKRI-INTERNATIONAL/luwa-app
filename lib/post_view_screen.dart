import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class PostViewScreen extends StatefulWidget {
  final String id;
  const PostViewScreen({super.key, required this.id});

  @override
  State<PostViewScreen> createState() => _PostViewScreenState();
}

class _PostViewScreenState extends State<PostViewScreen> {
  Map<String, dynamic>? _postData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPostDetails();
  }

  Future<void> _fetchPostDetails() async {
    try {
      String baseUrl = 'http://127.0.0.1:8080';
      if (!kIsWeb && Platform.isAndroid) {
        baseUrl = 'http://10.0.2.2:8080';
      }
      final response = await http.get(Uri.parse('$baseUrl/api/storeimageposts/${widget.id}'));
      
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _postData = jsonDecode(response.body);
            _isLoading = false;
          });
        }
      } else {
        debugPrint('Failed to load post: ${response.statusCode}');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching post details: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Viewing Post ID: ${widget.id}');
    return Scaffold(
      backgroundColor: const Color(0xFFEAE8E1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black, size: 30),
        title: _buildProfileHeader(),
        actions: const [Icon(Icons.email_outlined, color: Colors.black, size: 30), SizedBox(width: 16)],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _postData == null 
              ? const Center(child: Text('Post not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildPostCard(),
                      const SizedBox(height: 20),
                      _buildDescriptionBox(),
                      const SizedBox(height: 20),
                      _buildActionIcons(),
                    ],
                  ),
                ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildProfileHeader() {
    if (_postData == null) {
      return const SizedBox.shrink();
    }
    
    final storeName = _postData!['store'] != null ? _postData!['store']['storeName'] : 'Unknown Store';
    final storeEmail = _postData!['store'] != null ? _postData!['store']['email'] : 'Unknown Store';
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
            Text(storeName ?? 'Unknown Store', style: GoogleFonts.lora(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            Text(storeEmail ?? 'Unknown Store', style: GoogleFonts.lora(fontSize: 12, color: Colors.black54)),
            Row(
              children: [
                const Icon(Icons.public, size: 14, color: Colors.black54),
                const SizedBox(width: 4),
                Text('Boxbee.com/', style: GoogleFonts.lora(fontSize: 12, color: Colors.black54)),
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

  Widget _buildPostCard() {
    // Handle both camelCase and lowercase keys for image path
    final imagePath = _postData?['imagepath'] ?? _postData?['imagePath'];
      final storeName = _postData!['store'] != null ? _postData!['store']['storeName'] : 'Unknown Store';
   
    String imageUrl = imagePath != null
        ? 'https://eu2.contabostorage.com/6c70e9623145473d8a88b08bd2e0f73f:luwaapp/imagepostluwa/$imagePath'
        : 'https://via.placeholder.com/300';

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
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 250,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.broken_image)),
              );
            },
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Text(storeName ?? 'Unknown Store', style: GoogleFonts.lora(color: const Color.fromARGB(255, 227, 217, 217), fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Positioned(
            top: 0,
            right: 20,
            child: _buildTag('Post'),
          ),
          const Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.favorite_border, color: Colors.white, size: 30),
                Icon(Icons.chat_bubble_outline, color: Colors.white, size: 30),
                Icon(Icons.bookmark_border, color: Colors.white, size: 30),
                Icon(Icons.share_outlined, color: Colors.white, size: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionBox() {
    String description = _postData?['description'] ?? 'No description available.';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)],
      ),
      child: Text(
        description,
        textAlign: TextAlign.center,
        style: GoogleFonts.lora(fontSize: 16, color: Colors.black87, height: 1.5),
      ),
    );
  }

  Widget _buildActionIcons() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(Icons.brightness_4_outlined, size: 40, color: Colors.black),
        Icon(Icons.brightness_4_outlined, size: 40, color: Colors.black),
        Icon(Icons.brightness_4_outlined, size: 40, color: Colors.black),
        Icon(Icons.brightness_4_outlined, size: 40, color: Colors.black),
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
      painter: const _TagPainter(color: Color(0xFFD4C2B4)),
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
  const _TagPainter({required this.color});

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
