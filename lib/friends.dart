import 'package:flutter/material.dart';
import 'navbar.mobile.dart';

class TemanPage extends StatefulWidget {
  const TemanPage({super.key});

  @override
  State<TemanPage> createState() => _TemanPageState();
}

class _TemanPageState extends State<TemanPage> {
  int _selectedIndex = 2; // Teman tab aktif

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Teman',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.black, size: 28),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildTabButton('Saran', true),
                const SizedBox(width: 12),
                _buildTabButton('Teman Anda', false),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Permintaan pertemanan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Lihat semua',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildFriendRequest(
                    name: 'Aqzan AR',
                    subtitle: '1 teman bersama • 20 mg',
                    profileImageUrl:
                        'http://localhost/flutter_application_1/php/tampilkan_produk.php?id=20',
                    hasAvatar: true,
                  ),
                  _buildFriendRequest(
                    name: 'Arifuddin Rahim',
                    subtitle: '7 tahun',
                    hasAvatar: false,
                  ),
                  _buildFriendRequest(
                    name: 'Kika Siawan',
                    subtitle: '45 mg',
                    profileImageUrl:
                        'http://localhost/flutter_application_1/php/tampilkan_produk.php?id=13',
                    hasAvatar: true,
                  ),
                  _buildFriendRequest(
                    name: 'Arwin S',
                    subtitle: '20 teman bersama • 6 tahun',
                    profileImageUrl:
                        'http://localhost/flutter_application_1/php/tampilkan_produk.php?id=5',
                    hasAvatar: true,
                    showMutualFriends: true,
                  ),
                  _buildFriendRequest(
                    name: 'Marsya Auliyahh',
                    subtitle: '40 teman bersama • 4 tahun',
                    profileImageUrl:
                        'http://localhost/flutter_application_1/php/tampilkan_produk.php?id=12',
                    hasAvatar: true,
                    showMutualFriends: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FacebookNavBarMobile(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          if (index != _selectedIndex) {
            setState(() => _selectedIndex = index);
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/home');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/video');
                break;
              case 2:
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/marketplace');
                break;
              case 4:
                Navigator.pushReplacementNamed(context, '/notifications');
                break;
              case 5:
                Navigator.pushReplacementNamed(context, '/menu');
                break;
            }
          }
        },
      ),
    );
  }

  Widget _buildTabButton(String title, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildFriendRequest({
    required String name,
    required String subtitle,
    String? profileImageUrl,
    required bool hasAvatar,
    bool showMutualFriends = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child:
                hasAvatar && profileImageUrl != null
                    ? ClipOval(
                      child: Image.network(
                        profileImageUrl,
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                        errorBuilder:
                            (_, __, ___) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.person, size: 40),
                            ),
                      ),
                    )
                    : CircleAvatar(
                      backgroundColor: Colors.grey[400],
                      radius: 40,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey[600],
                      ),
                    ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (showMutualFriends) ...[
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.grey[500],
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        subtitle,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4DAFFF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Konfirmasi',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Hapus',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
