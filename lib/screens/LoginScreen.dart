import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hackathon_app/responses/login_register_response.dart';

import '../objects/SharedPrefs.dart';
import '../objects/api.dart';
import '../objects/user.dart';
import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'loginScreen';
  static User? user;
  final String? title;

  const LoginScreen({this.title, Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool register = true;
  String? error = null;

  String? email;
  String? password;
  String? name;
  String? surname;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title ?? "Baťa Warehouse Manager"),
      ),
      // Create a login page.
      body: Container(
          decoration: _buildGradientDecoration(),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildContent()
          )
      ),
    );
  }

  Widget _buildContent() {
    return Column(
        children: [
          _buildSwitchButton(),
          const SizedBox(height: 20),
          _buildLoginElements(),
          const SizedBox(height: 20),
          // Create a red text.
          Text(
            error ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(
              //color: Colors.red,
              fontSize: 16,
            ),
          ),
        ]
    );
  }

  Widget _buildSwitchButton() {
    return Row(
      // Add border around the row.
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              error = null;
              register = false;
            });
          },
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(register ? Colors.black : Colors.red),
          ),
          child: const Text("Přihlásení"),
        ),
        // Add vertical divider.
        TextButton(
          onPressed: () {
            setState(() {
              error = null;
              register = true;
            });
          },
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(register ? Colors.red : Colors.black),
          ),
          child: const Text("Registrace"),
        ),
      ],
    );
  }

  BoxDecoration _buildGradientDecoration() {
    return const BoxDecoration(
      color: Colors.white,
    );
  }

  Widget _buildLoginElements() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          (register ? "Registrovat" : "Přihlásit"),
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 30),
        TextField(
          onChanged: (text) => email = text,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Uživatelský e-mail',
          ),
        ),
        const SizedBox(height: 5),
        !register
            ? Container()
            : Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (text) => name = text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Jméno',
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (text) => surname = text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Přijmení',
                      ),
                    ),
                  ),
                ],
              ),
        const SizedBox(height: 30),
        TextField(
          obscureText: true,
          onChanged: (text) {
            password = text;
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Heslo',
          ),
        ),
        const SizedBox(height: 80),
        register ? _buildRegisterButton() : _buildLoginButton()
      ],
    );
  }

  Widget _buildLoginButton() {
    return _buildSubmitButton("Přihlásit", () {
      if (email != null && password != null) {
        Api.login(email!, password!)
            .then((response) => handleLoginOrRegisterRequestResponse(response));
      } else {
        setState(() {
          error = "Nejdříve musíte vyplnit všechna pole.";
        });
      }
    });
  }

  Widget _buildRegisterButton() {
    return _buildSubmitButton("Registrovat", () {
      if (name != null && surname != null && email != null && password != null) {
        Api.register(email!, password!, name!, surname!)
            .then((response) => handleLoginOrRegisterRequestResponse(response));
      } else {
        setState(() {
          error = "Nejdříve musíte vyplnit všechna pole.";
        });
      }
    });
  }

  Widget _buildSubmitButton(String text, Function() onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(120, 50),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }

  void handleLoginOrRegisterRequestResponse(LoginRegisterResponse response) {
    print("Login or register request succesfuly made. Response: " + response.originalJson.toString());
    if (response.statusCode != 200 || response.data == null) {
      setState(() {
        error = response.message;
      });
      return;
    }
    PrefsObject.setToken(response.data!.token);
    LoginScreen.user = response.data!.user;
    Navigator.pushNamed(context, HomeScreen.routeName);
  }
}
