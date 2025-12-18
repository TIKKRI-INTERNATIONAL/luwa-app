import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class AuctionListByStoreScreen extends StatefulWidget {
  final String storeId;
  const AuctionListByStoreScreen({super.key, required this.storeId});

  @override
  State<AuctionListByStoreScreen> createState() => _AuctionListByStoreScreenState();
}

class _AuctionListByStoreScreenState extends State<AuctionListByStoreScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> _auctions = [];
  bool _isLoadingAuctions = true;

  @override
  void initState() {
    super.initState();
    _fetchAuctions();
  }

  Future<void> _fetchAuctions() async {
    try {
      String baseUrl = 'http://127.0.0.1:8080';
      if (!kIsWeb && Platform.isAndroid) {
        baseUrl = 'http://10.0.2.2:8080';
      }
      final response =
          await http.get(Uri.parse('$baseUrl/api/auctions/store/${widget.storeId}'));
      
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            // Filter auctions by storeId locally since we are fetching all active auctions
            List<dynamic> allAuctions = jsonDecode(response.body);
            debugPrint('Store ID to match: ${widget.storeId}');
            if (allAuctions.isNotEmpty) {
               debugPrint('First auction sample: ${allAuctions.first}');
            }
            _auctions = allAuctions.where((auction) {
              // Check if auction has storeId and it matches
              String? auctionStoreId = auction['storeId']?.toString();
              
              // Fallback: Check if storeId is inside a nested 'store' object
              if (auctionStoreId == null && auction['store'] != null) {
                auctionStoreId = auction['store']['id']?.toString();
              }

              debugPrint('Checking auction ${auction['id']} with storeId: $auctionStoreId vs target: ${widget.storeId}');
              return auctionStoreId == widget.storeId;
            }).toList();
            debugPrint('Filtered auctions count: ${_auctions.length}');
            _isLoadingAuctions = false;
          });
        }
      } else {
        debugPrint('Failed to load auctions: ${response.statusCode}');
        if (mounted) {
          setState(() {
            _isLoadingAuctions = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching auctions: $e');
      if (mounted) {
        setState(() {
          _isLoadingAuctions = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFEAE8E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAE8E1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              GoRouter.of(context).pop();
            } else {
              GoRouter.of(context).go('/home');
            }
          },
        ),
        title: Text(
          'Store Auctions',
          style: GoogleFonts.notoSerif(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoadingAuctions
          ? const Center(child: CircularProgressIndicator())
          : _auctions.isEmpty
              ? Center(
                  child: Text(
                    'No auctions found for this store.',
                    style: GoogleFonts.notoSerif(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _auctions.length,
                  itemBuilder: (context, index) {
                    final auction = _auctions[index];
                    String imageUrl =
                        'https://eu2.contabostorage.com/6c70e9623145473d8a88b08bd2e0f73f:luwaapp/actionpost/${auction['imagePath']}';

                    return Column(
                      children: [
                        _buildPostCard(
                          context,
                          imageUrl,
                          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                          auction['title'] ?? 'Auction',
                          'Auction',
                          id: auction['id']?.toString(),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
    );
  }

  Widget _buildPostCard(BuildContext context, String imageUrl, String avatarUrl,
      String title, String tag,
      {String? id}) {
    return GestureDetector(
      onTap: () {
        if (id != null) {
          GoRouter.of(context).go('/auction-view/$id');
        } else {
          GoRouter.of(context).go('/auction-view/0');
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
            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
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
