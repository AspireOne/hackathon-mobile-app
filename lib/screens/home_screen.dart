import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_app/objects/api.dart';
import 'package:hackathon_app/objects/prefs_object.dart';
import 'package:hackathon_app/screens/add_product_screen.dart';
import 'package:hackathon_app/screens/product_info_screen.dart';
import 'package:hackathon_app/widgets/DrawerMenu.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:vibration/vibration.dart';

import '../objects/user.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'homeScreen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Card>? recentProducts;
  bool loading = false;

  void _scanShoes() async {
    FlutterBarcodeScanner.scanBarcode("#ff6666", "Zrušit", true, ScanMode.QR)
        .then((result) {
          //Vibration.vibrate(duration: 100);
          if (result == "-1") return;
          PrefsObject.addRecentProduct(result);
          Navigator.pushNamed(context, ProductInfoScreen.routeName, arguments: result);
        });
  }

  void _addShoes() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    if (recentProducts == null) {
      initRecentProducts();
    }

    Widget body;

    if (loading) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (recentProducts == null || recentProducts!.isEmpty) {
      body = _buildEmptyText();
    } else {
      body = Column(
        children: recentProducts!
      );
    }

    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: const Text("Baťův skladový pomocník"),
      ),
      drawer: DrawerMenu(user: LoginScreen.user),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Naposledy přidané",
                // Make text bigger.
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            body
          ],
        ),
      ),
      floatingActionButton: Row(
        // Center row horizontally.
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 20),
          FloatingActionButton(
            heroTag: "scan",
            onPressed: _scanShoes,
            tooltip: 'Oskenovat boty',
            child: const Icon(Icons.qr_code),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            heroTag: "add",
            onPressed: _addShoes,
            tooltip: 'Zaevidovat boty',
            child: const Icon(Icons.add),
          ),
        ]
      ),
    );
  }

  Widget _buildEmptyText() {
    return const Center(
      child: Text(
          "Zde se zobrazí historie vašich produktů.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey,
          ),
      ),
    );
  }

  void initRecentProducts() async {
    recentProducts = [];
    recentProducts = await _buildProductHistoryList();
    setState(() {});
  }

  Future<List<Card>> _buildProductHistoryList() async {
    setState(() => loading = true);
    var recents = await PrefsObject.getRecentProducts();
    List<Card> cards = [];
    for (int i = 0; i < recents.length; i++) {
      Api.getProduct(recents[i]).then((response) {
        if (response.statusCode != 200) return;
        cards.add(
            Card(
              child: ListTile(
                title: Text(response.data!.name),
                subtitle: Text(response.data!.description),
                onTap: () {
                  Navigator.pushNamed(context, ProductInfoScreen.routeName, arguments: recents[i]);
                },
              ),
            )
        );
        if (i == recents.length - 1) {
          setState(() => loading = false);
        }
      });
    }
    return cards;
  }
}