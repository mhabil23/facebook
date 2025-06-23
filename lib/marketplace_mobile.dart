import 'package:flutter/material.dart';
import 'navbar.mobile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facebook Marketplace',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: MarketplaceMobileScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MarketplaceMobileScreen extends StatefulWidget {
  @override
  _MarketplaceScreenState createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceMobileScreen> {
  int _selectedIndex = 3; // Marketplace tab aktif

  // Sekarang setiap Product punya id
  final List<Product> products = [
    Product(
      id: 12,
      price: 'Rp 150.000',
      title: 'Kemeja Premium',
      location: 'Makassar',
      timePosted: '2 hari yang lalu',
    ),
    Product(
      id: 11,
      price: 'Rp. 10.000.000',
      title: 'Iphone',
      location: 'Makassar',
      timePosted: '1 hari yang lalu',
    ),
    Product(
      id: 13,
      price: 'Rp 150.000.000',
      title: 'Mazda',
      location: 'Makassar',
      timePosted: '3 jam yang lalu',
    ),
    Product(
      id: 9,
      price: 'Rp 15.000.000',
      title: 'Yamaha Fino',
      location: 'Makassar',
      timePosted: '5 jam yang lalu',
    ),
    Product(
      id: 17,
      price: 'Rp 2.500.000',
      title: 'Piano',
      location: 'Makassar',
      timePosted: '1 hari yang lalu',
    ),
    Product(
      id: 14,
      price: 'Rp 8.500.000',
      title: 'Mesin Cuci',
      location: 'Makassar',
      timePosted: '4 jam yang lalu',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          _buildLocationFilter(),
          Expanded(child: _buildProductGrid()),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Marketplace',
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        _iconButton(Icons.messenger_outline),
        _iconButton(Icons.person_outline),
        _iconButton(Icons.search),
      ],
    );
  }

  Widget _iconButton(IconData icon) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFFE4E6EA),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black, size: 20),
      ),
      onPressed: () {},
    );
  }

  Widget _buildBottomNavBar() {
    return FacebookNavBarMobile(
      selectedIndex: _selectedIndex,
      onItemTapped: (i) {
        if (i != _selectedIndex) {
          setState(() => _selectedIndex = i);
          _handleNavigation(i);
        }
      },
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/video');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/friends');
        break;
      case 3:
        break; // Marketplace
      case 4:
        Navigator.pushReplacementNamed(context, '/notifications');
        break;
      case 5:
        Navigator.pushReplacementNamed(context, '/menu');
        break;
    }
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildTab('Jual', false, () {}),
          _buildTab('Untuk Anda', true, () {}),
          _buildTab('Kategori', false, () {}),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 24),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? Color(0xFF1877F2) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isActive ? Color(0xFF1877F2) : Color(0xFF65676B),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            'Pilihan hari ini',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Icon(Icons.location_on, color: Color(0xFF1877F2), size: 16),
              SizedBox(width: 4),
              Text(
                'Kota Makassar • 190 km',
                style: TextStyle(
                  color: Color(0xFF1877F2),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: products.length,
        itemBuilder: (_, i) => _buildProductCard(products[i]),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => _showProductDetail(context, product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar dari network
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
                child: Image.network(
                  'http://localhost/flutter_application_1/php/tampilkan.php?id=${product.id}',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder:
                      (ctx, child, lo) =>
                          lo == null
                              ? child
                              : const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                  errorBuilder:
                      (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),
                ),
              ),
            ),
            // Info produk
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.price,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF65676B),
                      ),
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

  void _showProductDetail(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProductDetailSheet(product: product),
    );
  }
}

class ProductDetailSheet extends StatelessWidget {
  final Product product;
  const ProductDetailSheet({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (_, scroll) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SingleChildScrollView(
            controller: scroll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Center(
                  child: Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFFE4E6EA),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Gambar detail
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Image.network(
                    'http://localhost/flutter_application_1/php/tampilkan.php?id=${product.id}',
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                          color: Color(0xFFE4E6EA),
                          child: Icon(
                            Icons.image_not_supported,
                            size: 64,
                            color: Color(0xFF8A8D91),
                          ),
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.price,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(product.title, style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 12),
                      Text(
                        '${product.location} • ${product.timePosted}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF65676B),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1877F2),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                'Hubungi Penjual',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFE4E6EA)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.favorite_border,
                                color: Color(0xFF65676B),
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
          ),
        );
      },
    );
  }
}

class Product {
  final int id;
  final String price;
  final String title;
  final String location;
  final String timePosted;

  Product({
    required this.id,
    required this.price,
    required this.title,
    required this.location,
    required this.timePosted,
  });
}
