import 'package:flutter/material.dart';
import 'package:hackathon_app/screens/HomeScreen.dart';
import 'package:hackathon_app/screens/LoginScreen.dart';
import 'package:hackathon_app/screens/MenuScreen.dart';
import 'package:hackathon_app/screens/SettingsScreen.dart';
import 'package:hackathon_app/screens/product_info_screen.dart';

import 'objects/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final String name = "Baťa Warehouse Manager";
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: name,
      theme: ThemeData(
        primarySwatch: Constants.primaryColor,
      ),
      initialRoute: LoginScreen.routeName,
      routes: {
        // When navigating to the "homeScreen" route, build the HomeScreen widget.
        HomeScreen.routeName: (context) => HomeScreen(),
        LoginScreen.routeName: (context) => LoginScreen(title: name),
        MenuScreen.routeName: (context) => const MenuScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),
        ProductInfoScreen.routeName: (context) => const ProductInfoScreen(),
      },
      //title: 'Baťa Warehouse Manager'
    );
  }
}
