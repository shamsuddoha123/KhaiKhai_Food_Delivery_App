import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:khaikhai/pages/home.dart';
import 'package:khaikhai/pages/order.dart';
import 'package:khaikhai/pages/profile.dart';
import 'package:khaikhai/pages/wallet.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  late List<dynamic> pages;

  late Home homePage;
  late Order order;
  late Wallet wallet;
  late Profile profilePage;

  int currentTabIndex = 0;

  @override
  void initState() {
    homePage = Home();
    order = Order();
    wallet = Wallet();
    profilePage = Profile();

    pages = [homePage, order, wallet, profilePage];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 70,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },

        items: [
          Icon(Icons.home, color: Colors.white, size: 30.0),
          Icon(Icons.shopping_bag, color: Colors.white, size: 30.0),
          Icon(Icons.wallet, color: Colors.white, size: 30.0),
          Icon(Icons.person, color: Colors.white, size: 30.0),
        ],
      ),

      body: pages[currentTabIndex],
    );
  }
}
