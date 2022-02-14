import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'info_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  Widget body = const HomeScreen();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          inactiveColor: Colors.black54,
          icons: const [Icons.home, Icons.info],
          activeIndex: currentIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.smoothEdge,
          onTap: (index) {
            //
            if (index == 0) {
              body = const HomeScreen();
            } else {
              body = const InfoScreen();
            }
            setState(() {
              currentIndex = index;
            });
          },
        ),
        body: body,
      ),
    );
  }
}
