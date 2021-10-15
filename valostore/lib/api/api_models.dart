import 'dart:convert';

class AccountData {
  int user_id;
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
      user_id: int.parse(json['id'].toString()),
      headers: json['headers'] as Map<String, String>,
      expiresIn: int.parse(json['expiresIn']),
    );
  }
}