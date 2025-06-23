import 'package:flutter/material.dart';

class RightSidebar extends StatelessWidget {
  const RightSidebar({Key? key}) : super(key: key);
@override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F2F5),
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Info postingan
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.photo_library, size: 16, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        'Foto ini dari sebuah postingan.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Lihat postingan',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Kartu post
            const PostCard(),
          ],
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
   const PostCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 500),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Post header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Profile picture
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'image/pp.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                // User info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Muhaimin Ilyas',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '20 April pukul 00.21 · Jakarta · ',
                        style: TextStyle(
                          color: Color(0xFF65676B),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Options menu
                IconButton(
                  icon: Text(
                    '···',
                    style: TextStyle(
                      color: Color(0xFF65676B),
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
          ),
          
          // Post content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              '— di Jakarta Timur.',
              style: TextStyle(
                fontSize: 15,
                height: 1.3,
              ),
            ),
          ),
          
          // Divider
          Divider(height: 1, thickness: 1, color: Color(0xFFE4E6EB)),
          
          // Post actions
          Row(
            children: [
              _buildActionButton(Icons.thumb_up_outlined, 'Suka'),
              _buildActionButton(Icons.chat_bubble_outline, 'Komentar'),
              _buildActionButton(Icons.share_outlined, 'Bagikan'),
            ],
          ),
          
          // Divider
          Divider(height: 1, thickness: 1, color: Color(0xFFE4E6EB)),
          
          // Comment section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFFF0F2F5),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
            ),
            child: Row(
              children: [
                // Comment profile
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                // Comment input
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Tulis komentar...',
                      style: TextStyle(
                        color: Color(0xFF65676B),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                // Emoji buttons
                Row(
                  children: [
                    _buildIconButton(Icons.emoji_emotions_outlined),
                    _buildIconButton(Icons.camera_alt_outlined),
                    _buildIconButton(Icons.sentiment_satisfied_outlined),
                    SizedBox(width: 6),
                    Icon(
                      Icons.send,
                      size: 20,
                      color: Color(0xFF65676B),
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
  
  Widget _buildIconButton(IconData icon) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 28,
        height: 28,
        margin: EdgeInsets.only(right: 6),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 20,
          color: Color(0xFF65676B),
        ),
      ),
    );
  }
  
  Widget _buildActionButton(IconData icon, String label) {
    return Expanded(
      child: TextButton(
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: Color(0xFF65676B),
            ),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: Color(0xFF65676B),
                fontSize: 13,
              ),
            ),
          ],
        ),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}