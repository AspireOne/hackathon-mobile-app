import 'dart:convert';

import 'package:hackathon_app/objects/user.dart';
import 'package:hackathon_app/responses/login_register_response.dart';
import 'package:http/http.dart' as http;

import '../responses/change_variant_count_response.dart';
import '../responses/get_product_response.dart';

class Api {
  static const String url = "https://hackathon-backend.up.railway.app/api";
  static const String loginUrl = "$url/employee/login";
  static const String tokenLoginUrl = "$url/employee/@me";
  static const String registerUrl = "$url/employee/register";
  static const String getProductUrl = "$url/product/fetch/";
  static const String changeProductCountUrl = "$url/product/changeVariantCount";

  static Future<LoginRegisterResponse> register(String email, String password, String name, String surname) async {
    var response = await http.post(
      Uri.parse(registerUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'name': name,
        'surname': surname,
      }),
    );
    return LoginRegisterResponse.fromJson(jsonDecode(response.body));
  }

  static Future<ChangeVariantCountResponse> changeProductVariantCount(String id, String token, int newCount) async {
    var response = await http.post(
      Uri.parse(changeProductCountUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
      body: jsonEncode(<String, dynamic>{
        "variantId": id,
        "count": newCount,
      }),
    );

    return ChangeVariantCountResponse.fromJson(jsonDecode(response.body));
  }

  static Future<GetProductResponse> getProduct(String id) async {
    var response = await http.get(
      Uri.parse(getProductUrl + id),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return GetProductResponse.fromJson(jsonDecode(response.body));
  }

  static Future<LoginRegisterResponse> loginWithToken(String token) async {
    var response = await http.get(
      Uri.parse(tokenLoginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "authorization": "$token"
      },
    );

    print(response.body);
    jsonDecode(response.body);
    return LoginRegisterResponse.fromJson(jsonDecode(response.body));
  }

  static Future<LoginRegisterResponse> login(String email, String password) async {
    var response = await http.post(
      Uri.parse(loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    return LoginRegisterResponse.fromJson(jsonDecode(response.body));
  }
}