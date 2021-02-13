import 'package:flutter/material.dart';
import 'package:travel_budget/pages.dart';

import 'home_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [HomeView(), ExplorePage(), PastTrips()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Travel budget"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTabbed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blueAccent,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: "Past Trips"),
        ],
      ),
      body: _children[_currentIndex],
    );
  }

  void onTabTabbed(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
