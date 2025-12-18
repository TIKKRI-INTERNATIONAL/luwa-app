import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class ProductScreen extends StatefulWidget {
  final String id;
  const ProductScreen({super.key, required this.id});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Map<String, dynamic>? _product;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    if (widget.id == '0') {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      String baseUrl = 'http://127.0.0.1:8080';
      if (!kIsWeb && Platform.isAndroid) {
        baseUrl = 'http://10.0.2.2:8080';
      }
      final response =
          await http.get(Uri.parse('$baseUrl/api/products/${widget.id}'));

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _product = jsonDecode(response.body);
            _isLoading = false;
          });
        }
      } else {
        debugPrint('Failed to load product: ${response.statusCode}');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching product details: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFEAE8E1),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEAE8E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAE8E1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
          onPressed: () {
            context.go('/home');
          },
        ),
        title: GestureDetector(
          onTap: () => context.go('/profile'),
          child: _buildProfileHeader(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mail_outline, color: Colors.black, size: 30),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProductCard(context),
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
    final storeName = _product!['storeName'] != null
        ? _product!['storeName']
        : 'Unknown Store';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              storeName,
              style: GoogleFonts.notoSerif(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Product Seller',
              style: GoogleFonts.notoSerif(fontSize: 12, color: Colors.black54),
            ),
            Row(
              children: [
                const Icon(Icons.language, size: 16, color: Colors.black54),
                const SizedBox(width: 4),
                Text(
                  'Boxbee.com/Test',
                  style: GoogleFonts.notoSerif(
                      fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
            // ElevatedButton(
            //   onPressed: () {},
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.black,
            //     foregroundColor: Colors.white,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            //     minimumSize: const Size(0, 30),
            //   ),
            //   child: Text(
            //     'Edit Profile',
            //     style: GoogleFonts.notoSerif(fontSize: 12),
            //   ),
            // )
          ],
        ),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context) {
    String imageUrl =
        'https://images.unsplash.com/photo-1546059593-3a8e1a7e2832?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
    String title = 'Product Title';
    String price = '12 kd';

    String startingPrice =
        _product?['price'] != null ? '${_product!['price']} KWD' : 'N/A';

    if (_product != null) {
      if (_product!['imagePath'] != null) {
        imageUrl =
            'https://eu2.contabostorage.com/6c70e9623145473d8a88b08bd2e0f73f:luwaapp/product/${_product!['imagePath']}';
      }
      title = _product!['productName'] ?? 'Product Title';
      price = _product?['price'] != null ? '${_product!['price']} KWD' : 'N/A';
    }

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
                child: const Center(child: Icon(Icons.broken_image, size: 50)),
              );
            },
          ),
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                  Colors.black.withOpacity(0.6)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
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
            child: _buildTag('Product'),
          ),
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.favorite_border,
                    color: Colors.white, size: 30),
                Text(
                  price,
                  style: GoogleFonts.notoSerif(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.shopping_basket_outlined,
                    color: Colors.white, size: 30),
              ],
            ),
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

  Widget _buildDescriptionBox() {
    String description =
        'story you can say about your Product write a small description make the user interact with';
    if (_product != null && _product!['description'] != null) {
      description = _product!['description'];
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        description,
        textAlign: TextAlign.center,
        style: GoogleFonts.notoSerif(fontSize: 16, color: Colors.black87),
      ),
    );
  }

  Widget _buildActionIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
          4,
          (_) => const Icon(Icons.brightness_7_outlined,
              color: Colors.black, size: 40)),
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
