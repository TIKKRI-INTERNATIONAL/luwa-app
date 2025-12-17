import 'dart:io';
import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
  }



  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _uploadPost() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a description')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userEmail = prefs.getString('user_email');
      final userId = prefs.getInt('user_id');

      if (token == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Authentication token not found. Please login again.')),
          );
        }
        return;
      }

      debugPrint('User Email: $userEmail');
      debugPrint('User ID: $userId');

      String baseUrl = 'http://127.0.0.1:8080';
      if (!kIsWeb && Platform.isAndroid) {
        baseUrl = 'http://10.0.2.2:8080';
      }

      // Attempt to find the store ID associated with the logged-in user
      String? storeId;
      try {
        final storesResponse = await http.get(Uri.parse('$baseUrl/api/stores'));
        if (storesResponse.statusCode == 200) {
          final List<dynamic> stores = jsonDecode(storesResponse.body);
          final myStore = stores.firstWhere(
            (store) => store['email'].toString().trim().toLowerCase() == userEmail?.trim().toLowerCase(),
            orElse: () => null,
          );
          if (myStore != null) {
            storeId = myStore['id'].toString();
            debugPrint('Found Store ID: $storeId for user: $userEmail');
          } else {
            debugPrint('Store not found for email: $userEmail');
          }
        } else {
          debugPrint('Failed to fetch stores: ${storesResponse.statusCode}');
        }
      } catch (e) {
        debugPrint('Error fetching store ID: $e');
      }

      String finalStoreId = storeId ?? userId?.toString() ?? '1';
      debugPrint('Final Store ID to use: $finalStoreId');

      // Add storeId as query parameter
      Uri uri = Uri.parse('$baseUrl/api/storeimageposts/upload').replace(queryParameters: {
        'storeId': finalStoreId,
      });

      var request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $token';
      // Add Content-Type header explicitly for multipart
      // request.headers['Content-Type'] = 'multipart/form-data'; // http package adds this automatically with boundary

      // Add storeId to fields as well (both camelCase and snake_case)
      request.fields['storeId'] = finalStoreId;
      request.fields['store_id'] = finalStoreId;

      // Determine content type
      MediaType? mediaType;
      if (_imageFile!.name.toLowerCase().endsWith('.jpg') || 
          _imageFile!.name.toLowerCase().endsWith('.jpeg')) {
        mediaType = MediaType('image', 'jpeg');
      } else if (_imageFile!.name.toLowerCase().endsWith('.png')) {
        mediaType = MediaType('image', 'png');
      }

      // Add the image file
      if (kIsWeb) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            await _imageFile!.readAsBytes(),
            filename: _imageFile!.name,
            contentType: mediaType,
          ),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            _imageFile!.path,
            contentType: mediaType,
          ),
        );
      }

      // Add the description
      request.fields['description'] = _descriptionController.text.trim();
      
      debugPrint('Uploading to: $baseUrl/api/storeimageposts/upload');
      debugPrint('Description: ${_descriptionController.text.trim()}');

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post uploaded successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          // Clear the form
          setState(() {
            _imageFile = null;
            _descriptionController.clear();
          });
        }
      } else if (response.statusCode == 403) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Permission denied. You must be a registered store or Admin to post.'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Register',
                textColor: Colors.white,
                onPressed: () {
                  context.push('/store-registration');
                },
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Upload failed: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error uploading post: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
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
                context.push('/product');
              },
            ),
            ListTile(
              leading: const Icon(Icons.gavel_outlined),
              title: Text('Auctions', style: GoogleFonts.notoSerif()),
              onTap: () {
                context.pop();
                context.push('/auction');
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
              title: Text('Product Registration', style: GoogleFonts.notoSerif()),
              onTap: () {
                context.pop();
                context.push('/product-registration');
              },
            ),
            ListTile(
              leading: const Icon(Icons.post_add_outlined),
              title: Text('Auction Registration', style: GoogleFonts.notoSerif()),
              onTap: () {
                context.pop();
                context.push('/auction-post');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text('Logout', style: GoogleFonts.notoSerif(color: Colors.red)),
              onTap: () {
                context.pop();
                context.go('/');
              },
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        title: Text('New Post', style: GoogleFonts.notoSerif(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(30),
                  color: Colors.black54,
                  strokeWidth: 1,
                  dashPattern: const [6, 3],
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      image: _imageFile != null
                          ? DecorationImage(
                              image: kIsWeb
                                  ? NetworkImage(_imageFile!.path)
                                  : FileImage(File(_imageFile!.path)) as ImageProvider,
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _imageFile == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload_outlined, size: 50, color: Colors.black54),
                              SizedBox(height: 10),
                              Text('Upload Image', style: TextStyle(color: Colors.black54)),
                            ],
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField("Description", maxLines: 5),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isUploading ? null : _uploadPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: _isUploading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Post',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildTextField(String labelText, {int maxLines = 1}) {
    return TextField(
      controller: _descriptionController,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
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
          context.go('/home');
        } else if (index == 2) {
          context.go('/stores');
        } else if (index == 3) {
          context.go('/auction');
        }
      },
    );
  }
}
