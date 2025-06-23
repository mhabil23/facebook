import 'package:flutter/material.dart';

class MarketplaceSidebarHeader extends StatelessWidget {
  const MarketplaceSidebarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan title dan settings icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Marketplace',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Handle settings action
                },
                icon: const Icon(Icons.settings, color: Colors.grey, size: 24),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Search bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Telusuri Marketplace',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Menu items
          _buildMenuItem(
            icon: Icons.store,
            iconColor: Colors.blue,
            title: 'Telusuri semua',
            onTap: () {
              // Handle navigation
            },
          ),

          _buildMenuItem(
            icon: Icons.notifications,
            iconColor: Colors.grey[700]!,
            title: 'Notifikasi',
            onTap: () {
              // Handle navigation
            },
          ),

          _buildMenuItem(
            icon: Icons.inbox,
            iconColor: Colors.grey[700]!,
            title: 'Kotak Masuk',
            onTap: () {
              // Handle navigation
            },
          ),

          _buildMenuItem(
            icon: Icons.security,
            iconColor: Colors.grey[700]!,
            title: 'Akses Marketplace',
            onTap: () {
              // Handle navigation
            },
          ),

          _buildMenuItem(
            icon: Icons.shopping_bag,
            iconColor: Colors.grey[700]!,
            title: 'Beli',
            hasArrow: true,
            onTap: () {
              // Handle navigation
            },
          ),

          _buildMenuItem(
            icon: Icons.sell,
            iconColor: Colors.grey[700]!,
            title: 'Jual',
            hasArrow: true,
            onTap: () {
              // Handle navigation
            },
          ),

          const SizedBox(height: 16),

          // Jual barang button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Text(
                  'Jual barang',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Lokasi section
          const Text(
            'Lokasi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Makassar • Dalam 190 km',
            style: TextStyle(color: Colors.blue[600], fontSize: 14),
          ),

          const SizedBox(height: 20),

          // Kategori section
          const Text(
            'Kategori',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 12),

          _buildMenuItem(
            icon: Icons.directions_car,
            iconColor: Colors.grey[700]!,
            title: 'Kendaraan',
            onTap: () {
              // Handle navigation
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    bool hasArrow = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    iconColor == Colors.blue
                        ? Colors.blue[100]
                        : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            if (hasArrow)
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}
