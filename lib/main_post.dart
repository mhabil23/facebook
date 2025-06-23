import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'rightbar_post.dart';
import 'navbar.dart';
import 'post_screen.dart';

class SocialMediaScreen extends StatefulWidget {
  const SocialMediaScreen({Key? key}) : super(key: key);

  @override
  State<SocialMediaScreen> createState() => _SocialMediaScreenState();
}

class _SocialMediaScreenState extends State<SocialMediaScreen> {
  int _selectedIndex = 0;
  Uint8List? selectedBytes;

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add navigation handling if needed
  }

  Future<void> _pickImage() async {
    final XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      final bytes = await file.readAsBytes();
      setState(() {
        selectedBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: const Icon(Icons.image),
      ),
      body: Stack(
        children: [
          // Layer 1: Navbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FacebookNavBar(
              selectedIndex: _selectedIndex,
              onItemSelected: _onItemSelected,
            ),
          ),

          // Layer 2: Main content
          Positioned.fill(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Content with Image Preview
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                    ),
                    child: Transform.translate(
                      offset: const Offset(
                        0,
                        -56,
                      ), // Naik 56px untuk menyesuaikan navbar
                      child:
                          selectedBytes != null
                              ? Scaffold(
                                backgroundColor: Colors.black,
                                appBar: AppBar(
                                  backgroundColor: Colors.black,
                                  title: const Text('Lihat Gambar'),
                                ),
                                body: Center(
                                  child: Image.memory(
                                    selectedBytes!,
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                              )
                              : const Center(
                                child: Text(
                                  "Pilih gambar untuk ditampilkan",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                    ),
                  ),
                ),

                // Right Sidebar
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 56,
                    ),
                    child: const RightSidebar(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
