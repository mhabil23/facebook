import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/navbar.mobile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'video_player_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facebook Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const FacebookHomePageMobile(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Model untuk Post
class Post {
  final int id;
  final String author;
  final String authorImage;
  final String content;
  final String image;
  final String video;
  final int likes;
  final bool isLiked;
  final int comments;
  final int shares;
  final String timestamp;

  Post({
    required this.id,
    required this.author,
    required this.authorImage,
    required this.content,
    required this.image,
    required this.video,
    required this.likes,
    required this.isLiked,
    required this.comments,
    required this.shares,
    required this.timestamp,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    final rawId =
        (json['authorImage'] as String?)?.trim().isNotEmpty == true
            ? json['authorImage']
            : '2';
    final authorImageUrl =
        'http://localhost/flutter_application_1/php/tampilkan.php?id=20';
    return Post(
      id: json['id'] ?? 0,
      author: json['author'] ?? 'Unknown',
      authorImage: authorImageUrl,
      content: json['content'] ?? '',
      image: json['image'] ?? '',
      video: json['video'] ?? '',
      likes: json['likes'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      comments: json['comments'] ?? 0,
      shares: json['shares'] ?? 0,
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class FacebookHomePageMobile extends StatefulWidget {
  const FacebookHomePageMobile({Key? key}) : super(key: key);

  @override
  State<FacebookHomePageMobile> createState() => _FacebookHomePageState();
}

class _FacebookHomePageState extends State<FacebookHomePageMobile> {
  final ScrollController _mainScrollController = ScrollController();
  final ScrollController _storyScrollController = ScrollController();
  String _firstName = '';
  String _lastName = '';

  List<Post> posts = [];
  bool isLoading = true;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchPosts();
    _mainScrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _mainScrollController.removeListener(_syncScrolls);
    _mainScrollController.dispose();
    _storyScrollController.dispose();
    super.dispose();
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('userFirstName') ?? '';
      _lastName = prefs.getString('userLastName') ?? '';
    });
  }

  void _syncScrolls() {
    if (_mainScrollController.offset > 50) {
      _storyScrollController.jumpTo(_mainScrollController.offset * 0.5);
    }
  }

  // Fetch posts dari API
  Future<void> _fetchPosts() async {
    try {
      setState(() {
        if (!isRefreshing) isLoading = true;
      });

      final response = await http.get(
        Uri.parse(
          'http://fb.habilazzikri.my.id/facebook-backend/api/get_postingan.php',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == true) {
          final List<dynamic> postsJson = data['posts'] ?? [];
          setState(() {
            posts = postsJson.map((json) => Post.fromJson(json)).toList();
          });
        } else {
          _showSnackBar('Gagal memuat postingan');
        }
      } else {
        _showSnackBar('Error: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
        isRefreshing = false;
      });
    }
  }

  // Refresh posts
  Future<void> _refreshPosts() async {
    setState(() {
      isRefreshing = true;
    });
    await _fetchPosts();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showCreatePostDialog(BuildContext context) {
    final TextEditingController contentController = TextEditingController();
    XFile? selectedImage;
    XFile? selectedVideo;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Buat Postingan'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: contentController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Apa yang Anda pikirkan?',
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (selectedImage != null)
                    FutureBuilder<Uint8List>(
                      future: selectedImage!.readAsBytes(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return Image.memory(
                            snapshot.data!,
                            height: 150,
                            fit: BoxFit.cover,
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final XFile? img = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (img != null) {
                            setState(() => selectedImage = img);
                          }
                        },
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Galeri'),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final XFile? img = await picker.pickImage(
                            source: ImageSource.camera,
                          );
                          if (img != null) {
                            setState(() => selectedImage = img);
                          }
                        },
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Kamera'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final XFile? video = await picker.pickVideo(
                            source: ImageSource.gallery,
                          );
                          if (video != null) {
                            setState(() => selectedVideo = video);
                          }
                        },
                        icon: const Icon(Icons.video_library),
                        label: const Text('Video'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (contentController.text.isNotEmpty ||
                        selectedImage != null ||
                        selectedVideo != null) {
                      _addNewPost(
                        contentController.text,
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

  Future<void> _addNewPost(
    String content,
    XFile? image,
    XFile? selectedVideo,
    BuildContext context,
  ) async {
    try {
      final uri = Uri.parse(
        'http://fb.habilazzikri.my.id/facebook-backend/api/postingan.php',
      );
      void _loadUserData() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          _firstName = prefs.getString('userFirstName') ?? '';
          _lastName = prefs.getString('userLastName') ?? '';
        });
      }

      final request =
          http.MultipartRequest('POST', uri)
            ..fields['author'] = '$_firstName $_lastName'
            ..fields['content'] = content;

      if (image != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            await image.readAsBytes(),
            filename: image.name,
          ),
        );
      }
      if (selectedVideo != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'video',
            await selectedVideo.readAsBytes(),
            filename: selectedVideo.name,
          ),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final result = jsonDecode(responseBody);
      if (response.statusCode == 200 && result['success']) {
        _showSnackBar(result['message']);
        // Refresh posts setelah berhasil posting
        _fetchPosts();
      } else {
        _showSnackBar('Gagal posting');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  // Format timestamp untuk ditampilkan
  String _formatTimestamp(String timestamp) {
    try {
      final DateTime dateTime = DateTime.parse(timestamp);
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays}h';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}j';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m';
      } else {
        return 'Baru saja';
      }
    } catch (e) {
      return 'Baru saja';
    }
  }

  // Widget untuk membuat post card
  Widget _buildPostCard(Post post) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          // Post header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: ClipOval(
                        child:
                            post.authorImage.startsWith('http')
                                ? Image.network(
                                  post.authorImage,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    );
                                  },
                                )
                                : const Icon(Icons.person, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.author,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              _formatTimestamp(post.timestamp),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const Text(
                              ' · ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const Icon(
                              Icons.public,
                              color: Colors.grey,
                              size: 14,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.more_horiz, color: Colors.grey, size: 24),
              ],
            ),
          ),

          // Post content
          if (post.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                width: double.infinity,
                child: Text(
                  post.content,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.left,
                ),
              ),
            ),

          // Post image
          if (post.image.isNotEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.network(
                post.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          if (post.video.isNotEmpty) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: VideoPlayerItem(videoUrl: post.video),
            ),
          ],

          // Post reactions
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Column(
              children: [
                // Reaction counts
                if (post.likes > 0 || post.comments > 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (post.likes > 0) ...[
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.thumb_up,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${post.likes}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (post.comments > 0)
                        Text(
                          '${post.comments} komentar',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),

                if (post.likes > 0 || post.comments > 0)
                  const SizedBox(height: 8),

                // Divider
                const Divider(height: 1, color: Colors.grey),
                const SizedBox(height: 4),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        post.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                        color: post.isLiked ? Colors.blue : Colors.grey,
                      ),
                      label: Text(
                        'Suka',
                        style: TextStyle(
                          color: post.isLiked ? Colors.blue : Colors.grey,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.transparent,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.grey,
                      ),
                      label: const Text(
                        'Komentar',
                        style: TextStyle(color: Colors.grey),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.transparent,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.send, color: Colors.grey),
                      label: const Text(
                        'Kirim',
                        style: TextStyle(color: Colors.grey),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.transparent,
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

  // Tambahkan variabel state untuk mengontrol visibility stories
  bool _showStories = true;
  double _lastScrollPosition = 0;

  void _showPlusMenu(BuildContext context, Offset position) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu(
      context: context,
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      position: RelativeRect.fromRect(
        position & const Size(40, 40), // Posisi klik
        Offset.zero & overlay.size, // Area overlay
      ),
      items: [
        _buildPopupMenuItem(Icons.edit_outlined, 'Postingan'),
        _buildPopupMenuItem(Icons.menu_book_outlined, 'Cerita'),
        _buildPopupMenuItem(Icons.play_circle_outline, 'Reel'),
        _buildPopupMenuItem(Icons.videocam_outlined, 'Siaran Langsung'),
        _buildPopupMenuItem(Icons.sticky_note_2_outlined, 'Catatan'),
        _buildPopupMenuItem(Icons.auto_awesome_outlined, 'AI'),
      ],
    );
  }

  PopupMenuItem _buildPopupMenuItem(IconData icon, String title) {
    return PopupMenuItem(
      height: 56,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 24, color: Colors.black87),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onScroll() {
    final currentScrollPosition = _mainScrollController.position.pixels;
    final scrollDirection = currentScrollPosition - _lastScrollPosition;

    // Hide stories when scrolling down, show when scrolling up
    if (scrollDirection > 0 && _showStories && currentScrollPosition > 100) {
      // Scrolling down
      setState(() {
        _showStories = false;
      });
    } else if (scrollDirection < 0 &&
        !_showStories &&
        currentScrollPosition < 50) {
      // Scrolling up
      setState(() {
        _showStories = true;
      });
    }

    _lastScrollPosition = currentScrollPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _mainScrollController,
        slivers: [
          _buildAppBar(),
          _buildCreatePostSection(),
          _buildStoriesSection(),
          _buildPostsList(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // App Bar dengan header Facebook
  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: false,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_buildLeftHeaderSection(), _buildRightHeaderSection()],
            ),
          ),
        ),
      ),
    );
  }

  // Bagian kiri header (menu dan logo)
  Widget _buildLeftHeaderSection() {
    return Row(
      children: [
        Text(
          'facebook',
          style: TextStyle(
            color: Colors.blue[700],
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Bagian kanan header (tombol aksi)
  Widget _buildRightHeaderSection() {
    return Row(
      children: [
        _buildAddButton(context),
        const SizedBox(width: 12),
        _buildCircularButton(Icons.search),
        const SizedBox(width: 12),
        _buildMessageButton(),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        _showPlusMenu(context, details.globalPosition);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8.0),
        child: const Icon(Icons.add, color: Colors.black, size: 24),
      ),
    );
  }

  // Tombol circular untuk header
  Widget _buildCircularButton(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(8.0),
      child: Icon(icon, color: Colors.black, size: 24),
    );
  }

  // Tombol pesan dengan badge notifikasi
  Widget _buildMessageButton() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8.0),
          child: const Icon(Icons.message, color: Colors.black, size: 24),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(minWidth: 10, minHeight: 10),
          ),
        ),
      ],
    );
  }

  // Bagian untuk membuat post
  Widget _buildCreatePostSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xFFDDDDDD), width: 1.0),
          ),
        ),
        child: GestureDetector(
          onTap: () => _showCreatePostDialog(context),
          child: Row(
            children: [
              _buildProfileAvatar(),
              const SizedBox(width: 12),
              _buildPostInputField(),
              const SizedBox(width: 8),
              _buildPhotoButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Avatar profil untuk create post
  Widget _buildProfileAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFDDDDDD),
      ),
      child: ClipOval(
        child: Image.network(
          'https://via.placeholder.com/40',
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.person, color: Colors.grey);
          },
        ),
      ),
    );
  }

  // Field input untuk post
  Widget _buildPostInputField() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          'Apa yang Anda pikirkan, ${_firstName.isNotEmpty ? _firstName : ''}?',
          style: const TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ),
    );
  }

  // Tombol foto untuk post
  Widget _buildPhotoButton() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.photo_library, color: Colors.grey),
    );
  }

  // Bagian stories
  // Bagian stories yang diperbaiki
  Widget _buildStoriesSection() {
    return SliverToBoxAdapter(
      child: Container(
        height: 200,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          controller: _storyScrollController,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: [
            _buildCreateStoryCard(),
            _buildFriendStoryCard(
              'Muh Faqih\nFadillah Yusuf',
              'https://via.placeholder.com/110x200/FF6B6B/FFFFFF',
              Colors.blue,
            ),
            _buildMusicStoryCard(),
            _buildFriendStoryCard(
              'Muham\nRaihan K',
              'https://via.placeholder.com/110x200/4ECDC4/FFFFFF',
              Colors.green,
            ),
            _buildFriendStoryCard(
              'Sarah\nAmelia',
              'https://via.placeholder.com/110x200/45B7D1/FFFFFF',
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  // Card untuk membuat story yang diperbaiki
  Widget _buildCreateStoryCard() {
    return Container(
      width: 110,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Bagian foto profil
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          'https://via.placeholder.com/60',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bagian tombol dan teks
          Expanded(
            flex: 1,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Buat cerita',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                // Tombol plus yang overlap
                Positioned(
                  top: -12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue[600],
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Card story teman yang diperbaiki
  Widget _buildFriendStoryCard(
    String name,
    String imageUrl,
    Color borderColor,
  ) {
    return Container(
      width: 110,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            // Background image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
            // Avatar profil
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor, width: 3),
                ),
                child: ClipOval(
                  child: Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            // Nama pengguna
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black54,
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

  // Card story musik yang diperbaiki
  Widget _buildMusicStoryCard() {
    return Container(
      width: 110,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            // Background image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://via.placeholder.com/110x200/1a1a1a/FFFFFF',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            // Icon musik
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.5),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.music_note,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            // Nama artis
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'TOKIPIYU',
                    style: TextStyle(
                      color: Colors.yellow[400],
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      shadows: const [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Label kategori
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Untuk Anda',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Musik',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Daftar posts
  Widget _buildPostsList() {
    if (isLoading) {
      return const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (posts.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(child: Text('Belum ada postingan.')),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildPostCard(posts[index]),
        childCount: posts.length,
      ),
    );
  }

  // Bottom navigation bar
  Widget _buildBottomNavigationBar() {
    return FacebookNavBarMobile(
      selectedIndex: 0, // 0 = Beranda
      onItemTapped: (index) {
        if (index != 0) {
          switch (index) {
            case 1:
              Navigator.pushReplacementNamed(context, '/video');
              break;
            case 2:
              Navigator.pushReplacementNamed(
                context,
                '/friends',
              ); // ✅ ini memanggil friend.dart
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/marketplace');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/notifications');
              break;
            case 5:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        }
      },
    );
  }
}
