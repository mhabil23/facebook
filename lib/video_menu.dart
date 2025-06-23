import 'package:flutter/material.dart';

class VideoMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const VideoMenu({
    super.key,
    this.selectedIndex = 0,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMenuItem(0, Icons.ondemand_video_rounded, 'Beranda'),
          _buildMenuItem(1, Icons.videocam, 'Siaran Langsung'),
          _buildMenuItem(2, Icons.video_library, 'Reels'),
          _buildMenuItem(3, Icons.tv, 'Acara'),
          _buildMenuItem(4, Icons.rocket, 'Jelajahi'),
          _buildMenuItem(5, Icons.bookmark, 'Video Tersimpan'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(int index, IconData icon, String label) {
    final bool isSelected = index == selectedIndex;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onItemSelected(index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.blue : Colors.black87,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.blue : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
