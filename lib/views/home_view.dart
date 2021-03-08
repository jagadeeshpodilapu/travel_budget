import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_budget/models/trip_model.dart';
import 'package:travel_budget/widgets/provider_widget.dart';

final auth = FirebaseAuth.instance;

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: getUsersTripsStreamSnapshots(context),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          print("snapshot data is $snapshot");

          if (!snapshot.hasData)
            return const Center(
              child: CircularProgressIndicator(),
            );

          return new ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) =>
                  buildTripCard(context, snapshot.data.docs[index]));
        },
      ),
    );
  }

  Stream<QuerySnapshot> getUsersTripsStreamSnapshots(
      BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUserId();

    print("user id is $uid");
    yield* FirebaseFirestore.instance
        .collection('userData')
        .doc(uid)
        .collection('trips')
        .snapshots();
  }

  Widget buildTripCard(BuildContext context, snapshot) {
    print("${snapshot}");
    final trip = Trip.fromSnapshot(snapshot.data());
    final tripType = trip.types();

    return new Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Row(children: <Widget>[
                  Text(
                    trip.title,
                    style: new TextStyle(fontSize: 30.0),
                  ),
                  Spacer(),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 80.0),
                child: Row(children: <Widget>[
                  Text(
                      "${DateFormat('dd/MM/yyyy').format(trip.startDate).toString()} - ${DateFormat('dd/MM/yyyy').format(trip.endDate).toString()}"),
                  Spacer(),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "\$${(trip.budget == null) ? "n/a" : trip.budget.toStringAsFixed(2)}",
                      style: new TextStyle(fontSize: 35.0),
                    ),
                    Spacer(),
                    (tripType.containsKey(trip.travelType))
                        ? tripType[trip.travelType]
                        : tripType["other"],
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
