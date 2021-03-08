import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_budget/models/trip_model.dart';
import 'package:travel_budget/widgets/provider_widget.dart';

class NewTripSummaryView extends StatelessWidget {
  final db = FirebaseFirestore.instance;
  final Trip trip;

  NewTripSummaryView({Key key, @required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tripTypes = trip.types();
    var tripKeys = tripTypes.keys.toList();
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
            Text(
                "${DateFormat('dd/MM/yyyy').format(trip.startDate).toString()} - ${DateFormat('dd/MM/yyyy').format(trip.endDate).toString()}"),
            Text("end Date : ${trip.endDate}"),
            Expanded(
                child: GridView.count(
              crossAxisCount: 3,
              scrollDirection: Axis.vertical,
              primary: false,
              children: List.generate(tripTypes.length, (index) {
                return FlatButton(
                  onPressed: () async {
                    trip.travelType = tripKeys[index];
                    final uid =
                        await Provider.of(context).auth.getCurrentUserId();
                    await db
                        .collection("userData")
                        .doc(uid)
                        .collection("trips")
                        .add(trip.toJson());

                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      tripTypes[tripKeys[index]],
                      Text(tripKeys[index]),
                    ],
                  ),
                );
              }),
            )),
          ],
        ),
      ),
    );
  }
}
