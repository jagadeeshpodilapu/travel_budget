import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travel_budget/models/trip_model.dart';
import 'package:travel_budget/views/new_trips/summary_view.dart';

class NewTripBudgetView extends StatelessWidget {
  final db = FirebaseFirestore.instance;
  final Trip trip;

  NewTripBudgetView({Key key, @required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _budgetController = TextEditingController();
    _budgetController.text =
        (trip.budget == null) ? "" : trip.budget.toStringAsFixed(0);
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Trip-Budget "),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter a Trip Budget"),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                controller: _budgetController,
                maxLines: 1,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.attach_money),
                    helperText: "Daily estimated Budget "),
                keyboardType: TextInputType.numberWithOptions(decimal: false),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autofocus: true,
              ),
            ),
            RaisedButton(
              onPressed: () async {
                trip.budget = (_budgetController.text == null)
                    ? 0
                    : double.parse(_budgetController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewTripSummaryView(trip: trip),
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
