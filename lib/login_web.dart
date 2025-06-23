import 'package:flutter/material.dart';
import 'package:flutter_application_1/facebook_home_web.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'register_web.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const FacebookLoginApp());
}

class FacebookLoginApp extends StatelessWidget {
  const FacebookLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Facebook Login',
      theme: ThemeData(
        primaryColor: const Color(0xFF1877F2),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const FacebookLoginScreenWeb(),
    );
  }
}

class FacebookLoginScreenWeb extends StatefulWidget {
  const FacebookLoginScreenWeb({super.key});

  @override
  State<FacebookLoginScreenWeb> createState() => _FacebookLoginScreenState();
}

class _FacebookLoginScreenState extends State<FacebookLoginScreenWeb> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(
          'https://fb.habilazzikri.my.id/facebook-backend/api/login.php',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginData),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // ✅ Simpan nama pengguna ke SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userFirstName', responseData['first_name'] ?? '');
        prefs.setString('userLastName', responseData['last_name'] ?? '');

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(responseData['message'])));

        // ✅ Arahkan ke halaman home
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Login failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'facebook',
                        style: TextStyle(
                          color: Color(0xFF1877F2),
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1.2,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Facebook helps you connect and share with the people in your life.',
                        style: TextStyle(fontSize: 28, color: Colors.black87),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 40),

                Expanded(
                  flex: 1,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email address or phone number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1877F2),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text(
                              'Log in',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgotten password?',
                            style: TextStyle(color: Color(0xFF1877F2)),
                          ),
                        ),
                        const Divider(height: 32),
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const FacebookSignupPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF42B72A),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text(
                              'Create new account',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
