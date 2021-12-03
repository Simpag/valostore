// @dart=2.9
import 'package:flutter/material.dart';
import 'package:valostore/api/valo_api.dart';
import 'package:valostore/screens/sign_in.dart';
import 'package:valostore/screens/store_page.dart';

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
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Valo Store',
      theme: ThemeData(
        primarySwatch: CustomMaterialColors.DarkerOrange,
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
