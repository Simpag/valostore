import 'dart:convert';

class AccountData {
  String user_id;
  Map<String, String> headers;
  int expiresIn;

  AccountData({
    required this.user_id,
    required this.headers,
    required this.expiresIn,
  }) {
    if (headers == null) headers = new Map();
  }

  // Dont think this will be used
  factory AccountData.fromJson(Map<String, dynamic> json) {
    return AccountData(
      user_id: json['id'],
      headers: json['headers'] as Map<String, String>,
      expiresIn: int.parse(json['expiresIn']),
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
      name: json['displayName'],
      imageLink: json['displayIcon'],
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
