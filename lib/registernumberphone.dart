import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/registerpassword_mobile.dart';
import 'registernumberphone.dart';
import 'registerpassword_mobile.dart';
import 'registeremail_mobile.dart';
import 'package:http/http.dart' as http;

class NomorPonselPage extends StatefulWidget {
  final String gender; // Tambahkan gender parameter

  const NomorPonselPage({super.key, required this.gender}); // Menerima gender

  @override
  _NomorPonselPageState createState() => _NomorPonselPageState();
}

class _NomorPonselPageState extends State<NomorPonselPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _message;

  // Ganti sesuai URL backend PHP-mu
  final String _apiUrl =
      'https://fb.habilazzikri.my.id/facebook-backend/api/signup.php';

  Future<void> _submitPhone() async {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      setState(() {
        _message = 'Nomor ponsel tidak boleh kosong.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      // Kirim POST ke PHP, sesuaikan data JSON sesuai kebutuhan backend
      final body = jsonEncode({
        'first_name': 'Dummy',
        'last_name': 'User',
        'email': 'dummyemail@example.com',
        'password': 'password123',
        'birth_date': '2000-01-01',
        'gender': widget.gender, // Kirim gender
        'phone': phone,
      });

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        setState(() {
          _message = data['message'] ?? 'Pendaftaran berhasil.';
        });
      } else {
        setState(() {
          _message = data['message'] ?? 'Terjadi kesalahan.';
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
    _phoneController.dispose();
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
              'Berapa nomor ponsel Anda?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Masukkan nomor ponsel yang bisa dihubungi. Tidak ada yang akan melihat informasi ini di profil Anda.',
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
                controller: _phoneController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Nomor ponsel',
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                ),
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text:
                        'Anda mungkin menerima notifikasi WhatsApp dan SMS dari kami. ',
                  ),
                  TextSpan(
                    text: 'Pelajari selengkapnya',
                    style: TextStyle(
                      color: Color(0xFF1976D2),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed:
                    _isLoading
                        ? null
                        : () async {
                          await _submitPhone();
                          if (!mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BuatKataSandiPage(),
                            ),
                          );
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                        : const Text(
                          'Berikutnya',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const email()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey[300]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: const Text(
                  'Daftar dengan email',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            if (_message != null) ...[
              SizedBox(height: 16),
              Text(
                _message!,
                style: TextStyle(
                  color:
                      _message!.toLowerCase().contains('berhasil')
                          ? Colors.green
                          : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NomorPonselPage(gender: "male"), // Pass gender when navigating
    ),
  );
}
