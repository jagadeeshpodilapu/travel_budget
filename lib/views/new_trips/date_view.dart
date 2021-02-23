import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_budget/models/trip_model.dart';

import 'budget_view.dart';

class NewTripDateView extends StatefulWidget {
  final Trip trip;

  NewTripDateView({Key key, @required this.trip}) : super(key: key);

  @override
  _NewTripDateViewState createState() => _NewTripDateViewState();
}

class _NewTripDateViewState extends State<NewTripDateView> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(
    Duration(days: 5),
  );

  Future displayDateRangePicker(BuildContext context) async {
    final List<DateTime> picked = await DateRangePicker.showDatePicker(
        context: context,
        initialFirstDate: _startDate,
        initialLastDate: _endDate,
        firstDate: DateTime(DateTime.now().year - 50),
        lastDate: DateTime(DateTime.now().year + 50));

    if (picked != null && picked.length == 2) {
      setState(() {
        _startDate = picked[0];
        _endDate = picked[1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Trip-Date"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSelectedDetails(context, widget.trip),
            Spacer(),
            Text("Location : ${widget.trip.title}"),
            RaisedButton(
              onPressed: () async {
                await displayDateRangePicker(context);
              },
              child: Text("select Dates"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                    "startDate :${DateFormat('MM/dd/yyyy').format(_startDate).toString()}"),
                Text(
                    "end date :${DateFormat('MM/dd/yyyy').format(_endDate).toString()}"),
              ],
            ),
            RaisedButton(
              onPressed: () {
                widget.trip.startDate = _startDate;
                widget.trip.endDate = _endDate;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewTripBudgetView(trip: widget.trip),
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

  Widget buildSelectedDetails(BuildContext context, Trip trip) {
    return Hero(
      tag: "SelectedTrip-${trip.title}",
      transitionOnUserGestures: true,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: SingleChildScrollView(
            child: Card(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, left: 16.0, bottom: 16.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(trip.title,
                                  style: TextStyle(fontSize: 30.0)),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text("Average Budget -- Not set up yet®"),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text("Trip Dates"),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text("Trip Budget"),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text("Trip Type"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Placeholder(
                        fallbackHeight: 100,
                        fallbackWidth: 100,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
