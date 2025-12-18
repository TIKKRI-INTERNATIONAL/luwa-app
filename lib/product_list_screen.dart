import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> _products = [];
  bool _isLoadingProducts = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      String baseUrl = 'http://127.0.0.1:8080';
      if (!kIsWeb && Platform.isAndroid) {
        baseUrl = 'http://10.0.2.2:8080';
      }
      final response =
          await http.get(Uri.parse('$baseUrl/api/products/all'));
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _products = jsonDecode(response.body);
            _isLoadingProducts = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoadingProducts = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
      if (mounted) {
        setState(() {
          _isLoadingProducts = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: const Color(0xFFEAE8E1),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: Text('Home', style: GoogleFonts.notoSerif()),
              onTap: () {
                context.pop();
                context.go('/home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text('Profile', style: GoogleFonts.notoSerif()),
              onTap: () {
                context.pop();
                context.push('/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: Text('Products', style: GoogleFonts.notoSerif()),
              onTap: () {
                context.pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.gavel_outlined),
              title: Text('Auctions', style: GoogleFonts.notoSerif()),
              onTap: () {
                context.pop();
                context.push('/auction-list');
              },
            ),
            ListTile(
              leading: const Icon(Icons.store_mall_directory_outlined),
              title: Text('Store Registration', style: GoogleFonts.notoSerif()),
              onTap: () {
                context.pop();
                context.push('/store-registration');
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box_outlined),
              title:
                  Text('Product Registration', style: GoogleFonts.notoSerif()),
              onTap: () {
                context.pop();
                context.push('/product-registration');
              },
            ),
            ListTile(
              leading: const Icon(Icons.post_add_outlined),
              title:
                  Text('Auction Registration', style: GoogleFonts.notoSerif()),
              onTap: () {
                context.pop();
                context.push('/auction-post');
              },
            ),
            ListTile(
              leading: const Icon(Icons.post_add_outlined),
              title: Text('New Post', style: GoogleFonts.notoSerif()),
              onTap: () {
                context.pop();
                context.push('/new-post');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text('Logout',
                  style: GoogleFonts.notoSerif(color: Colors.red)),
              onTap: () {
                context.pop();
                context.go('/');
              },
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFEAE8E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAE8E1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black, size: 30),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text('Products', style: GoogleFonts.notoSerif(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _isLoadingProducts
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                String imageUrl = product['imagePath'] != null
                    ? 'https://eu2.contabostorage.com/6c70e9623145473d8a88b08bd2e0f73f:luwaapp/product/${product['imagePath']}'
                    : 'https://images.unsplash.com/photo-1546059593-3a8e1a7e2832?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

                return Column(
                  children: [
                    _buildPostCard(
                      context,
                      imageUrl,
                      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=1964&auto=format=fit&crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      product['productName'] ?? 'Product',
                      'Product',
                      id: product['id']?.toString(),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildPostCard(BuildContext context, String imageUrl, String avatarUrl,
      String title, String tag,
      {String? id}) {
    return GestureDetector(
      onTap: () {
        if (tag == 'Product') {
          if (id != null) {
            GoRouter.of(context).go('/product/$id');
          } else {
            GoRouter.of(context).go('/product/0');
          }
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
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Error loading image: $error');
                return Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        Text('Image not found',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Gradient overlay for better text visibility
            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent
                  ],
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
        if (index == 0) {
          GoRouter.of(context).go('/home');
        } else if (index == 2) {
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
