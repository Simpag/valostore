import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AccountData {
  String user_id;
  String ssid_cookie;
  Map<String, dynamic> headers;
  int expiresIn;
  bool loadedLocally = false;
  bool rememberMe = false;

  AccountData({
    required this.user_id,
    required this.headers,
    required this.expiresIn,
    required this.ssid_cookie,
  }) {
    // ignore: unnecessary_null_comparison
    if (headers == null) headers = new Map();
  }

  Future<bool> saveLocally() async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();

    // set value and return true if all complete
    return await prefs.setString('user_id', this.user_id) &&
        await prefs.setString('headers', jsonEncode(this.headers)) &&
        await prefs.setInt("expires_in", this.expiresIn) &&
        await prefs.setString('ssid_cookie', this.ssid_cookie) &&
        await prefs.setBool("rememberMe", this.rememberMe);
  }

  Future<bool> loadLocally() async {
    if (loadedLocally) return true;

    final prefs = await SharedPreferences.getInstance();

    // Try reading data from the counter key. If it doesn't exist, return defualt value.
    this.user_id = prefs.getString('user_id') ?? "";
    this.expiresIn = prefs.getInt('expires_in') ?? -1;
    this.ssid_cookie = prefs.getString('ssid_cookie') ?? "";
    this.rememberMe = prefs.getBool("rememberMe") ?? false;

    String? json = prefs.getString("headers");
    if (json != null && json != "") {
      this.headers = jsonDecode(json);
    } else {
      this.headers = new Map();
    }

    loadedLocally = true;
    print("Loaded!");
    return true;
  }

  // Might not be used...
  factory AccountData.fromJson(Map<String, dynamic> json) {
    return AccountData(
      user_id: json['id'],
      headers: json['headers'] as Map<String, String>,
      expiresIn: int.parse(json['expiresIn']),
      ssid_cookie: json['ssid_cookie'],
    );
  }
}

class WeaponSkin {
  String id;
  String name;
  String imageLink;

  WeaponSkin({
    required this.id,
    required this.name,
    required this.imageLink,
  }) {}

  // Dont think this will be used
  factory WeaponSkin.fromJson(Map<String, dynamic> json) {
    return WeaponSkin(
      id: json['levels'][0]['uuid'],
      name: json['levels'][0]['displayName'],
      imageLink: json['levels'][0]['displayIcon'],
    );
  }
}

class Store {
  int timeLeft;
  List<dynamic> offers;

  Store({
    required this.timeLeft,
    required this.offers,
  }) {}

  // Dont think this will be used
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      timeLeft: json['SingleItemOffersRemainingDurationInSeconds'],
      offers: json['SingleItemOffers'],
    );
  }
}
