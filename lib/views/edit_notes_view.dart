import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_budget/models/trip_model.dart';
import 'package:travel_budget/widgets/provider_widget.dart';

class EditNotesView extends StatefulWidget {
  final Trip trip;

  EditNotesView({Key key, this.trip}) : super(key: key);

  @override
  _EditNotesViewState createState() => _EditNotesViewState();
}

class _EditNotesViewState extends State<EditNotesView> {
  TextEditingController _notesController = TextEditingController();

  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _notesController.text = widget.trip.notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.deepPurpleAccent,
        child: Hero(
          tag: "TripNotes-${widget.trip.title}",
          transitionOnUserGestures: true,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildHeading(context),
                  buildNotesText(),
                  buildSubmitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeading(context) {
    return Material(
      //here material is only for the purpose of hero widget
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 10),
        child: Row(
          children: [
            Expanded(
              child: Text("Trip Notes",
                  style: TextStyle(fontSize: 24, color: Colors.white)),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
              label: Text(""),
            )
          ],
        ),
      ),
      color: Colors.deepPurpleAccent,
    );
  }

  Widget buildNotesText() {
    return Material(
      color: Colors.deepPurpleAccent,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextField(
          controller: _notesController,
          autofocus: true,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget buildSubmitButton(context) {
    return Material(
      color: Colors.deepPurpleAccent,
      child: MaterialButton(
        child: Text("Save"),
        color: Colors.greenAccent,
        onPressed: () async {
          widget.trip.notes = _notesController.text;
          final uid = await Provider.of(context).auth.getCurrentUserId();
          await db
              .collection("userData")
              .doc(uid)
              .collection("trips")
              .doc(widget.trip.documentId)
              .update({"notes": _notesController.text});

          Navigator.pop(context);
        },
      ),
    );
  }
}
