import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserData {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  DateTime? birthDate;
  String? phoneNumber;
  String? gender;

  UserData({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.birthDate,
    this.phoneNumber,
    this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'birth_date': birthDate?.toIso8601String(),
      'phone_number': phoneNumber,
      'gender': gender,
    };
  }
}

class FacebookRegisterPage extends StatefulWidget {
  const FacebookRegisterPage({super.key});

  @override
  _FacebookRegisterPageState createState() => _FacebookRegisterPageState();
}

class _FacebookRegisterPageState extends State<FacebookRegisterPage> {
  int currentStep = 0;
  UserData userData = UserData();
  PageController pageController = PageController();
  bool isLoading = false;
  String contactMethod = 'phone'; // Default to phone

  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    pageController.dispose();
    super.dispose();
  }

  void nextStep() {
    if (currentStep < 4) {
      // Updated max steps to 4 (0-4)
      setState(() {
        currentStep++;
      });
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool canProceedFromCurrentStep() {
    switch (currentStep) {
      case 0: // Name step
        return firstNameController.text.trim().isNotEmpty &&
            lastNameController.text.trim().isNotEmpty;
      case 1: // Birthday step
        return userData.birthDate != null;
      case 2: // Gender step
        return userData.gender != null;
      case 3: // Contact input step (phone/email)
        if (contactMethod == 'email') {
          return emailController.text.trim().isNotEmpty &&
              _isValidEmail(emailController.text.trim());
        } else if (contactMethod == 'phone') {
          return phoneController.text.trim().isNotEmpty;
        }
        return false;
      case 4: // Password step
        return passwordController.text.length >= 6;
      default:
        return false;
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> submitRegistration() async {
    setState(() {
      isLoading = true;
    });

    // Update userData with current form values
    userData.firstName = firstNameController.text.trim();
    userData.lastName = lastNameController.text.trim();
    userData.email =
        emailController.text.trim().isNotEmpty
            ? emailController.text.trim()
            : null;
    userData.phoneNumber =
        phoneController.text.trim().isNotEmpty
            ? phoneController.text.trim()
            : null;
    userData.password = passwordController.text;

    // If contact method is phone, set email to phone number
    if (contactMethod == 'phone') {
      userData.email = userData.phoneNumber;
    }

    try {
      final response = await http.post(
        Uri.parse(
          'https://fb.habilazzikri.my.id/facebook-backend/api/signup.php',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData.toJson()),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        String errorMessage = responseData['message'] ?? 'Registration failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error: Please check your connection'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading:
            currentStep > 0
                ? IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: previousStep,
                )
                : IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
        centerTitle: true,
      ),
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildNameStep(),
          _buildBirthdayStep(),
          _buildGenderStep(),
          _buildContactInputStep(),
          _buildPasswordStep(),
        ],
      ),
    );
  }

  Widget _buildNameStep() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Tambahan opsional
        children: [
          Text(
            "What's your name?",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Enter the name you use in real life.",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    hintText: "Nama Depan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.blue[600]!),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    hintText: "Nama Belakang",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.blue[600]!),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 30), // Tambahkan jarak antara input dan tombol
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: canProceedFromCurrentStep() ? nextStep : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    canProceedFromCurrentStep()
                        ? Colors.blue[600]
                        : Colors.grey[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Berikutnya",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBirthdayStep() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Kapan tanggal lahir Anda?",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16, color: Colors.grey[400]),
              children: [
                TextSpan(
                  text:
                      "Pilih tanggal lahir. Anda selalu bisa membuatnya privat nanti. ",
                ),
                TextSpan(
                  text: "Mengapa saya harus memberikan tanggal lahir?",
                  style: TextStyle(
                    color: Colors.blue[400],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(
                  Duration(days: 6570),
                ), // 18 years ago
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                setState(() {
                  userData.birthDate = date;
                });
              }
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                userData.birthDate != null
                    ? "${userData.birthDate!.day}/${userData.birthDate!.month}/${userData.birthDate!.year}"
                    : "Masukkan ulang tahungmu",
                style: TextStyle(
                  fontSize: 16,
                  color:
                      userData.birthDate != null
                          ? Colors.black
                          : Colors.grey[500],
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: canProceedFromCurrentStep() ? nextStep : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    canProceedFromCurrentStep()
                        ? Colors.blue[600]
                        : Colors.grey[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Berikutnya",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderStep() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Apa jenis kelamin Anda?",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Anda bisa mengubah siapa yang bisa melihat jenis kelamin di profil nanti.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              children: [
                _buildGenderOptionRadio("Perempuan", "female", isFirst: true),
                Divider(height: 1, color: Colors.grey[300]),
                _buildGenderOptionRadio("Laki-laki", "male"),
                Divider(height: 1, color: Colors.grey[300]),
                _buildGenderOptionWithSubtext(
                  "Opsi lainnya",
                  "custom",
                  "Pilih opsi Lainnya untuk memilih jenis kelamin lain atau jika Anda memilih tidak menjawab.",
                  isLast: true,
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: canProceedFromCurrentStep() ? nextStep : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    canProceedFromCurrentStep()
                        ? Colors.blue[600]
                        : Colors.grey[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: Text(
                "Berikutnya",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOptionRadio(
    String label,
    String value, {
    bool isFirst = false,
  }) {
    return RadioListTile<String>(
      title: Text(label, style: TextStyle(fontSize: 16, color: Colors.black)),
      value: value,
      groupValue: userData.gender,
      onChanged: (String? newValue) {
        setState(() {
          userData.gender = newValue;
        });
      },
      activeColor: Colors.blue[600],
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  Widget _buildGenderOptionWithSubtext(
    String label,
    String value,
    String subtext, {
    bool isLast = false,
  }) {
    return RadioListTile<String>(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.black)),
          SizedBox(height: 4),
          Text(
            subtext,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.3,
            ),
          ),
        ],
      ),
      value: value,
      groupValue: userData.gender,
      onChanged: (String? newValue) {
        setState(() {
          userData.gender = newValue;
        });
      },
      activeColor: Colors.blue[600],
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  Widget _buildContactInputStep() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contactMethod == 'phone'
                ? "Berapa nomor ponsel Anda?"
                : "Apa email Anda?",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            contactMethod == 'phone'
                ? "Masukkan nomor ponsel yang bisa dihubungi. Tidak ada yang akan melihat informasi ini di profil Anda."
                : "Masukkan email yang bisa dihubungi. Tidak ada yang akan melihat ini di profil Anda.",
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          SizedBox(height: 30),
          TextField(
            controller:
                contactMethod == 'phone' ? phoneController : emailController,
            keyboardType:
                contactMethod == 'phone'
                    ? TextInputType.phone
                    : TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: contactMethod == 'phone' ? "Nomor ponsel" : "Email",
              hintStyle: TextStyle(color: Colors.grey[500]),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue),
              ),
              errorText:
                  contactMethod == 'email' &&
                          emailController.text.isNotEmpty &&
                          !_isValidEmail(emailController.text)
                      ? "Masukkan email yang valid"
                      : null,
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              children: [
                TextSpan(
                  text:
                      contactMethod == 'phone'
                          ? "Anda mungkin menerima notifikasi WhatsApp dan SMS dari kami. "
                          : "Anda juga akan menerima email dari kami dan bisa menolak kapan saja. ",
                ),
                TextSpan(
                  text: "Pelajari selengkapnya",
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: canProceedFromCurrentStep() ? nextStep : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    canProceedFromCurrentStep()
                        ? Colors.blue[600]
                        : Colors.grey[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                "Berikutnya",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  contactMethod = contactMethod == 'phone' ? 'email' : 'phone';
                  if (contactMethod == 'phone') {
                    emailController.clear();
                  } else {
                    phoneController.clear();
                  }
                });
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey[400]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                contactMethod == 'phone'
                    ? "Daftar dengan email"
                    : "Daftar dengan nomor ponsel",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStep() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Buat kata sandi",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Buat kata sandi dengan paling tidak 6 huruf atau angka. Ini harus sesuatu yang tidak bisa ditebak orang lain.",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 30),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Kata Sandi",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue[600]!),
              ),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed:
                  canProceedFromCurrentStep() && !isLoading
                      ? () async {
                        // Final validation before submitting
                        if (contactMethod == 'email' &&
                            emailController.text.isNotEmpty &&
                            !_isValidEmail(emailController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please enter a valid email address',
                              ),
                            ),
                          );
                          return;
                        }
                        await submitRegistration();
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    canProceedFromCurrentStep() && !isLoading
                        ? Colors.green[600]
                        : Colors.grey[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child:
                  isLoading
                      ? CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                      : Text(
                        "Berikutnya",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
