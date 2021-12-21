// @dart=2.9
import 'package:flutter/material.dart';

import 'package:valstore/api/valo_api.dart';
import 'package:valstore/screens/sign_in.dart';
import 'package:valstore/screens/store_page.dart';

import 'api/api_models.dart';
import 'constants.dart';

const SignInRoute = '/';
const StoreRoute = "/store";

void main() {
  runApp(MyApp());
}

AccountData myAccount = new AccountData(
  expiresIn: -1,
  headers: {},
  user_id: '',
  ssid_cookie: '',
);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ValStore',
      theme: ThemeData(
        primarySwatch: CustomMaterialColors.Blue,
      ),
      onGenerateRoute: _routes(),
    );
  }

  RouteFactory _routes() {
    return (settings) {
      //final Map<String, dynamic> arguments = settings.arguments;
      Widget screen;

      switch (settings.name) {
        case SignInRoute:
          screen = SignIn();
          break;
        case StoreRoute:
          screen = StorePage();
          break;
        default:
          return null;
      }

      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }
}
