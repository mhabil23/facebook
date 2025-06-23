import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupApi {
  static const String _baseUrl = 'http://192.168.138.18/facebook-backend/api/';
// Ganti dengan domain Anda
  static const String _signupEndpoint = 'signup.php';

  // Method untuk mendaftarkan user baru
  static Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String day,
    required String month,
    required String year,
    required String gender,
  }) async {
    try {
      // Konversi nama bulan ke angka (contoh: "May" -> "05")
      final monthMap = {
        'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04',
        'May': '05', 'Jun': '06', 'Jul': '07', 'Aug': '08',
        'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12'
      };
      final monthNumber = monthMap[month] ?? '01'; // Default ke '01' jika bulan tidak valid

      // Mengirim request HTTP POST ke API
      final response = await http.post(
        Uri.parse('$_baseUrl$_signupEndpoint'),
        headers: {'Content-Type': 'application/json'}, // Header untuk JSON
        body: jsonEncode({ // Mengubah data Dart menjadi JSON
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'day': day,
          'month': monthNumber,
          'year': year,
          'gender': gender,
        }),
      );

      // Mengubah response JSON menjadi Map Dart
      final responseData = jsonDecode(response.body);

      // Cek status code response
      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': responseData['message'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Registrasi gagal',
          'error': responseData['error'] ?? 'Error tidak diketahui',
        };
      }
    } catch (e) {
      // Menangani error yang terjadi selama proses
      return {
        'success': false,
        'message': 'Terjadi error saat registrasi',
        'error': e.toString(),
      };
    }
  }

  // Method untuk mengecek ketersediaan email
  static Future<bool> checkEmailAvailability(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${_baseUrl}check_email.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final responseData = jsonDecode(response.body);
      return responseData['available'] ?? false;
    } catch (e) {
      return false;
    }
  }
}