import 'package:flutter/material.dart';
import 'package:hackathon_app/screens/add_product_screen.dart';
import 'package:hackathon_app/screens/home_screen.dart';
import 'package:hackathon_app/screens/login_screen.dart';
import 'package:hackathon_app/screens/menu_screen.dart';
import 'package:hackathon_app/screens/settings_screen.dart';
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
        AddProductScreen.routeName: (context) => const AddProductScreen(),
      },
      //title: 'Baťa Warehouse Manager'
    );
  }
}
