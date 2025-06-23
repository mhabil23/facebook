import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_web.dart';

void main() {
  runApp(const FacebookSignupApp());
}

class FacebookSignupApp extends StatelessWidget {
  const FacebookSignupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Facebook Signup',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Helvetica'),
      home: const FacebookSignupPage(),
    );
  }
}

class FacebookSignupPage extends StatefulWidget {
  const FacebookSignupPage({super.key});

  @override
  State<FacebookSignupPage> createState() => _FacebookSignupPageState();
}

class _FacebookSignupPageState extends State<FacebookSignupPage> {
  String selectedDay = '18';
  String selectedMonth = 'May';
  String selectedYear = '2025';
  String selectedGender = '';

  // Controllers untuk form input
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Fungsi untuk signup
  Future<void> signUp() async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        selectedGender.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final monthMap = {
      'Jan': '01',
      'Feb': '02',
      'Mar': '03',
      'Apr': '04',
      'May': '05',
      'Jun': '06',
      'Jul': '07',
      'Aug': '08',
      'Sep': '09',
      'Oct': '10',
      'Nov': '11',
      'Dec': '12',
    };
    String monthNumber = monthMap[selectedMonth] ?? '01';

    final Map<String, dynamic> data = {
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'birth_date': '$selectedYear-$monthNumber-$selectedDay',
      'gender': selectedGender,
    };

    try {
      final response = await http.post(
        Uri.parse(
          'https://fb.habilazzikri.my.id/facebook-backend/api/signup.php',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(responseData['message'])));

        firstNameController.clear();
        lastNameController.clear();
        emailController.clear();
        passwordController.clear();
        setState(() {
          selectedGender = '';
          selectedDay = '18';
          selectedMonth = 'May';
          selectedYear = '2025';
        });

        // ✅ Navigasi ke halaman login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const FacebookLoginScreenWeb(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Signup failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void dispose() {
    // Clean up controllers
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              // Facebook Logo
              Text(
                'facebook',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Signup Card
              Container(
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Create a new account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "It's quick and easy.",
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      // Name fields
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: firstNameController,
                              decoration: InputDecoration(
                                hintText: 'First name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 15,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: lastNameController,
                              decoration: InputDecoration(
                                hintText: 'Surname',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // Date of birth section
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            const Text(
                              'Date of birth',
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Date dropdowns
                      Row(
                        children: [
                          // Day dropdown
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedDay,
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  items:
                                      List.generate(
                                        31,
                                        (index) => (index + 1).toString(),
                                      ).map((String day) {
                                        return DropdownMenuItem<String>(
                                          value: day,
                                          child: Text(day),
                                        );
                                      }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedDay = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Month dropdown
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedMonth,
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  items:
                                      [
                                        'Jan',
                                        'Feb',
                                        'Mar',
                                        'Apr',
                                        'May',
                                        'Jun',
                                        'Jul',
                                        'Aug',
                                        'Sep',
                                        'Oct',
                                        'Nov',
                                        'Dec',
                                      ].map((String month) {
                                        return DropdownMenuItem<String>(
                                          value: month,
                                          child: Text(month),
                                        );
                                      }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedMonth = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Year dropdown
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedYear,
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  items:
                                      List.generate(
                                        100,
                                        (index) => (2025 - index).toString(),
                                      ).map((String year) {
                                        return DropdownMenuItem<String>(
                                          value: year,
                                          child: Text(year),
                                        );
                                      }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedYear = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // Gender section
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            const Text(
                              'Gender',
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Gender selection
                      Row(
                        children: [
                          // Female option
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      selectedGender == 'Female'
                                          ? Colors.blue
                                          : Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text('Female'),
                                  ),
                                  Radio<String>(
                                    value: 'Female',
                                    groupValue: selectedGender,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedGender = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Male option
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      selectedGender == 'Male'
                                          ? Colors.blue
                                          : Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text('Male'),
                                  ),
                                  Radio<String>(
                                    value: 'Male',
                                    groupValue: selectedGender,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedGender = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Custom option
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      selectedGender == 'Custom'
                                          ? Colors.blue
                                          : Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text('Custom'),
                                  ),
                                  Radio<String>(
                                    value: 'Custom',
                                    groupValue: selectedGender,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedGender = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // Email field
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Mobile number or email address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Password field
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'New password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Contact upload notice
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[800],
                          ),
                          children: [
                            const TextSpan(
                              text:
                                  'People who use our service may have uploaded your contact information to Facebook. ',
                            ),
                            TextSpan(
                              text: 'Learn more',
                              style: TextStyle(color: Colors.blue[700]),
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Terms and policy
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[800],
                          ),
                          children: [
                            const TextSpan(
                              text: 'By clicking Sign Up, you agree to our ',
                            ),
                            TextSpan(
                              text: 'Terms',
                              style: TextStyle(color: Colors.blue[700]),
                            ),
                            const TextSpan(text: ', '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(color: Colors.blue[700]),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Cookies Policy',
                              style: TextStyle(color: Colors.blue[700]),
                            ),
                            const TextSpan(
                              text:
                                  '. You may receive SMS notifications from us and can opt out at any time.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Sign up button
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Already have account
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const FacebookLoginScreenWeb(),
                            ),
                          );
                        },
                        child: Text(
                          'Already have an account?',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Column(
                  children: [
                    // Language options
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      children: [
                        buildLanguageLink('English (UK)'),
                        buildLanguageLink('Bahasa Indonesia'),
                        buildLanguageLink('Basa Jawa'),
                        buildLanguageLink('Bahasa Melayu'),
                        buildLanguageLink('日本語'),
                        buildLanguageLink('العربية'),
                        buildLanguageLink('Français (France)'),
                        buildLanguageLink('Español'),
                        buildLanguageLink('한국어'),
                        buildLanguageLink('Português (Brasil)'),
                        buildLanguageLink('Deutsch'),
                        TextButton(
                          onPressed: () {},
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: const Icon(Icons.add, size: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Footer Links - First row
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 15,
                      children: [
                        buildFooterLink('Sign Up'),
                        buildFooterLink('Log in'),
                        buildFooterLink('Messenger'),
                        buildFooterLink('Facebook Lite'),
                        buildFooterLink('Video'),
                        buildFooterLink('Meta Pay'),
                        buildFooterLink('Meta Store'),
                        buildFooterLink('Meta Quest'),
                        buildFooterLink('Ray-Ban Meta'),
                        buildFooterLink('Meta AI'),
                        buildFooterLink('Instagram'),
                        buildFooterLink('Threads'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Footer Links - Second row
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 15,
                      children: [
                        buildFooterLink('Voting Information Centre'),
                        buildFooterLink('Privacy Policy'),
                        buildFooterLink('Privacy Centre'),
                        buildFooterLink('Meta in Indonesia'),
                        buildFooterLink('About'),
                        buildFooterLink('Create ad'),
                        buildFooterLink('Create Page'),
                        buildFooterLink('Developers'),
                        buildFooterLink('Careers'),
                        buildFooterLink('Cookies'),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildFooterLink('AdChoices'),
                            const Icon(Icons.arrow_forward, size: 16),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Footer Links - Third row
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 15,
                      children: [
                        buildFooterLink('Terms'),
                        buildFooterLink('Help'),
                        buildFooterLink('Contact uploading and non-users'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Copyright text
                    Text(
                      'Meta © ${DateTime.now().year}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLanguageLink(String language) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        language,
        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
      ),
    );
  }

  Widget buildFooterLink(String text) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
      ),
    );
  }
}
