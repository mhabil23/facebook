import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_mobile.dart';

class BuatKataSandiPage extends StatefulWidget {
  const BuatKataSandiPage({super.key});
  @override
  _BuatKataSandiPageState createState() => _BuatKataSandiPageState();
}

class _BuatKataSandiPageState extends State<BuatKataSandiPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;
  String? _message;

  // Ganti dengan endpoint PHP yang sesuai
  final String _apiUrl = 'http://192.168.138.18/facebook-backend/api/signup.php';

  Future<void> _submitPassword() async {
    final password = _passwordController.text.trim();

    if (password.length < 6) {
      setState(() {
        _message = 'Password harus minimal 6 karakter.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      // Karena backend PHP butuh data lain, gunakan dummy data yang valid
      final body = jsonEncode({
        'first_name': 'Dummy',
        'last_name': 'User',
        'email': 'dummyemail@example.com',
        'password': password,
        'birth_date': '2000-01-01',
        'gender': 'other',
      });

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        setState(() {
          _message = data['message'] ?? 'Password berhasil dikirim.';
        });
      } else {
        setState(() {
          _message = data['message'] ?? 'Terjadi kesalahan saat mengirim data.';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Gagal koneksi ke server: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Buat kata sandi',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Buat kata sandi dengan paling tidak 6 huruf atau angka. Ini harus sesuatu yang tidak bisa ditebak orang lain.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: 'Kata Sandi',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 32),
            if (_message != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _message!,
                  style: TextStyle(
                    color: _message!.toLowerCase().contains('berhasil')
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 12),
SizedBox(
  width: double.infinity,
  child: OutlinedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>const FacebookLoginScreenMobile(),
        ),
      );
    },
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: Colors.black54),
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    child: const Text(
      "Daftar dengan nomor ponsel",
      style: TextStyle(
        fontSize: 16,
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
),

            Spacer(),
            Center(
              child: TextButton(
                onPressed: () {
                  print('Cari akun saya ditekan');
                },
                child: Text(
                  'Cari akun saya',
                  style: TextStyle(
                    color: Color(0xFF1976D2),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BuatKataSandiPage(),
  ));
}
