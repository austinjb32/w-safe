import 'dart:math';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/pages/daily_page.dart';
import 'package:flutter_finance_app/pages/location.dart' as sp;
import 'package:flutter_finance_app/pages/profile.dart';
import 'package:flutter_finance_app/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_finance_app/pages/signup.dart';

import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int pageIndex = 0;
  Color _buttonColor = Colors.blue;

  final _random = Random();
  final _colorList = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  void _changeColor() {
    setState(() {
      _buttonColor = _colorList[_random.nextInt(_colorList.length)];
    });
  }

  void logoutPage(BuildContext context) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final userDocRef = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
        await userDocRef.update({
          'status': 'Offline',
        });
      }

      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print("Error logging out: $e");
      // Handle any error that occurred during the logout process
      // For example, display an error message to the user
    }
  }

  List<Widget> getPages() {
    return [
      DailyPage(),
      sp.LocationPage(),
      ProfilePage(),
      Container(), // Placeholder for the logout page, replace it with your desired widget
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = getPages();

    return Scaffold(
      backgroundColor: primary,
      body: getBody(pages),
      bottomNavigationBar: getFooter(pages.length),
      floatingActionButton: SafeArea(
        child: SizedBox(
          child: FloatingActionButton(
            child: Icon(
              Icons.face,
              size: 20,
            ),
            backgroundColor: _buttonColor,
            onPressed: _changeColor,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget getBody(List<Widget> pages) {
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  Widget getFooter(int itemCount) {
    List<IconData> iconItems = [
      CupertinoIcons.home,
      CupertinoIcons.location_solid,
      CupertinoIcons.person,
      CupertinoIcons.arrow_counterclockwise,
    ];
    return AnimatedBottomNavigationBar(
      backgroundColor: primary,
      icons: iconItems,
      splashColor: secondary,
      inactiveColor: black.withOpacity(0.5),
      gapLocation: GapLocation.center,
      activeIndex: pageIndex,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 10,
      iconSize: 25,
      rightCornerRadius: 10,
      elevation: 2,
      onTap: (index) {
        if (index == itemCount - 1) {
          logoutPage(context);
        } else {
          setTabs(index);
        }
      },
    );
  }

  setTabs(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
