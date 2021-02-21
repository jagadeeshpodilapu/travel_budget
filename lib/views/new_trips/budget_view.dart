import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_budget/models/trip_model.dart';

class NewTripBudgetView extends StatelessWidget {
  final db = FirebaseFirestore.instance;
  final Trip trip;

  NewTripBudgetView({Key key, @required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Trip-Budget "),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("finish"),
            Text("Location : ${trip.title}"),
            Text("start Date : ${trip.startDate}"),
            Text("end Date : ${trip.endDate}"),
            RaisedButton(
              onPressed: () async {
                await db.collection("trips").add(trip.toJson());

                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text("finish"),
            )
          ],
        ),
      ),
    );
  }
}
