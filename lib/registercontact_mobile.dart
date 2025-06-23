import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'registerpassword_mobile.dart';

class ContactInfoPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String birthDate;
  final String gender;

  const ContactInfoPage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
  });

  @override
  _ContactInfoPageState createState() => _ContactInfoPageState();
}

class _ContactInfoPageState extends State<ContactInfoPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _message;
  bool _usePhone = true;

  final String _apiUrl =
      'https://fb.habilazzikri.my.id/facebook-backend/api/signup.php';

  Future<void> _submitContactInfo() async {
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();

    if (_usePhone && phone.isEmpty) {
      setState(() {
        _message = 'Nomor ponsel tidak boleh kosong.';
      });
      return;
    }

    if (!_usePhone && email.isEmpty) {
      setState(() {
        _message = 'Email tidak boleh kosong.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final body = jsonEncode({
        'first_name': widget.firstName,
        'last_name': widget.lastName,
        'email': _usePhone ? '' : email,
        'phone': _usePhone ? phone : '',
        'birth_date': widget.birthDate,
        'gender': widget.gender,
      });

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        setState(() {
          _message = data['message'] ?? 'Informasi kontak berhasil dikirim.';
        });
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BuatKataSandiPage()),
        );
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
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Information'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToggleButtons(
              isSelected: [_usePhone, !_usePhone],
              onPressed: (index) {
                setState(() {
                  _usePhone = index == 0;
                  _message = null;
                });
              },
              borderRadius: BorderRadius.circular(8),
              selectedColor: Colors.white,
              fillColor: Colors.blue,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Phone'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Email'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_usePhone)
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            else
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            if (_message != null)
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
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitContactInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
