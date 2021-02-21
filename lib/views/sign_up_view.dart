import 'package:auth_buttons/auth_buttons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:travel_budget/services/auth_services.dart';
import 'package:travel_budget/widgets/provider_widget.dart';

final primaryColor = const Color(0xFF75A2EA);

enum AuthFormType { signIn, signUp, reset, anonymous, convert }

class SignUpView extends StatefulWidget {
  final AuthFormType authFormType;

  SignUpView({Key key, this.authFormType}) : super(key: key);

  @override
  _SignUpViewState createState() =>
      _SignUpViewState(authFormType: this.authFormType);
}

class _SignUpViewState extends State<SignUpView> {
  AuthFormType authFormType;

  _SignUpViewState({this.authFormType});

  final formKey = GlobalKey<FormState>();

  String _email, _password, _name, _warning;

  void switchFormState(String state) {
    formKey.currentState.reset();
    if (state == "signUp") {
      setState(() {
        authFormType = AuthFormType.signUp;
      });
    } else if (state == "home") {
      Navigator.of(context).pop();
    } else {
      setState(() {
        authFormType = AuthFormType.signIn;
      });
    }
  }

  bool validate() {
    if (authFormType == AuthFormType.anonymous) {
      return true;
    }
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;

        switch (authFormType) {
          case AuthFormType.signIn:
            await auth.signInWithEmailAndPassword(_email, _password);
            Navigator.of(context).pushReplacementNamed('/home');
            break;
          case AuthFormType.signUp:
            await auth.createUserEmailandPassword(_email, _password, _name);
            Navigator.of(context).pushReplacementNamed('/home');
            break;
          case AuthFormType.reset:
            await auth.sendPasswordResetEmail(_email);

            _warning = "A password reset link has been sent to $_email";
            setState(() {
              authFormType = AuthFormType.signIn;
            });
            break;
          case AuthFormType.anonymous:
            await auth.signInAnonymously();
            Navigator.of(context).pushReplacementNamed('/home');
            break;
          case AuthFormType.convert:
            await auth.convertUserWithEmail(_email, _password, _name);
            Navigator.pop(context);
            break;
        }
      } catch (e) {
        setState(() {
          _warning = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    if (authFormType == AuthFormType.anonymous) {
      submit();
      return Scaffold(
        backgroundColor: primaryColor,
        body: Column(
          children: [
            SpinKitDoubleBounce(
              color: Colors.white,
            ),
            Text(
              "Loading",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          color: primaryColor,
          height: height,
          width: width,
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.025,
                ),
                showAlert(),
                SizedBox(
                  height: height * 0.025,
                ),
                buildHeaderText(),
                SizedBox(
                  height: height * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: buildInputs() + buildButtons(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  AutoSizeText buildHeaderText() {
    String _headerText;
    if (authFormType == AuthFormType.signIn) {
      _headerText = "Sign In";
    } else if (authFormType == AuthFormType.reset) {
      _headerText = "Reset Password";
    } else {
      _headerText = "Create New Account";
    }
    return AutoSizeText(
      _headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 30, color: Colors.white),
    );
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    if (authFormType == AuthFormType.reset) {
      textFields.add(
        TextFormField(
          style: TextStyle(
            fontSize: 22,
          ),
          decoration: buildSignUpInputDecoration("Email"),
          validator: EmailValidator.validate,
          onSaved: (value) {
            _email = value;
          },
        ),
      );
      textFields.add(SizedBox(
        height: 20,
      ));
      return textFields;
    }

    //if were in the signup state add name
    if ([AuthFormType.signUp, AuthFormType.convert].contains(authFormType)) {
      textFields.add(
        TextFormField(
          style: TextStyle(
            fontSize: 22,
          ),
          decoration: buildSignUpInputDecoration("Name"),
          validator: NameValidator.validate,
          onSaved: (value) {
            _name = value;
          },
        ),
      );
      textFields.add(
        SizedBox(
          height: 20,
        ),
      );
    }

    //add email & password
    textFields.add(
      TextFormField(
        style: TextStyle(
          fontSize: 22,
        ),
        decoration: buildSignUpInputDecoration("Email"),
        validator: EmailValidator.validate,
        onSaved: (value) {
          _email = value;
        },
      ),
    );
    textFields.add(
      SizedBox(
        height: 20,
      ),
    );

    textFields.add(TextFormField(
      style: TextStyle(
        fontSize: 22,
      ),
      obscureText: true,
      decoration: buildSignUpInputDecoration("Password"),
      validator: PasswordValidator.validate,
      onSaved: (value) {
        _password = value;
      },
    ));

    return textFields;
  }

  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 0.0)),
      contentPadding: const EdgeInsets.only(left: 14, bottom: 10, top: 10),
    );
  }

  List<Widget> buildButtons() {
    String _switchButtonText, _newFormState, _submitButtonText;
    bool _showForgotPassword = false;
    bool _showSocial = true;
    if (authFormType == AuthFormType.signIn) {
      _switchButtonText = "Create New Account";
      _newFormState = "SignUp";
      _submitButtonText = "Sign In";
      _showForgotPassword = true;
    } else if (authFormType == AuthFormType.reset) {
      _switchButtonText = "Return to Sign In";
      _newFormState = "SignIn";
      _submitButtonText = "Submit";
      _showSocial = false;
    } else if (authFormType == AuthFormType.convert) {
      _switchButtonText = "Cancel";
      _newFormState = "home";
      _submitButtonText = "Sign Up";
    } else {
      _switchButtonText = "Have an Account? Sign In";
      _newFormState = "SignIn";
      _submitButtonText = "Sign Up";
    }

    return [
      SizedBox(
        height: 20,
      ),
      Container(
        width: MediaQuery.of(context).size.height * 0.7,
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              _submitButtonText,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: primaryColor),
            ),
          ),
          onPressed: () {
            submit();
          },
        ),
      ),
      showForgotPassword(_showForgotPassword),
      FlatButton(
          onPressed: () {
            setState(() {
              switchFormState(_newFormState);
            });
          },
          child: Text(
            _switchButtonText,
            style: TextStyle(color: Colors.white),
          )),
      buildSocialIcons(_showSocial),
    ];
  }

  Widget showAlert() {
    if (_warning != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                _warning,
                maxLines: 3,
              ),
            ),
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _warning = null;
                  });
                })
          ],
        ),
      );
    }

    return SizedBox(
      height: 0,
    );
  }

  Widget showForgotPassword(bool visible) {
    return Visibility(
      visible: visible,
      child: FlatButton(
          onPressed: () {
            setState(() {
              authFormType = AuthFormType.reset;
            });
          },
          child: Text(
            "Forgot Password ?",
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Widget buildSocialIcons(bool visible) {
    final _auth = Provider.of(context).auth;
    return Visibility(
      visible: visible,
      child: Column(
        children: [
          Divider(color: Colors.white),
          SizedBox(height: 10),
          GoogleAuthButton(
            onPressed: () async {
              try {
                if (authFormType == AuthFormType.convert) {
                  await _auth.convertWithGoogle();
                  Navigator.pop(context);
                } else {
                  await _auth.sinInWithGoogle();
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              } catch (e) {
                setState(() {
                  _warning = e.message;
                });
              }
            },
            darkMode: false,
          )
        ],
      ),
    );
  }
}
