import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_app/screens/product_info_screen.dart';
import 'package:hackathon_app/widgets/DrawerMenu.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../objects/user.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'homeScreen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _scanShoes() async {
    FlutterBarcodeScanner.scanBarcode("#ff6666", "Zrušit", true, ScanMode.QR)
        .then((result) {
          if (result == "-1") return;
          Navigator.pushNamed(context, ProductInfoScreen.routeName, arguments: result);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: const Text("Baťa Warehouse Manager"),
      ),
      drawer: DrawerMenu(user: LoginScreen.user),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              "sometext",
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanShoes,
        tooltip: 'Oskenovat boty',
        child: const Icon(Icons.qr_code),
      ),
    );
  }
}