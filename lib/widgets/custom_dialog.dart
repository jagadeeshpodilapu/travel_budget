import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title,
      description,
      primaryButtonText,
      primaryButtonRoute,
      secondaryButtonText,
      secondaryRoute;
  final primaryColor = const Color(0xFF75A2EA);

  CustomDialog(
      {@required this.title,
      @required this.description,
      @required this.primaryButtonText,
      @required this.primaryButtonRoute,
      this.secondaryButtonText,
      this.secondaryRoute});

  static const double padding = 20.0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(padding),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(padding),
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  )
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 24,
                ),
                AutoSizeText(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                  ),
                ),
                AutoSizeText(
                  description,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context)
                        .pushReplacementNamed(primaryButtonRoute);
                  },
                  color: primaryColor,
                  child: AutoSizeText(
                    "$primaryButtonText",
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                showSecondaryButton(context),
              ],
            ),
          )
        ],
      ),
    );
  }

  showSecondaryButton(BuildContext context) {
    if (secondaryRoute != null && secondaryButtonText != null) {
      return FlatButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.of(context).pushReplacementNamed(secondaryRoute);
        },
        child: AutoSizeText(
          "$secondaryButtonText",
          maxLines: 1,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 17,
            fontWeight: FontWeight.w200,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );
    } else {
      SizedBox(
        height: 10,
      );
    }
  }
}
