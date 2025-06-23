import 'package:flutter/material.dart';
import 'navbar.dart';
import 'marketplacesidebar.dart';
import 'marketplace_grid.dart';
import 'facebook_home_web.dart';
import 'video.dart';
import 'friends.dart';

class MarketplaceMainPage extends StatefulWidget {
  const MarketplaceMainPage({super.key});

  @override
  State<MarketplaceMainPage> createState() => _MarketplaceMainPageState();
}

class _MarketplaceMainPageState extends State<MarketplaceMainPage> {
  final int _selectedIndex = 2; // Marketplace → index ke-2

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    String? route;
    switch (index) {
      case 0:
        route = '/home';
        break;
      case 1:
        route = '/video';
        break;
      case 2:
        route = '/friends'; // ✅ Update ke halaman Teman
        break;
      case 3:
        route = '/marketplace'; // ✅ Sesuaikan jika perlu
        break;
      case 4:
        route = '/groups'; // Pastikan route ini juga didefinisikan
        break;
      case 5:
        route = '/notifications'; // Optional jika ada
        break;
    }

    if (route != null) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: FacebookNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 280,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(12),
              child: MarketplaceSidebarHeader(),
            ),
          ),
          const VerticalDivider(width: 1),
          const Expanded(child: MarketplaceGrid()),
        ],
      ),
    );
  }
}
