import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: getUserTripsStreamSnapshots(context),
          builder: (context, snapshot) {
            print(" data is ${snapshot.data}");
            if (!snapshot.hasData) {
              return Center(child: const Text("Loading..."));
            }
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: buildTripCard(context, snapshot.data.docs[index]),
                  );
                });
          }),
    );
  }

  Stream<QuerySnapshot> getUserTripsStreamSnapshots(
      BuildContext context) async* {
    final uid = FirebaseAuth.instance.currentUser.uid;
    print("uid is $uid");
    yield* FirebaseFirestore.instance
        .collection("userData")
        .doc("$uid")
        .collection("trips")
        .snapshots();
  }

  Card buildTripCard(BuildContext context, DocumentSnapshot trip) {
    print("my trip data $trip");
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 3.0),
              child: Row(
                children: [
                  Text(
                    trip['title'],
                    style: TextStyle(fontSize: 22),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 4.0),
              child: Row(
                children: [
                  Text(
                      "${DateFormat('dd/mm/yyyy').format(trip['startDate'].toDate()).toString()} -${DateFormat('dd/mm/yyyy').format(trip['endDate'].toDate()).toString()} "),
                  Spacer(),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Text(
                  " \$${(trip['budget'] == null) ? "0.00" : trip['budget'].toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 30),
                ),
                Spacer(),
                Icon(Icons.directions_car),
              ],
            )
          ],
        ),
      ),
    );
  }
}
