import 'package:flutter/material.dart';

class CustomColors {
  static const Blue = Color.fromARGB(255, 50, 57, 73);
  static const DarkerBlue = Color.fromARGB(255, 0, 129, 246);
  static const TextBlack = Color.fromRGBO(26, 26, 26, 1);
  static const BackgroundGrey = Color.fromARGB(255, 242, 244, 243);
  static const BorderGrey = Color.fromRGBO(228, 231, 241, 1);
  static const ErrorRed = Color.fromRGBO(245, 99, 88, 1);
  static const LightBlue = Color(0xff44a6ff);
  static const CheckboxGrey = Color.fromRGBO(196, 196, 196, 1);
  static const DeleteRed = Color.fromRGBO(237, 40, 40, 1);
}

class CustomGradients {
  static const BlueGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [CustomColors.DarkerBlue, Color.fromARGB(255, 50, 60, 80)],
  );

  static const RedGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [CustomColors.DeleteRed, CustomColors.ErrorRed],
  );

  static const AllWhiteGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Colors.white, Colors.white],
  );
}

class CustomMaterialColors {
  static const Map<int, Color> _blueColorCodes = {
    50: Color.fromRGBO(50, 57, 73, .1),
    100: Color.fromRGBO(50, 57, 73, .2),
    200: Color.fromRGBO(50, 57, 73, .3),
    300: Color.fromRGBO(50, 57, 73, .4),
    400: Color.fromRGBO(50, 57, 73, .5),
    500: Color.fromRGBO(50, 57, 73, .6),
    600: Color.fromRGBO(50, 57, 73, .7),
    700: Color.fromRGBO(50, 57, 73, .8),
    800: Color.fromRGBO(50, 57, 73, .9),
    900: Color.fromRGBO(50, 57, 73, 1),
  };
// Green color code: 0081f6
  static const MaterialColor Blue = MaterialColor(0xFF0081f6, _blueColorCodes);
}

class CustomUrls {
  static const String TermsAndConditions =
      "http://helpoapp.com/sekretesspolicy";
}

class CustomConstraints {
  static const double SideMargin = 20.0;
}

class CustomTextStyles {
  static const Disclaimer = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  static const Report = TextStyle(color: Colors.black, fontSize: 16);

  static const Body = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 15,
  );
  static const ThinBody = TextStyle(
    fontWeight: FontWeight.w200,
    fontSize: 15,
  );
  static const SemiBoldBody = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );
  static const BoldBody = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16,
  );
  static const Header = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18,
  );
  static const Title = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );
  static const ButtonText = TextStyle(
    color: Colors.white,
    fontSize: 17.0,
  );
  static const ButtonTextBlack = TextStyle(
    color: Colors.black,
    fontSize: 17.0,
  );
  static const AppBar = TextStyle(
    color: CustomColors.TextBlack,
    fontSize: 35,
    fontFamily: 'Lobster',
  );
}
