import 'package:flutter/material.dart';

class Trip {
  String title;
  DateTime startDate;
  DateTime endDate;
  double budget;
  Map budgetTypes;
  String travelType;
  String photoreference;

  Trip(this.title, this.startDate, this.endDate, this.budget, this.budgetTypes,
      this.travelType);

  //formatting for upload firebase
  Map<String, dynamic> toJson() => {
        "title": title,
        "startDate": startDate,
        "endDate": endDate,
        "budget": budget,
        "budgetType": budgetTypes,
        "travelType": travelType,
        "photoReference": photoreference,
      };

  //creating a Trip object from a firebase snapshot
  Trip.fromSnapshot(snapshot)
      : title = snapshot["title"],
        startDate = snapshot["startDate"].toDate(),
        endDate = snapshot["endDate"].toDate(),
        budget = snapshot["budget"],
        budgetTypes = snapshot["budgetTypes"],
        travelType = snapshot["travelType"];

  Map<String, Icon> types() => {
        "car": Icon(
          Icons.directions_car,
          size: 50,
        ),
        "bus": Icon(
          Icons.directions_bus,
          size: 50,
        ),
        "train": Icon(
          Icons.train,
          size: 50,
        ),
        "plane": Icon(
          Icons.airplanemode_active,
          size: 50,
        ),
        "ship": Icon(
          Icons.directions_boat,
          size: 50,
        ),
        "Others": Icon(
          Icons.directions,
          size: 50,
        )
      };
}
