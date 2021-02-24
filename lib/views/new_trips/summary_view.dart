import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_budget/models/trip_model.dart';
import 'package:travel_budget/widgets/provider_widget.dart';

class NewTripSummaryView extends StatelessWidget {
  final db = FirebaseFirestore.instance;
  final Trip trip;

  NewTripSummaryView({Key key, @required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trip Summary"),
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
                final uid = await Provider.of(context).auth.getCurrentUserId();
                await db
                    .collection("userData")
                    .doc(uid)
                    .collection("trips")
                    .add(trip.toJson());

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
