import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuctionPostScreen extends StatefulWidget {
  const AuctionPostScreen({super.key});

  @override
  State<AuctionPostScreen> createState() => _AuctionPostScreenState();
}

class _AuctionPostScreenState extends State<AuctionPostScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  XFile? _pickedFile;
  final ImagePicker _picker = ImagePicker();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  DateTime? _selectedEndDate;
  TimeOfDay? _selectedEndTime;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
  }

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (!mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.black,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
        });
      }
    }
  }

  Future<void> _pickEndDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (!mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.black,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedEndDate = pickedDate;
          _selectedEndTime = pickedTime;
        });
      }
    }
  }

  Future<void> _postAuction() async {
    if (_pickedFile == null ||
        _titleController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null ||
        _selectedEndDate == null ||
        _selectedEndTime == null) {
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

      String? storeId;
      try {
        final storesResponse = await http.get(Uri.parse('$baseUrl/api/stores'));
        if (storesResponse.statusCode == 200) {
          final List<dynamic> stores = jsonDecode(storesResponse.body);
          final myStore = stores.firstWhere(
            (store) =>
                store['email'].toString().trim().toLowerCase() ==
                userEmail?.trim().toLowerCase(),
            orElse: () => null,
          );
          if (myStore != null) {
            storeId = myStore['id'].toString();
          }
        }
      } catch (e) {
        debugPrint('Error fetching store ID: $e');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/auctions'),
      );

      final DateTime startDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      final DateTime endDateTime = DateTime(
        _selectedEndDate!.year,
        _selectedEndDate!.month,
        _selectedEndDate!.day,
        _selectedEndTime!.hour,
        _selectedEndTime!.minute,
      );

      final Map<String, dynamic> auctionData = {
        'title': _titleController.text,
        'startingPrice': double.tryParse(_priceController.text) ?? 0.0,
        'description': _descriptionController.text,
        'startTime': startDateTime.toIso8601String(),
        'endTime': endDateTime.toIso8601String(),
        if (storeId != null) 'storeId': storeId,
      };
      request.fields['storeId'] = storeId ?? '1';
      request.files.add(http.MultipartFile.fromString(
        'auctionPost',
        jsonEncode(auctionData),
        contentType: MediaType('application', 'json'),
      ));

      if (kIsWeb) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          await _pickedFile!.readAsBytes(),
          filename: 'upload.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      } else {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _pickedFile!.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Auction posted successfully!')),
        );
        context.go('/auction');
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to post auction: ${response.statusCode}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        title: Text('New Auction',
            style: GoogleFonts.notoSerif(color: Colors.black)),
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
                      image: _pickedFile != null
                          ? DecorationImage(
                              image: kIsWeb
                                  ? NetworkImage(_pickedFile!.path)
                                  : FileImage(File(_pickedFile!.path))
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _pickedFile == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload_outlined,
                                  size: 50, color: Colors.black54),
                              SizedBox(height: 10),
                              Text('Upload Image',
                                  style: TextStyle(color: Colors.black54)),
                            ],
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField("Auction Title", controller: _titleController),
              const SizedBox(height: 15),
              _buildTextField("Starting Price",
                  keyboardType: TextInputType.number,
                  suffixText: "KWD",
                  controller: _priceController),
              const SizedBox(height: 15),
              _buildDateTimePicker(),
              const SizedBox(height: 15),
              _buildEndDateTimePicker(),
              const SizedBox(height: 15),
              _buildTextField("Description",
                  maxLines: 5, controller: _descriptionController),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : ElevatedButton(
                      onPressed: _postAuction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      child: const Text(
                        'Post Auction',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildDateTimePicker() {
    String text = 'Starting Date & Time';
    if (_selectedDate != null && _selectedTime != null) {
      text =
          '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} ${_selectedTime!.format(context)}';
    }

    return GestureDetector(
      onTap: _pickDateTime,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                color: _selectedDate == null ? Colors.black54 : Colors.black,
                fontSize: 16,
              ),
            ),
            const Icon(Icons.calendar_today, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _buildEndDateTimePicker() {
    String text = 'Bid End Date & Time';
    if (_selectedEndDate != null && _selectedEndTime != null) {
      text =
          '${_selectedEndDate!.day}/${_selectedEndDate!.month}/${_selectedEndDate!.year} ${_selectedEndTime!.format(context)}';
    }

    return GestureDetector(
      onTap: _pickEndDateTime,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                color: _selectedEndDate == null ? Colors.black54 : Colors.black,
                fontSize: 16,
              ),
            ),
            const Icon(Icons.calendar_today, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText,
      {int maxLines = 1,
      TextInputType keyboardType = TextInputType.text,
      String? suffixText,
      TextEditingController? controller}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        suffixText: suffixText,
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
