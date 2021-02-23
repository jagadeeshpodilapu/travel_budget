import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:travel_budget/widgets/custom_dialog.dart';

final primaryColor = const Color(0xFF75A2EA);

class FirstView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: _width,
        height: _height,
        color: primaryColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: _height * 0.10,
                ),
                Text(
                  "WELCOME",
                  style: TextStyle(color: Colors.white, fontSize: 35),
                ),
                SizedBox(
                  height: _height * 0.10,
                ),
                AutoSizeText(
                  "Let's start planning your next trip ",
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                SizedBox(
                  height: _height * 0.10,
                ),
                RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 30, right: 30),
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomDialog(
                              title: "Would you like to create account",
                              description:
                                  'with an account your data will be securely saved',
                              primaryButtonText: "Create Account",
                              primaryButtonRoute: "/signUp",
                              secondaryButtonText: "Maybe Later",
                              secondaryRoute: "/anonymoussignIn",
                            ));
                  },
                ),
                SizedBox(
                  height: _height * 0.05,
                ),
                FlatButton(
                    onPressed: () =>
                        Navigator.of(context).pushReplacementNamed("/signIn"),
                    child: Text(
                      "Sign In",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
