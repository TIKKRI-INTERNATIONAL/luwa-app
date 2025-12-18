import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class ProductRegistrationScreen extends StatefulWidget {
  const ProductRegistrationScreen({super.key});

  @override
  State<ProductRegistrationScreen> createState() =>
      _ProductRegistrationScreenState();
}

class _ProductRegistrationScreenState extends State<ProductRegistrationScreen> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _skuController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _registerProduct() async {
    if (_imageFile == null ||
        _nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _skuController.text.isEmpty ||
        _categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String baseUrl = 'http://127.0.0.1:8080';
      if (!kIsWeb && Platform.isAndroid) {
        baseUrl = 'http://10.0.2.2:8080';
      }

      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('user_email');
      debugPrint('Current User Email: $userEmail');

      String? storeId;
      try {
        final storesResponse = await http.get(Uri.parse('$baseUrl/api/stores'));
        debugPrint('Stores API Response: ${storesResponse.statusCode}');
        if (storesResponse.statusCode == 200) {
          final List<dynamic> stores = jsonDecode(storesResponse.body);
          debugPrint('Found ${stores.length} stores');
          final myStore = stores.firstWhere(
            (store) {
              final storeEmail = store['email'].toString().trim().toLowerCase();
              final currentEmail = userEmail?.trim().toLowerCase();
              // debugPrint('Checking store: $storeEmail vs $currentEmail');
              return storeEmail == currentEmail;
            },
            orElse: () => null,
          );
          if (myStore != null) {
            storeId = myStore['id'].toString();
            debugPrint('Found Store ID: $storeId');
          }
        }
      } catch (e) {
        debugPrint('Error fetching store ID: $e');
      }

      if (storeId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Store not found for current user')),
          );
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/stores/products/register/$storeId'),
      );

      final Map<String, dynamic> productData = {
        'productName': _nameController.text,
        'description': _descriptionController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'sku': _skuController.text,
        'category': _categoryController.text,
      };
      request.fields['storeId'] = storeId;
      request.files.add(http.MultipartFile.fromString(
        'product',
        jsonEncode(productData),
        contentType: MediaType('application', 'json'),
      ));

      if (kIsWeb) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          await _imageFile!.readAsBytes(),
          filename: 'product.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      } else {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _imageFile!.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product registered successfully!')),
          );
          context.go('/product/0');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Failed to register product: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
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
                context.push('/product-list');
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
      appBar: AppBar(
        title: Text('Product Registration',
            style: GoogleFonts.notoSerif(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildTextField("Product Name", _nameController),
              const SizedBox(height: 15),
              _buildTextField("Description", _descriptionController),
              const SizedBox(height: 15),
              _buildTextField("Price", _priceController),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: _pickImage,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(30),
                  color: Colors.black54,
                  strokeWidth: 1,
                  dashPattern: const [6, 3],
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      image: _imageFile != null
                          ? DecorationImage(
                              image: kIsWeb
                                  ? NetworkImage(_imageFile!.path)
                                  : FileImage(File(_imageFile!.path))
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _imageFile == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload_outlined,
                                  size: 40, color: Colors.black54),
                              SizedBox(height: 5),
                              Text('Upload Product Image',
                                  style: TextStyle(color: Colors.black54)),
                            ],
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              _buildTextField("SKU", _skuController),
              const SizedBox(height: 15),
              _buildTextField("Category", _categoryController),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _registerProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      ),
    );
  }
}
