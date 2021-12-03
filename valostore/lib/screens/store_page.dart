import 'package:flutter/material.dart';
import 'package:valostore/api/api_models.dart';
import 'package:valostore/api/valo_api.dart';

import '../main.dart';
import 'general/store_item.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  List<Widget> storeItems = new List.filled(8, Container());
  Store myStore = Store(offers: [], timeLeft: 0);

  Map<String, WeaponSkin> skinLookup = new Map<String, WeaponSkin>();

  void initState() {
    getStore();
    super.initState();
  }

  Future<bool> getStore() async {
    Store _myStore = await ValoApi.getStore(
      myAccount.headers,
      myAccount.user_id,
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

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ValoStore Demo UI"),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.deepOrange,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: storeItems,
        ),
      ),
    );
  }
}
