import 'package:flutter/material.dart';
import 'package:flutter_application_1/facebook_home_mobile.dart';
import 'package:flutter_application_1/facebook_home_web.dart';
import 'package:flutter_application_1/marketplace_main.dart';
import 'package:flutter_application_1/video.dart';
import 'package:flutter_application_1/marketplace_mobile.dart';
import 'package:flutter_application_1/login_mobile.dart';
import 'package:flutter_application_1/login_web.dart';
import 'package:flutter_application_1/friends.dart';
import 'responsive_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facebook Clone',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const ResponsiveLoginScreen(),
        '/home':
            (context) => const ResponsiveWidget(
              mobileBuilder: FacebookHomePageMobile.new,
              desktopBuilder: FacebookHomePage.new,
            ),
        '/friends': (context) => const TemanPage(),
        '/video': (context) => const ResponsiveFacebookVideoPage(),

        '/marketplace':
            (context) => const ResponsiveWidget(
              mobileBuilder: MarketplaceMobileScreen.new,
              desktopBuilder: MarketplaceMainPage.new,
            ),
      },
    );
  }
}

class ResponsiveLoginScreen extends StatelessWidget {
  const ResponsiveLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveWidget(
      mobileBuilder: FacebookLoginScreenMobile.new,
      desktopBuilder: FacebookLoginScreenWeb.new,
    );
  }
}
