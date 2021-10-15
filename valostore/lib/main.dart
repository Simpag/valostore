import 'package:flutter/material.dart';
import 'package:valostore/api/valo_api.dart';

import 'api/api_models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String text = "";
  String username = "", password = "";
  Store myStore = Store(offers: [], timeLeft: 0);
  AccountData myAccount = AccountData(
    expiresIn: 0,
    headers: {},
    user_id: "",
  );
  Map<String, WeaponSkin> skinLookup = new Map<String, WeaponSkin>();

  Future<void> login() async {
    AccountData _myAccount = await ValoApi.auth(
      username,
      password,
    );
    Store _myStore = await ValoApi.getStore(
      _myAccount.headers,
      _myAccount.user_id,
      "EU",
    );
    skinLookup = await ValoApi.getSkinsLookupTable();

    setState(() {
      myStore = _myStore;
      myAccount = _myAccount;

      text = "Your skins are: \n";
      myStore.offers.forEach((element) {
        text += skinLookup[element]!.name + "\n";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ValoStore Demo UI"),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Username',
              ),
              onChanged: (value) => username = value,
            ),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
              ),
              onChanged: (value) => password = value,
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () => login(),
              child: Text("Login"),
            ),
            SizedBox(height: 25),
            Text(text),
          ],
        ),
      ),
    );
  }
}
