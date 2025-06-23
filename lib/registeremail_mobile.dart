import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/registerpassword_mobile.dart';
import 'package:http/http.dart' as http;
import 'registernumberphone.dart';

class email extends StatelessWidget {
  const email({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: EmailInputScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class EmailInputScreen extends StatefulWidget {
  const EmailInputScreen({super.key});

  @override
  State<EmailInputScreen> createState() => _EmailInputScreenState();
}

class _EmailInputScreenState extends State<EmailInputScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _message;

  final String _apiUrl =
      'https://fb.habilazzikri.my.id/facebook-backend/api/signup.php';

  Future<void> _submitEmail() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
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
      // Kirim request ke PHP backend
      final body = jsonEncode({
        'first_name': 'Dummy', // Ganti dengan data yang sesuai
        'last_name': 'User',
        'email': email,
        'password': 'dummyPassword123',
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
          _message = data['message'] ?? 'Email berhasil dikirim.';
        });
      } else {
        setState(() {
          _message = data['message'] ?? 'Terjadi kesalahan.';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error koneksi: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back),
              ),
              const SizedBox(height: 32),
              const Text(
                "Apa email Anda?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                "Masukkan email yang bisa dihubungi. Tidak ada yang akan melihat ini di profil Anda.",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Pesan respons dari server
              if (_message != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _message!,
                    style: TextStyle(
                      color:
                          _message!.toLowerCase().contains('berhasil')
                              ? Colors.green
                              : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const Text.rich(
                TextSpan(
                  text:
                      "Anda juga akan menerima email dari kami dan bisa menolak kapan saja. ",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  children: [
                    TextSpan(
                      text: "Pelajari selengkapnya",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _isLoading
                          ? null
                          : () async {
                            await _submitEmail();
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BuatKataSandiPage(),
                              ),
                            );
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
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
                            "Berikutnya",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
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
                        builder: (context) => const NomorPonselPage(gender: ""),
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

              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: aksi cari akun saya
                  },
                  child: const Text(
                    "Cari akun saya",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
