import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:travel_budget/credentials.dart';
import 'package:travel_budget/models/place.dart';
import 'package:travel_budget/models/trip_model.dart';
import 'package:uuid/uuid.dart';

import 'date_view.dart';

class NewTripLocationView extends StatefulWidget {
  final Trip trip;

  NewTripLocationView({Key key, @required this.trip}) : super(key: key);

  @override
  _NewTripLocationViewState createState() => _NewTripLocationViewState();
}

class _NewTripLocationViewState extends State<NewTripLocationView> {
  String _heading;
  List<Place> _placesList;
  List<Place> _suggestionList = [
    Place("New York", 320.00, ""),
    Place("Austin", 250.00, ""),
    Place("Boston", 290.00, ""),
    Place("Florence", 300.00, ""),
    Place("Washington D.C.", 190.00, ""),
  ];
  int _calls = 0;
  TextEditingController _searchController = TextEditingController();
  Timer _throttle;
  var uuid = new Uuid();
  String _sessionToken;

  @override
  void initState() {
    _heading = "Suggestions";
    _placesList = _suggestionList;
    _searchController.addListener(() {
      _onSearchChanged();
    });
    super.initState();
  }

  _onSearchChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getLocationResults(_searchController.text);
  }

  void getLocationResults(String input) async {
    if (input.isEmpty) {
      setState(() {
        _heading = 'Suggestions';
      });
      return;
    }
    String baseUrl =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    String type = '(regions)';
    //TODO Add session token
    String request = '$baseUrl?input=$input&key=$PLACES_API_KEY&type=$type';
    Response response = await Dio().get(request);
    final predictions = response.data['predictions'];

    print("my predection data is $predictions");

    List<Place> _displayResults = [];

    for (var i = 0; i < predictions.length; i++) {
      String name = predictions[i]['description'];
      String placeId = predictions[i]['place_id'];

      //TODO figureOut the budget
      double averageBudget = 200.0;
      _displayResults.add(Place(name, averageBudget, placeId));
    }

    setState(() {
      _heading = "Results";
      _suggestionList = _displayResults;
      _calls++;
    });
  }

  Future<String> getLocationPhotoRef(placeId) async {
    var _sessionToken;
    String placeImageReq =
        "https://maps.googleapis.com/maps/api/place/details/json?$placeId=photo&key=$PLACES_API_KEY&sessionToken=$_sessionToken";
    Response placeDetails = await Dio().get(placeImageReq);
    return placeDetails.data["result"]["photos"][0]["photo_reference"];
  }

  @override
  void dispose() {
    _searchController.removeListener(() {
      _onSearchChanged();
      _searchController.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Trip-Location"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("API calls :$_calls"),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                ),
                /*  onChanged: (text) {
                  getLocationResults(text);
                },*/
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: DividerWithText(
                dividerText: _heading,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _placesList.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildPlaceCard(context, index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlaceCard(BuildContext context, int index) {
    return Hero(
      tag: "SelectedTrip-${_placesList[index].name}",
      transitionOnUserGestures: true,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Card(
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: AutoSizeText(_placesList[index].name,
                                    maxLines: 3,
                                    style: TextStyle(fontSize: 22.0)),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                  "Average Budget \$${_placesList[index].averageBudget.toStringAsFixed(2)}"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () async {
                String photoReference =
                    await getLocationPhotoRef(_placesList[index].placeId);

                widget.trip.title = _placesList[index].name;
                widget.trip.photoReference = photoReference;
                setState(() {
                  _sessionToken = null;
                });
                // that would need to be added to the Trip object
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewTripDateView(trip: widget.trip)),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class DividerWithText extends StatelessWidget {
  final String dividerText;

  DividerWithText({
    Key key,
    @required this.dividerText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Divider(),
        )),
        Text(dividerText),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Divider(),
        ),
      ],
    );
  }
}
