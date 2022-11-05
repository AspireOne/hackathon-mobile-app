import 'package:flutter/material.dart';
import 'package:hackathon_app/objects/prefs_object.dart';
import 'package:hackathon_app/objects/constant_storage_keys.dart';
import 'package:hackathon_app/objects/user.dart';
import 'package:hackathon_app/screens/home_screen.dart';
import 'package:hackathon_app/screens/login_screen.dart';
import 'package:hackathon_app/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../objects/constants.dart';

class DrawerMenu extends StatefulWidget {
  final User? user;

  const DrawerMenu({Key? key, this.user}) : super(key: key);

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  Widget _buildAvatar(String? inicials) {
    Widget avatar;

    if (inicials == null) {
      avatar = const Icon(
        Icons.person,
        size: 50.0,
        color: Constants.primaryColor,
      );
    } else {
      avatar = Text(
        inicials,
        style: const TextStyle(
          fontSize: 50.0,
          color: Colors.white,
        ),
      );
    }

    return CircleAvatar(
        backgroundColor: Colors.deepPurple,
        radius: 40.0,
        child: avatar
    );
  }

  Widget _buildUserInfoText() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        text: widget.user == null ? "Nepřihlášen" : 'Přihlášen jako: ', // TODO: User name
        children: <TextSpan>[
          TextSpan(
            text: widget?.user?.getFullName() ?? "",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return a Drawer widget.
    return Drawer(
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Create a drawer header with account information and background image.
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(60, 60, 60, 1),
            ),
            child: Column(
              children: <Widget>[
                // Generate user avatar based on user name and surname.
                _buildAvatar(widget.user?.getInicials()),
                const SizedBox(height: 20),
                _buildUserInfoText(),
              ],
            ),
          ),
          ListTile(
            title: const Text('Domů'),
            onTap: () {
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
          ),
/*          ListTile(
            title: const Text('Nastavení'),
            onTap: () {
              Navigator.pushNamed(context, SettingsScreen.routeName);
            },
          ),*/
          ListTile(
            title: const Text('Odhlásit'),
            onTap: () async {
              PrefsObject.setToken(null);
              Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
