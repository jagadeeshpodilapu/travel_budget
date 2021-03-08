import 'package:flutter/material.dart';
import 'package:travel_budget/pages.dart';
import 'package:travel_budget/services/auth_services.dart';
import 'package:travel_budget/views/new_trips/location_view.dart';
import 'package:travel_budget/widgets/provider_widget.dart';

import '../models/trip_model.dart';
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
    final newTrip = Trip(null, null, null, null, null, null);
    return Scaffold(
      appBar: AppBar(
        title: Text("Travel budget"),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewTripLocationView(trip: newTrip),
                  ),
                );
              }),
          IconButton(
              icon: Icon(Icons.undo),
              onPressed: () async {
                try {
                  AuthService auth = Provider.of(context).auth;
                  await auth.signOut();
                  print("signed out");
                } catch (e) {
                  print(e);
                }
              }),
          IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.pushNamed(context, '/convertUser');
              })
        ],
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
