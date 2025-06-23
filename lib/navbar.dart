import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FacebookNavBar extends StatefulWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const FacebookNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  State<FacebookNavBar> createState() => _FacebookNavBarState();
}

class _FacebookNavBarState extends State<FacebookNavBar> {
  String userFullName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Menghapus semua data pengguna

    if (!mounted) return;

    // Navigasi ke halaman login
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final firstName = prefs.getString('userFirstName') ?? '';
    final lastName = prefs.getString('userLastName') ?? '';
    setState(() {
      userFullName = '$firstName $lastName'.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Material(
      elevation: 4,
      child: Container(
        color: Colors.white,
        height: widget.preferredSize.height,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Kiri: Logo dan pencarian
            Row(
              children: [
                const Icon(Icons.facebook, color: Color(0xFF1877F2), size: 32),
                const SizedBox(width: 12),
                Container(
                  width: 160,
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, size: 20, color: Colors.black54),
                      SizedBox(width: 8),
                      Text(
                        'Cari di Facebook',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Tengah: Navigasi
            if (!isMobile)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildNavItem(Icons.home, 0),
                  const SizedBox(width: 24),
                  _buildNavItem(Icons.ondemand_video, 1),
                  const SizedBox(width: 24),
                  _buildNavItem(Icons.storefront, 2),
                  const SizedBox(width: 24),
                  _buildNavItem(Icons.groups, 3),
                ],
              ),

            // Kanan: Notifikasi dan profil
            Row(
              children: [
                _buildIconButton(Icons.menu),
                const SizedBox(width: 8),
                _buildIconButton(Icons.message),
                const SizedBox(width: 8),
                _buildIconButton(Icons.notifications),
                const SizedBox(width: 8),
                PopupMenuButton<int>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  offset: const Offset(-200, 50),
                  elevation: 8,
                  color: Colors.white,
                  constraints: const BoxConstraints(
                    minWidth: 280,
                    maxWidth: 280,
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 0:
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Lihat Semua Profil ditekan'),
                          ),
                        );
                        break;
                      case 1:
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Setelan & privasi ditekan'),
                          ),
                        );
                        break;
                      case 2:
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Bantuan & dukungan ditekan'),
                          ),
                        );
                        break;
                      case 3:
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tampilan & aksesibilitas ditekan'),
                          ),
                        );
                        break;
                      case 4:
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Beri masukan ditekan')),
                        );
                        break;
                      case 5:
                        _logout();
                        break;
                    }
                  },
                  itemBuilder:
                      (context) => [
                        // Header dengan profil pengguna
                        PopupMenuItem(
                          enabled: false,
                          height: 80,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.grey[400],
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    userFullName.isNotEmpty
                                        ? userFullName
                                        : 'Pengguna',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Tombol Lihat Semua Profil
                        PopupMenuItem(
                          value: 0,
                          height: 56,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.people,
                                  color: Colors.black87,
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Lihat Semua Profil',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const PopupMenuDivider(height: 8),

                        // Menu Setelan & privasi
                        PopupMenuItem(
                          value: 1,
                          height: 48,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.settings,
                                    size: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Setelan & privasi',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.chevron_right,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Menu Bantuan & dukungan
                        PopupMenuItem(
                          value: 2,
                          height: 48,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.help_outline,
                                    size: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Bantuan & dukungan',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.chevron_right,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Menu Tampilan & aksesibilitas
                        PopupMenuItem(
                          value: 3,
                          height: 48,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.dark_mode_outlined,
                                    size: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Tampilan & aksesibilitas',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.chevron_right,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Menu Beri masukan
                        PopupMenuItem(
                          value: 4,
                          height: 48,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.feedback_outlined,
                                    size: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Beri masukan',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      'CTRL B',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Menu Keluar
                        PopupMenuItem(
                          value: 5,
                          height: 48,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.logout,
                                    size: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Keluar',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Footer
                        PopupMenuItem(
                          enabled: false,
                          height: 60,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Privasi · Ketentuan · Iklan · Pilihan Iklan · Cookie · Lainnya · Meta © 2025',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),
                      ],
                  child: const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = widget.selectedIndex == index;
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? const Color(0xFF1877F2) : Colors.grey,
        size: 28,
      ),
      onPressed: () => widget.onItemSelected(index),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: Color(0xFFE4E6EB),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: Colors.black),
    );
  }
}
