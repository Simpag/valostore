import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:valstore/api/api_models.dart';
import 'package:valstore/api/valo_api.dart';

import '../constants.dart';
import '../main.dart';
import 'general/store_item.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  List<Widget> storeItems = new List.filled(4, Container());
  Store myStore = Store(offers: [], timeLeft: 0);
  String timeLeft = "";
  Timer? timeLeftUpdater;

  Map<String, WeaponSkin> skinLookup = new Map<String, WeaponSkin>();

  void initState() {
    timeLeftUpdater =
        Timer.periodic(Duration(seconds: 1), (Timer t) => updateBanner());
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => getStore());
  }

  @override
  void dispose() {
    timeLeftUpdater?.cancel();
    super.dispose();
  }

  Future<bool> getStore() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => _buildLoadingPopup(context),
    );

    Store _myStore = await ValoApi.getStore(
      myAccount,
      "EU",
    );
    skinLookup = await ValoApi.getSkinsLookupTable();

    setState(() {
      myStore = _myStore;

      for (int i = 0; i < myStore.offers.length; i++) {
        WeaponSkin skin = skinLookup[myStore.offers[i]]!;
        storeItems[i] = StoreItem(name: skin.name, image_link: skin.imageLink);
      }
    });

    Navigator.of(context).pop(); // close the popup

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: CustomColors.Blue,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 80.0,
          bottom: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    signOutButton(),
                    SizedBox(width: 10.0),
                    offersBanner(),
                    SizedBox(width: 10.0),
                    refreshButton(),
                  ],
                )
              ] +
              storeItems,
        ),
      ),
    );
  }

  Widget signOutButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        boxShadow: [
          BoxShadow(
            offset: Offset(0.00, 10.00),
            color: CustomColors.Blue,
            blurRadius: 10,
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      height: MediaQuery.of(context).size.longestSide * 0.05,
      width: MediaQuery.of(context).size.longestSide * 0.05,
      child: IconButton(
        icon: Icon(Icons.arrow_back_ios_new),
        alignment: Alignment.center,
        padding: EdgeInsets.zero,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        color: Colors.white.withOpacity(0.7),
        onPressed: () => _signOut(),
      ),
    );
  }

  Widget settingsButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        boxShadow: [
          BoxShadow(
            offset: Offset(0.00, 10.00),
            color: CustomColors.Blue,
            blurRadius: 10,
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      height: MediaQuery.of(context).size.longestSide * 0.05,
      width: MediaQuery.of(context).size.longestSide * 0.05,
      child: IconButton(
        icon: Icon(Icons.list_alt),
        alignment: Alignment.center,
        padding: EdgeInsets.zero,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        color: Colors.white.withOpacity(0.7),
        onPressed: () => HapticFeedback.heavyImpact(),
      ),
    );
  }

  Widget refreshButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        boxShadow: [
          BoxShadow(
            offset: Offset(0.00, 10.00),
            color: CustomColors.Blue,
            blurRadius: 10,
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      height: MediaQuery.of(context).size.longestSide * 0.05,
      width: MediaQuery.of(context).size.longestSide * 0.05,
      child: IconButton(
        icon: Icon(Icons.refresh),
        alignment: Alignment.center,
        padding: EdgeInsets.zero,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        color: Colors.white.withOpacity(0.7),
        onPressed: () {
          HapticFeedback.mediumImpact();
          getStore();
        },
      ),
    );
  }

  Widget offersBanner() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        boxShadow: [
          BoxShadow(
            offset: Offset(0.00, 10.00),
            color: CustomColors.Blue,
            blurRadius: 10,
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      height: MediaQuery.of(context).size.longestSide * 0.05,
      width: MediaQuery.of(context).size.shortestSide * 0.55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text(
              "OFFERS",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            height: 20.0,
            child: VerticalDivider(
              color: Colors.white.withOpacity(0.7),
              thickness: 1,
              endIndent: 0,
              width: 20,
            ),
          ),
          Container(
            child: Text(
              timeLeft,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.amber,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingPopup(BuildContext context) {
    return new AlertDialog(
      backgroundColor: CustomColors.Blue.withOpacity(0.5),
      contentPadding: EdgeInsets.all(70),
      content: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          child: CircularProgressIndicator(
            color: CustomColors.BorderGrey.withOpacity(0.75),
            strokeWidth: 10.0,
          ),
        ),
      ),
    );
  }

  void updateBanner() {
    setState(() {
      myStore.timeLeft -= 1;
      timeLeft = "${intToTimeLeft(myStore.timeLeft)}";
    });
  }

  String intToTimeLeft(int value) {
    int h, m, s;

    h = value ~/ 3600;

    m = ((value - h * 3600)) ~/ 60;

    s = value - (h * 3600) - (m * 60);

    String hourLeft =
        h.toString().length < 2 ? "0" + h.toString() : h.toString();

    String minuteLeft =
        m.toString().length < 2 ? "0" + m.toString() : m.toString();

    String secondsLeft =
        s.toString().length < 2 ? "0" + s.toString() : s.toString();

    String result = "$hourLeft:$minuteLeft:$secondsLeft";

    return result;
  }

  Future<void> _signOut() async {
    HapticFeedback.mediumImpact();
    //SharedPreferences preferences = await SharedPreferences.getInstance();
    //await preferences.clear();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, SignInRoute);
  }
}
