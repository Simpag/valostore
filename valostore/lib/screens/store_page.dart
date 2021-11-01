import 'package:flutter/material.dart';
import 'package:valostore/api/api_models.dart';
import 'package:valostore/api/valo_api.dart';

import '../main.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  String text = "";
  String username = "", password = "";
  Store myStore = Store(offers: [], timeLeft: 0);

  Map<String, WeaponSkin> skinLookup = new Map<String, WeaponSkin>();

  Future<bool> getStore() async {
    Store _myStore = await ValoApi.getStore(
      myAccount.headers,
      myAccount.user_id,
      "EU",
    );
    skinLookup = await ValoApi.getSkinsLookupTable();

    setState(() {
      myStore = _myStore;

      text = "Your skins are: \n";
      myStore.offers.forEach((element) {
        text += skinLookup[element]!.name + "\n";
      });
    });

    return true;
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
              onPressed: () => getStore(),
              child: Text("Get Store"),
            ),
            SizedBox(height: 25),
            Text(text),
          ],
        ),
      ),
    );
  }
}
