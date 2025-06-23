import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/facebook_home_mobile.dart';
import 'navbar.dart';
import 'video.dart';
import 'main_post.dart';
import 'video_player_item.dart';

class FacebookClone extends StatelessWidget {
  const FacebookClone({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body:
          screenWidth < 600
              ? const FacebookHomePageMobile()
              : const FacebookHomePage(),
    );
  }
}

class FacebookHomePage extends StatefulWidget {
  const FacebookHomePage({super.key});

  @override
  _FacebookHomePageState createState() => _FacebookHomePageState();
}

class _FacebookHomePageState extends State<FacebookHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _posts = [];
  final List<Map<String, dynamic>> _stories = [];
  bool _loadingPosts = true;
  String _firstName = '';
  String _lastName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchPosts();
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('userFirstName') ?? '';
      _lastName = prefs.getString('userLastName') ?? '';
    });
  }

  Future<void> _fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://fb.habilazzikri.my.id/facebook-backend/api/get_postingan.php',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['posts'] is List) {
          setState(() {
            _posts = List<Map<String, dynamic>>.from(
              (data['posts'] as List).map(
                (p) => {
                  'id': p['id'] ?? '',
                  'author': p['author'] ?? 'Tidak dikenal',
                  'authorImage': p['authorImage'] ?? '',
                  'content': p['content'] ?? '',
                  'image': p['image'] ?? '',
                  'video': p['video'] ?? '',
                  'timestamp': p['timestamp'] ?? '',
                  'likes': p['likes'] ?? 0,
                  'comments': p['comments'] ?? 0,
                  'shares': p['shares'] ?? 0,
                  'isLiked': p['isLiked'] ?? false,
                },
              ),
            );
            _loadingPosts = false;
          });
        } else {
          throw 'Respon tidak valid dari server';
        }
      } else {
        throw 'Server error (${response.statusCode})';
      }
    } catch (e) {
      setState(() {
        _loadingPosts = false;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat postingan: $e')));
      }
    }
  }

  Widget _buildMainContent() {
    if (_loadingPosts) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: [
        _buildPostCreationCard(context),
        const SizedBox(height: 10),
        _buildStorySection(), // Anda bisa isi atau placeholder dulu
        const SizedBox(height: 10),
        if (_posts.isEmpty) const Center(child: Text('Belum ada postingan')),
        ..._posts.map((post) => _buildDynamicPostCard(post)),
      ],
    );
  }

  void _onNavBarItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/video');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/friends');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/groups');
    }
  }

  void _addNewPost(
    String content,
    XFile? imageFile,
    XFile? videoFile,
    BuildContext context,
  ) async {
    try {
      final uri = Uri.parse(
        'https://fb.habilazzikri.my.id/facebook-backend/api/postingan.php',
      );
      var request = http.MultipartRequest('POST', uri);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String author =
          '${prefs.getString('userFirstName') ?? ''} ${prefs.getString('userLastName') ?? ''}';
      request.fields['author'] = author;
      request.fields['content'] = content;

      if (imageFile != null) {
        Uint8List imageBytes = await imageFile.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            imageBytes,
            filename: imageFile.name,
          ),
        );
      }

      if (videoFile != null) {
        Uint8List videoBytes = await videoFile.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'video',
            videoBytes,
            filename: videoFile.name,
          ),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      final result = jsonDecode(responseBody);

      if (context.mounted) {
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Berhasil')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal posting. Status: ${response.statusCode}'),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _addNewStory(File image) {
    setState(() {
      _stories.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'author': 'Mhmmd Habil Azzikri',
        'authorImage': 'image/profil.png',
        'image': image,
        'timestamp': DateTime.now(),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          // Navbar at the top
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: FacebookNavBar(
              selectedIndex: _selectedIndex,
              onItemSelected: _onNavBarItemSelected,
            ),
          ),

          // Main content below navbar
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Responsive layout
                if (constraints.maxWidth < 768) {
                  // Mobile layout
                  return _buildMainContent();
                } else {
                  // Desktop layout
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLeftSidebar(),
                      Expanded(flex: 2, child: _buildMainContent()),
                      _buildRightSidebar(),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftSidebar() {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(top: 10, right: 10),

      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildLeftMenuItem("$_firstName $_lastName", Icons.person, false),
            _buildLeftMenuItem("Meta AI", Icons.auto_awesome, true),
            _buildLeftMenuItem("Teman", Icons.people, false),
            _buildLeftMenuItem("Kenangan", Icons.access_time, false),
            _buildLeftMenuItem("Tersimpan", Icons.bookmark, false),
            _buildLeftMenuItem("Grup", Icons.group, false),
            _buildLeftMenuItem("Video", Icons.ondemand_video, false),
            _buildLeftMenuItem("Marketplace", Icons.storefront, false),
            _buildLeftExpander("Lihat selengkapnya", Icons.expand_more),

            const Divider(),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: Text(
                "Pintasan Anda",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            _buildGroupItem(
              "FORUM KOMENTAR KOLUT",
              "http://localhost/flutter_application_1/php/tampilkan.php?id=10",
            ),
            _buildGroupItem(
              "FORUM KOLUT",
              "http://localhost/flutter_application_1/php/tampilkan.php?id=10",
            ),
            _buildGroupItem(
              "WormsZone.io - Slither Snake",
              "http://localhost/flutter_application_1/php/tampilkan.php?id=22",
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftMenuItem(String title, IconData icon, bool isHighlighted) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            isHighlighted ? Colors.blue.shade50 : Colors.transparent,
        child: Icon(
          icon,
          color: isHighlighted ? Colors.blue : Colors.blue.shade700,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        if (title == "Video") {
          Navigator.pushNamed(context, '/video');
        }
      },
    );
  }

  Widget _buildLeftExpander(String title, IconData icon) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Icon(icon, color: Colors.black),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: () {},
    );
  }

  Widget _buildGroupItem(String title, String imageUrl) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 35,
          height: 35,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder:
                (ctx, child, progress) =>
                    progress == null
                        ? child
                        : Center(child: CircularProgressIndicator()),
            errorBuilder:
                (_, __, ___) => Icon(Icons.broken_image, color: Colors.grey),
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildPostCreationCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(
                    'http://localhost/flutter_application_1/php/tampilkan.php?id=20',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showCreatePostDialog(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Apa yang Anda pikirkan, $_firstName?',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => _showCreatePostDialog(context),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.red.shade50,
                        child: const Icon(
                          Icons.videocam,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Video siaran langsung',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _showCreatePostDialog(context),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.green.shade50,
                        child: const Icon(
                          Icons.photo_library,
                          color: Colors.green,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text('Foto/video', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _showCreatePostDialog(context),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.amber.shade50,
                        child: const Icon(
                          Icons.emoji_emotions,
                          color: Colors.amber,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Perasaan/aktivitas',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    XFile? selectedImage;
    XFile? selectedVideo;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: const Text('Buat Postingan'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                            'http://localhost/flutter_application_1/php/tampilkan.php?id=20',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _firstName, // nama user yang sudah dimuat di initState
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),
                    TextField(
                      controller: controller,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Apa yang Anda pikirkan?',
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (selectedImage != null)
                      FutureBuilder<Uint8List>(
                        future: selectedImage!.readAsBytes(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            return Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: MemoryImage(snapshot.data!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (image != null) {
                              setState(() {
                                selectedImage = image;
                              });
                            }
                          },
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Foto'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                              source: ImageSource.camera,
                            );
                            if (image != null) {
                              setState(() {
                                selectedImage = image;
                              });
                            }
                          },
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Kamera'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? video = await picker.pickVideo(
                              source: ImageSource.gallery,
                            );
                            if (video != null) {
                              setState(() {
                                selectedVideo = video;
                              });
                            }
                          },
                          icon: const Icon(Icons.video_library),
                          label: const Text('Video'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty ||
                        selectedImage != null ||
                        selectedVideo != null) {
                      _addNewPost(
                        controller.text,
                        selectedImage,
                        selectedVideo,
                        context,
                      );
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Konten, gambar, atau video tidak boleh kosong',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Posting'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStorySection() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 190,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        children: [
          _buildCreateStoryCard(),
          ..._stories.map((story) => _buildDynamicStoryCard(story)),
          _buildStoryCard(
            "Muhaimin Ilyas",
            "http://localhost/flutter_application_1/php/tampilkan.php?id=18",
          ),
          _buildStoryCard(
            "Nauqi",
            "http://localhost/flutter_application_1/php/tampilkan.php?id=5",
          ),
          _buildStoryCard(
            "Iccank",
            "http://localhost/flutter_application_1/php/tampilkan.php?id=19",
          ),
        ],
      ),
    );
  }

  Widget _buildCreateStoryCard() {
    return GestureDetector(
      onTap: _showCreateStoryDialog,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Center(
                        child: Icon(Icons.add, color: Colors.blue, size: 22),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  'Buat cerita',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateStoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Buat Cerita'),
          content: const Text('Pilih gambar untuk cerita Anda'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    _addNewStory(File(image.path));
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error memilih gambar')),
                  );
                }
              },
              child: const Text('Pilih dari Galeri'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (image != null) {
                    _addNewStory(File(image.path));
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error mengambil foto')),
                  );
                }
              },
              child: const Text('Ambil Foto'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDynamicStoryCard(Map<String, dynamic> story) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Background image fetched from your PHP endpoint
            Positioned.fill(
              child: Image.network(
                story['imageUrl'], // URL you built in _fetchPosts()
                fit: BoxFit.cover,
                loadingBuilder:
                    (ctx, child, prog) =>
                        prog == null
                            ? child
                            : const Center(child: CircularProgressIndicator()),
                errorBuilder:
                    (_, __, ___) => const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
              ),
            ),

            // Optional semi-transparent overlay for better text contrast
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),

            // Small circular avatar also fetched from DB
            Positioned(
              top: 8,
              left: 8,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[300],
                backgroundImage: NetworkImage(
                  story['authorImageUrl'], // e.g. "http://localhost/.../tampilkan.php?id=AUTHOR_ID"
                ),
              ),
            ),

            // Author name at bottom
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Text(
                story['author'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryCard(String name, String imageUrl) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Background story image dari PHP endpoint
            Positioned.fill(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder:
                    (ctx, child, prog) =>
                        prog == null
                            ? child
                            : const Center(child: CircularProgressIndicator()),
                errorBuilder:
                    (_, __, ___) => const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
              ),
            ),

            // Overlay hitam tipis untuk kontras teks (optional)
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),

            // Avatar kecil di pojok kiri atas
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2),
                  // misal avatar statis atau juga dari DB
                  image: DecorationImage(
                    image: NetworkImage(
                      'http://localhost/flutter_application_1/php/tampilkan.php?id=20',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Nama di bawah
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicPostCard(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(
                    'http://localhost/flutter_application_1/php/tampilkan.php?id=20',
                  ),
                ),

                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['author'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            _formatTimestamp(post['timestamp']),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            Icons.public,
                            size: 12,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (String result) {
                    if (result == 'delete') {
                      setState(() {
                        _posts.removeWhere((p) => p['id'] == post['id']);
                      });
                    }
                  },
                  itemBuilder:
                      (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Hapus Post'),
                        ),
                      ],
                  child: const Icon(Icons.more_horiz),
                ),
              ],
            ),
          ),
          if (post['content'].toString().isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                post['content'],
                style: const TextStyle(fontSize: 14),
              ),
            ),
          if (post['image'] != null && post['image'].toString().isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  post['image'],
                  fit: BoxFit.fitWidth, // atau BoxFit.contain
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder:
                      (context, error, stackTrace) => const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
                ),
              ),
            ),
          ],
          if (post['video'] != null && post['video'].toString().isNotEmpty) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: VideoPlayerItem(videoUrl: post['video']),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.thumb_up,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${post['likes']}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Text(
                  '${post['comments']} Komentar · ${post['shares']} Bagikan',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                  post['isLiked'] ? Icons.thumb_up : Icons.thumb_up_outlined,
                  'Suka',
                  post['isLiked'] ? Colors.blue : null,
                  () {
                    setState(() {
                      if (post['isLiked']) {
                        post['likes']--;
                        post['isLiked'] = false;
                      } else {
                        post['likes']++;
                        post['isLiked'] = true;
                      }
                    });
                  },
                ),
                _buildActionButton(Icons.chat_bubble_outline, 'Komentar'),
                _buildActionButton(Icons.share_outlined, 'Bagikan', null, () {
                  setState(() {
                    post['shares']++;
                  });
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    try {
      final DateTime dt =
          timestamp is String ? DateTime.parse(timestamp) : timestamp;
      final difference = DateTime.now().difference(dt);

      if (difference.inMinutes < 1) return 'Baru saja';
      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} menit yang lalu';
      }
      if (difference.inHours < 24) return '${difference.inHours} jam yang lalu';
      return '${difference.inDays} hari yang lalu';
    } catch (_) {
      return 'waktu tidak diketahui';
    }
  }

  Widget _buildActionButton(
    IconData icon,
    String label, [
    Color? color,
    VoidCallback? onPressed,
  ]) {
    return TextButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.grey.shade600, size: 20),
      label: Text(
        label,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
      ),
    );
  }

  Widget _buildRightSidebar() {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(top: 10, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bersponsor',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: _buildSponsorItem(
              'http://localhost/flutter_application_1/php/tampilkan.php?id=24',
              'daftar-->',
              'google.com',
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: _buildSponsorItem(
              'http://localhost/flutter_application_1/php/tampilkan.php?id=15',
              'Mobile Legends',
              'Moonton',
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: _buildContactsSection(),
          ),
        ],
      ),
    );
  }

  // ubah signature jadi terima imageUrl, bukan asset path
  Widget _buildSponsorItem(String imageUrl, String title, String domain) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Row(
        children: [
          // tampilkan image dari network (PHP endpoint)
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              loadingBuilder: (ctx, child, progress) {
                if (progress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              },
              errorBuilder:
                  (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  domain,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kontak',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.search, size: 20),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
        // Ubah pemanggilan di ListView:
        _buildContactItem(
          'Curry',
          'http://localhost/flutter_application_1/php/tampilkan.php?id=3',
        ),
        _buildContactItem(
          'Edward',
          'http://localhost/flutter_application_1/php/tampilkan.php?id=2',
        ),
        _buildContactItem(
          'Nouqi Azzauka',
          'http://localhost/flutter_application_1/php/tampilkan.php?id=5',
        ),
        _buildContactItem(
          'Doncic',
          'http://localhost/flutter_application_1/php/tampilkan.php?id=4',
        ),
      ],
    );
  }

  Widget _buildContactItem(String name, String imageUrl) {
    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundImage: NetworkImage(imageUrl),
        backgroundColor: Colors.grey[300],
      ),
      title: Text(
        name,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
