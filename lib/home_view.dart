import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_budget/trip_model.dart';

class HomeView extends StatelessWidget {
  final List<Trip> tripList = [
    Trip("title", "travelType", DateTime.now(), DateTime.now(), 200.0),
    Trip("title2", "travelType", DateTime.now(), DateTime.now(), 300.0),
    Trip("title3", "travelType", DateTime.now(), DateTime.now(), 400.0),
    Trip("title4", "travelType", DateTime.now(), DateTime.now(), 500.0),
    Trip("title5", "travelType", DateTime.now(), DateTime.now(), 600.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: tripList.length,
          itemBuilder: (context, index) {
            return Container(
              child: buildTripCard(context, index),
            );
          }),
    );
  }

  Card buildTripCard(BuildContext context, int index) {
    final trip = tripList[index];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    trip.title,
                    style: TextStyle(fontSize: 30),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
              child: Row(
                children: [
                  Text(
                      "${DateFormat('dd/mm/yyyy').format(trip.startDate).toString()} -${DateFormat('dd/mm/yyyy').format(trip.endDate).toString()} "),
                  Spacer(),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "\$${trip.budget.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 35),
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
