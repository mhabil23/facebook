import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'registergender_mobile.dart'; // Pastikan file ini sudah ada

class BirthDatePickerScreen extends StatefulWidget {
  final String firstName;
  final String lastName;

  const BirthDatePickerScreen({
    super.key,
    required this.firstName,
    required this.lastName,
  });

  @override
  _BirthDatePickerScreenState createState() => _BirthDatePickerScreenState();
}

class _BirthDatePickerScreenState extends State<BirthDatePickerScreen> {
  int selectedDay = 22;
  String selectedMonth = 'Mei';
  int selectedYear = 2025;

  bool _isLoading = false;
  String? _message;

  List<int> days = List.generate(31, (index) => index + 1);
  List<String> months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  List<int> years = List.generate(50, (index) => 2000 + index);

  final Map<String, String> monthMap = {
    'Januari': '01',
    'Februari': '02',
    'Maret': '03',
    'April': '04',
    'Mei': '05',
    'Juni': '06',
    'Juli': '07',
    'Agustus': '08',
    'September': '09',
    'Oktober': '10',
    'November': '11',
    'Desember': '12',
  };

  final String _apiUrl =
      'https://fb.habilazzikri.my.id/facebook-backend/api/signup.php';

  Future<void> submitBirthDate() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      String monthNumber = monthMap[selectedMonth] ?? '01';
      String birthDate =
          '$selectedYear-$monthNumber-${selectedDay.toString().padLeft(2, '0')}';

      final body = jsonEncode({
        'first_name': widget.firstName,
        'last_name': widget.lastName,
        'email': 'dummy@example.com', // ganti jika ada input valid
        'password': 'password123', // ganti jika ada input valid
        'birth_date': birthDate,
        'gender': 'other', // update kalau ada input gender nanti
      });

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        setState(() {
          _message = data['message'] ?? 'Tanggal lahir berhasil dikirim.';
        });

        // Setelah berhasil submit, lanjut ke JenisKelaminPage
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const JenisKelaminPage()),
        );
      } else {
        setState(() {
          _message =
              data['message'] ??
              'Terjadi kesalahan saat mengirim tanggal lahir.';
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tombol back
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Judul dan deskripsi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kapan tanggal lahir Anda?',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      children: const [
                        TextSpan(
                          text:
                              'Pilih tanggal lahir. Anda selalu bisa membuatnya privat nanti. ',
                        ),
                        TextSpan(
                          text: 'Mengapa saya harus memberikan tanggal lahir?',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Tampilkan tanggal yang dipilih
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ulang tahun (0 tahun)',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$selectedDay $selectedMonth $selectedYear',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Tombol submit
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : submitBirthDate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1877F2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Berikutnya',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
            ),

            if (_message != null) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  _message!,
                  style: TextStyle(
                    color:
                        _message!.toLowerCase().contains('berhasil')
                            ? Colors.green
                            : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],

            const Spacer(),

            // Wheel picker tanggal
            Container(
              height: 200,
              color: Colors.grey[100],
              child: Row(
                children: [
                  // Hari
                  Expanded(
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 40,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedDay = days[index];
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          if (index < 0 || index >= days.length) return null;
                          final isSelected = days[index] == selectedDay;
                          return Container(
                            alignment: Alignment.center,
                            child: Text(
                              days[index].toString(),
                              style: TextStyle(
                                fontSize: isSelected ? 20 : 16,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color:
                                    isSelected
                                        ? Colors.black
                                        : Colors.grey[600],
                              ),
                            ),
                          );
                        },
                        childCount: days.length,
                      ),
                    ),
                  ),

                  // Bulan
                  Expanded(
                    flex: 2,
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 40,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedMonth = months[index];
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          if (index < 0 || index >= months.length) return null;
                          final isSelected = months[index] == selectedMonth;
                          return Container(
                            alignment: Alignment.center,
                            child: Text(
                              months[index],
                              style: TextStyle(
                                fontSize: isSelected ? 20 : 16,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color:
                                    isSelected
                                        ? Colors.black
                                        : Colors.grey[600],
                              ),
                            ),
                          );
                        },
                        childCount: months.length,
                      ),
                    ),
                  ),

                  // Tahun
                  Expanded(
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 40,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedYear = years[index];
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          if (index < 0 || index >= years.length) return null;
                          final isSelected = years[index] == selectedYear;
                          return Container(
                            alignment: Alignment.center,
                            child: Text(
                              years[index].toString(),
                              style: TextStyle(
                                fontSize: isSelected ? 20 : 16,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color:
                                    isSelected
                                        ? Colors.black
                                        : Colors.grey[600],
                              ),
                            ),
                          );
                        },
                        childCount: years.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
