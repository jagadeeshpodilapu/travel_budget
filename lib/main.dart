import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:travel_budget/services/auth_services.dart';
import 'package:travel_budget/views/first_view.dart';
import 'package:travel_budget/views/sign_up_view.dart';
import 'package:travel_budget/widgets/provider_widget.dart';

import 'views/navigation_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Travel Budget App",
        theme: ThemeData(primarySwatch: Colors.green),
        //  home: Home(),
        home: HomeController(),
        routes: <String, WidgetBuilder>{
          '/home': (context) => HomeController(),
          '/signUp': (context) => SignUpView(
                authFormType: AuthFormType.signUp,
              ),
          '/signIn': (context) => SignUpView(
                authFormType: AuthFormType.signIn,
              ),
          '/anonymoussignIn': (context) => SignUpView(
                authFormType: AuthFormType.anonymous,
              ),
          '/convertUser': (context) => SignUpView(
                authFormType: AuthFormType.convert,
              ),
        },
      ),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;

    return StreamBuilder(
        stream: auth.onAuthStateChanged,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final bool signedIn = snapshot.hasData;
            return signedIn ? Home() : FirstView();
          }
          return CircularProgressIndicator();
        });
  }
}
