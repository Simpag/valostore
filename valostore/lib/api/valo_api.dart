import 'dart:convert';
import 'package:valostore/api/api_models.dart';
import 'package:http/http.dart' as http;
import 'package:valostore/api/cookie_handler.dart';

class ValoApi {
  static Future<AccountData> auth(String username, String password) async {
    var client = http.Client();
    var cookies = cki();

    // Prepare cookies for auth request
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, dynamic> data = {
      'client_id': 'play-valorant-web-prod',
      'nonce': '1',
      'redirect_uri': 'https://playvalorant.com/opt_in',
      'response_type': 'token id_token',
    };
    String json = jsonEncode(data);
    http.Response response = await client.post(
      Uri.parse("https://auth.riotgames.com/api/v1/authorization"),
      headers: headers,
      body: json,
    );

    if (response.statusCode != 200) {
      throw Exception("Could not authenticate");
    }
    cookies.updateCookies(response); // Store the auth cookie
    headers = cookies.headers;

    // Perform authorization request to get token
    data = {
      'type': 'auth',
      'username': username,
      'password': password,
      'remember': true,
    };
    json = jsonEncode(data);
    response = await client.put(
      Uri.parse("https://auth.riotgames.com/api/v1/authorization"),
      headers: headers,
      body: json,
    );

    if (response.statusCode != 200) {
      throw Exception("Could not authenticate");
    }
    Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
    // Find access token and a few other tokens
    RegExp regExpAccess =
        new RegExp("access_token=(?:[a-zA-Z]|[0-9]|\\.|-|_)+");
    RegExp regExpExpire = new RegExp("expires_in=([0-9]*)");
    String access_token = regExpAccess
        .stringMatch(body['response']['parameters']['uri'])!
        .substring(13);
    int expires_in = int.parse(regExpExpire
        .stringMatch(body['response']['parameters']['uri'])!
        .substring(11));

    // Get entitlement token
    headers['Authorization'] = "Bearer $access_token";
    response = await client.post(
      Uri.parse("https://entitlements.auth.riotgames.com/api/token/v1"),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception("Could not authenticate");
    }
    body = jsonDecode(utf8.decode(response.bodyBytes));
    String entitlements_token = body['entitlements_token'];

    // Get user id
    response = await client.post(
      Uri.parse("https://auth.riotgames.com/userinfo"),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception("Could not authenticate");
    }
    body = jsonDecode(utf8.decode(response.bodyBytes));
    String user_id = body['sub'];

    headers['X-Riot-Entitlements-JWT'] = entitlements_token;
    headers['Content-Type'] = 'application/json';

    client.close();
    print("Authenticated!");
    return AccountData(
        user_id: user_id, headers: headers, expiresIn: expires_in);
  }

  static Future<Map<String, WeaponSkin>> getSkinsLookupTable() async {
    var client = http.Client();
    http.Response response = await client.get(
      Uri.parse("https://valorant-api.com/v1/weapons/skins"),
    );

    if (response.statusCode != 200) {
      throw Exception("Could not authenticate");
    }
    List<dynamic> json = jsonDecode(utf8.decode(response.bodyBytes))['data'];

    Map<String, WeaponSkin> lookupTable = new Map<String, WeaponSkin>();
    WeaponSkin temp;
    json.forEach((element) {
      temp = WeaponSkin.fromJson(element);
      lookupTable[temp.id] = temp;
    });

    client.close();
    return lookupTable;
  }

  static Future<Store> getStore(
    Map<String, String> headers,
    String user_id,
    String region,
  ) async {
    var client = http.Client();
    http.Response response = await client.get(
      Uri.parse("https://pd.$region.a.pvp.net/store/v2/storefront/$user_id"),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception("Could not authenticate");
    }
    Map<String, dynamic> json =
        jsonDecode(utf8.decode(response.bodyBytes))['SkinsPanelLayout'];
    Store store = new Store.fromJson(json);

    client.close();
    return store;
  }
}
