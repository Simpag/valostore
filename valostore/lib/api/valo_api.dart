import 'dart:convert';
import 'package:requests/requests.dart';
import 'package:valostore/api/api_models.dart';

class ValoApi {
  static Future<AccountData> auth(String username, String password) async {
      // Prepare cookies for auth request
      //Map<String, String> headers = {"Content-type": "application/json"};
      
      Map<String, dynamic> data = {
        'client_id': 'play-valorant-web-prod',
        'nonce': '1',
        'redirect_uri': 'https://playvalorant.com/opt_in',
        'response_type': 'token id_token',
      };
      var response1 = await Requests.post("https://auth.riotgames.com/api/v1/authorization", json: data);
      response1.throwForStatus();
      print(response1.json());

      // Perform authorization request to get token
      data = {
        'type': 'auth',
        'username': username,
        'password': password,
        'remember': true,
      };
      var response2 = await Requests.put("https://auth.riotgames.com/api/v1/authorization", json: data);
      response2.throwForStatus();

      Map<String, dynamic> json = response2.json();
      print(json);
      // Find access token and a few other tokens
      RegExp regExp = new RegExp("access_token=((?:[a-zA-Z]|\d|\.|-|_)*).*id_token=((?:[a-zA-Z]|\d|\.|-|_)*).*expires_in=(\d*)");
      dynamic tokens = regExp.allMatches(json['response']['parameters']['uri']);
      String access_token = tokens[0];
      dynamic expires_in = tokens[2];

      // Get entitlement token
      Map<String, String> headers = {"Authorization": "Bearer $access_token"};
      var response3 = await Requests.post("https://entitlements.auth.riotgames.com/api/token/v1", headers: headers, json: {});
      response3.throwForStatus();
      json = response3.json();
      String entitlements_token = json['entitlements_token'];

      // Get user id
      var response4 = await Requests.post('https://auth.riotgames.com/userinfo', headers: headers, json: {});
      response4.throwForStatus();
      json = response4.json();
      int user_id = json['sub'];

      headers['X-Riot-Entitlements-JWT'] = entitlements_token;
      headers['Content-Type'] = 'application/json';

    return AccountData(user_id: user_id, headers: headers, expiresIn: expires_in);
  }
}