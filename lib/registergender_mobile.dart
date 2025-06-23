import 'package:flutter/material.dart';
import 'package:flutter_application_1/registernumberphone.dart'; // Pastikan sudah import file yang benar

class JenisKelaminPage extends StatefulWidget {
  const JenisKelaminPage({super.key}); // tambahkan const dan super.key

  @override
  _JenisKelaminPageState createState() => _JenisKelaminPageState();
}

class _JenisKelaminPageState extends State<JenisKelaminPage> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
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
            // Judul
            Text(
              'Apa jenis kelamin Anda?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            // Deskripsi
            Text(
              'Anda bisa mengubah siapa yang bisa melihat jenis kelamin di profil nanti.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            SizedBox(height: 40),
            // Options Container
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Perempuan Option
                  _buildGenderOption(
                    'female',
                    'female',
                    isFirst: true,
                  ),
                  Divider(height: 1, color: Colors.grey[300]),
                  // Laki-laki Option
                  _buildGenderOption(
                    'male',
                    'male',
                  ),
                  Divider(height: 1, color: Colors.grey[300]),
                  // Opsi lainnya Option
                  _buildGenderOption(
                    'others',
                    'lainnya',
                    subtitle: 'Pilih opsi Lainnya untuk memilih jenis kelamin lain atau jika Anda memilih tidak menjawab.',
                    isLast: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            // Tombol Berikutnya
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: selectedGender != null
                    ? () {
                        print('Selected gender: $selectedGender');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NomorPonselPage(gender: selectedGender!), // Passing selectedGender
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: Text(
                  'Berikutnya',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Spacer(),
            // Link di bagian bawah
            Center(
              child: TextButton(
                onPressed: () {
                  print('Cari akun saya');
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

  Widget _buildGenderOption(
    String title, 
    String value, 
    {String? subtitle, 
    bool isFirst = false, 
    bool isLast = false}
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedGender = value;
        });
      },
      borderRadius: BorderRadius.vertical(
        top: isFirst ? Radius.circular(12) : Radius.zero,
        bottom: isLast ? Radius.circular(12) : Radius.zero,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 16),
            // Radio Button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selectedGender == value 
                    ? Color(0xFF1976D2) 
                    : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: selectedGender == value
                ? Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                  )
                : null,
            ),
          ],
        ),
      ),
    );
  }
}

// Main App
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jenis Kelamin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: JenisKelaminPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(MyApp());
}
