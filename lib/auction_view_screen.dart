import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class AuctionViewScreen extends StatefulWidget {
  final String id;
  const AuctionViewScreen({super.key, required this.id});

  @override
  State<AuctionViewScreen> createState() => _AuctionViewScreenState();
}

class _AuctionViewScreenState extends State<AuctionViewScreen> {
  Map<String, dynamic>? _auctionData;
  bool _isLoading = true;
  Timer? _timer;
  String _timeDisplay = '';
  List<dynamic> _bids = [];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchAuctionDetails();
    _fetchBids();
  }

  Future<void> _fetchAuctionDetails() async {
    try {
      String baseUrl = 'http://127.0.0.1:8080';
      if (!kIsWeb && Platform.isAndroid) {
        baseUrl = 'http://10.0.2.2:8080';
      }
      final response = await http.get(Uri.parse('$baseUrl/api/auctions/${widget.id}'));
      
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _auctionData = jsonDecode(response.body);
            _isLoading = false;
            _startTimer();
          });
        }
      } else {
        debugPrint('Failed to load auction: ${response.statusCode}');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching auction details: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchBids() async {
    try {
      String baseUrl = 'http://127.0.0.1:8080';
      if (!kIsWeb && Platform.isAndroid) {
        baseUrl = 'http://10.0.2.2:8080';
      }
      final response = await http.get(Uri.parse('$baseUrl/api/auctions/${widget.id}/bids'));

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _bids = jsonDecode(response.body);
          });
        }
      } else {
        debugPrint('Failed to load bids: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching bids: $e');
    }
  }

  void _startTimer() {
    if (_auctionData == null || _auctionData!['endTime'] == null) return;
    
    final endTime = DateTime.parse(_auctionData!['endTime']);
    
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final difference = endTime.difference(now);
      
      if (difference.isNegative) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _timeDisplay = 'Ended';
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _timeDisplay = _formatDuration(difference);
          });
        }
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> _submitBid(String amount) async {
    try {
      final prefs = await SharedPreferences.getInstance();

          // final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      
      // Try to get user_id as int or String
      // int? userId;
      // final userIdVal = prefs.get('user_id');
      // if (userIdVal is int) {
      //   userId = userIdVal;
      // } else if (userIdVal is String) {
      //   userId = int.tryParse(userIdVal);
      // }
      
      debugPrint('Retrieved userId: $userId');
      
      if (userId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please login to place a bid')),
          );
        }
        return;
      }

      String baseUrl = 'http://127.0.0.1:8080';
      if (!kIsWeb && Platform.isAndroid) {
        baseUrl = 'http://10.0.2.2:8080';
      }

      final url = Uri.parse('$baseUrl/api/auctions/${widget.id}/$userId/bid')
          .replace(queryParameters: {'amount': amount});

      debugPrint('Sending bid to: $userId');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('Bid response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bid placed successfully!')),
          );
          _fetchAuctionDetails();
          _fetchBids();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to place bid: ${response.body}')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error placing bid: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _showBidDialog() async {
    final TextEditingController bidController = TextEditingController();
    
      // final prefs = await SharedPreferences.getInstance();
      // final userId = prefs.getInt('user_id');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text('Place a Bid', style: GoogleFonts.lora(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current Price: ${_auctionData?['startingPrice'] ?? 0} KWD', 
                style: GoogleFonts.lora(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 10),
              TextField(
                controller: bidController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Bid Amount',
                  hintText: 'Enter amount',
                  suffixText: 'KWD',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.lora(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (bidController.text.isNotEmpty) {
                  await _submitBid(bidController.text);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Submit', style: GoogleFonts.lora(color: Colors.white)),
            ),
          ],
        );
      },
    ).then((_) => bidController.dispose());
  }

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
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _auctionData == null 
              ? const Center(child: Text('Auction not found'))
              : SingleChildScrollView(
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
    if (_auctionData == null) return const SizedBox.shrink();
    
    final storeName = _auctionData!['store'] != null ? _auctionData!['store']['storeName'] : 'Unknown Store';
   final storeEmail = _auctionData!['store'] != null ? _auctionData!['store']['email'] : 'Unknown Store';
   
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
            Text(storeEmail, style: GoogleFonts.lora(fontSize: 12, color: Colors.black54)),
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

  Widget _buildAuctionCard() {
    // Handle both camelCase and lowercase keys for image path
    final imagePath = _auctionData?['imagePath'] ?? _auctionData?['imagepath'];
  
    String imageUrl = imagePath != null
        ? 'https://eu2.contabostorage.com/6c70e9623145473d8a88b08bd2e0f73f:luwaapp/actionpost/$imagePath'
        : 'https://via.placeholder.com/300';

    String description = _auctionData?['description'] ?? 'No Description';

   String startingPrice = _auctionData?['startingPrice'] != null
        ? '${_auctionData!['startingPrice']} KWD'
        : 'N/A';

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
                Text(_timeDisplay.isEmpty ? 'Loading...' : _timeDisplay, style: GoogleFonts.lora(color: Colors.white, fontSize: 16)),
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
                Text(description, style: GoogleFonts.lora(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.favorite_border, color: Colors.white, size: 30),
                    Text(startingPrice, style: GoogleFonts.lora(color: Colors.white, fontSize: 18)),
                    ElevatedButton(
                      onPressed: () {
                        _showBidDialog();
                      },
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
    if (_bids.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 150,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)],
      ),
      child: Column(
        children: _bids.take(3).map((bid) {
          final amount = bid['bidAmount'] ?? bid['amount'] ?? '0';
          // Assuming user object is nested or we use a placeholder
          const userImage = 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
          
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(userImage),
                ),
                const SizedBox(width: 8),
                Text('$amount KWD', style: GoogleFonts.lora(fontSize: 14)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCurrentBid() {

   String startingPrice = _auctionData?['startingPrice'] != null
        ? '${_auctionData!['startingPrice']} KWD'
        : 'N/A';

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
              child: Text(startingPrice, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Icon(Icons.timer, size: 30, color: Colors.red),
            const SizedBox(width: 10),
            Text(_timeDisplay.isEmpty ? 'Loading...' : _timeDisplay, style: const TextStyle(fontSize: 22, color: Colors.red, fontWeight: FontWeight.bold)),
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
