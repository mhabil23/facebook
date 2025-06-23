import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class PostScreen extends StatelessWidget {
  final String imageUrl;

  const PostScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Lihat Gambar')),
      body: Center(
        child: Image.network(
          imageUrl, // ✅ Ini akan berhasil karena field-nya sudah ada
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
