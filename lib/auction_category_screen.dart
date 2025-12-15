import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class AuctionCategoryScreen extends StatefulWidget {
  const AuctionCategoryScreen({super.key});

  @override
  State<AuctionCategoryScreen> createState() => _AuctionCategoryScreenState();
}

class _AuctionCategoryScreenState extends State<AuctionCategoryScreen> {
  List<dynamic> _items = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      String baseUrl = 'http://127.0.0.1:8080';
      if (!kIsWeb && Platform.isAndroid) {
        baseUrl = 'http://10.0.2.2:8080';
      }

      debugPrint('Fetching data from $baseUrl/api/stores');

      final response = await http.get(Uri.parse('$baseUrl/api/stores'));

      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          _items = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load data: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCF6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFCF6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        title: _buildHeader(),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/auction-post');
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _errorMessage = null;
                          });
                          _fetchData();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                        child: const Text('Retry', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                )
              : _buildList(context),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationZ(0.5),
              child:
                  const Icon(Icons.auto_awesome, color: Colors.black, size: 30),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.gavel, color: Colors.white, size: 40),
            ),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationZ(-0.5),
              child:
                  const Icon(Icons.auto_awesome, color: Colors.black, size: 30),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Text(
          'Auction\nMenu',
          textAlign: TextAlign.center,
          style: GoogleFonts.lora(
            fontSize: 32,
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    if (_items.isEmpty) {
      return Center(
        child: Text(
          'No items found',
          style: GoogleFonts.notoSerif(fontSize: 18, color: Colors.black54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 20),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        // Try to find a name field, defaulting to 'Unknown'
        final name = item['storeName'] ?? item['name'] ?? 'Unknown';
        
        // Use a placeholder image if the API doesn't provide one
        const imageUrl = 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: const NetworkImage(imageUrl),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to details if needed
                    // context.go('/auction-view');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF8B7355),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Color(0xFF8B7355), width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  child: Text(
                    name,
                    style: GoogleFonts.notoSerif(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
