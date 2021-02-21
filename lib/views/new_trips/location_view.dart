import 'package:flutter/material.dart';
import 'package:travel_budget/models/trip_model.dart';

import 'date_view.dart';

class NewTripLocationView extends StatelessWidget {
  final Trip trip;

  NewTripLocationView({Key key, @required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = TextEditingController();
    _titleController.text = trip.title;
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Trip-Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter Location"),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                controller: _titleController,
                autofocus: true,
              ),
            ),
            RaisedButton(
              onPressed: () {
                trip.title = _titleController.text;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewTripDateView(trip: trip),
                  ),
                );
              },
              child: Text("Continue"),
            )
          ],
        ),
      ),
    );
  }
}
