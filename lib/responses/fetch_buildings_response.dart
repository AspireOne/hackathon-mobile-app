import 'package:hackathon_app/responses/action_response.dart';

class FetchBuldingsResponse extends ActionResponse {
  Data? data;

  // Crete constructor and pass parameters to superclass.
  FetchBuldingsResponse({
    required int statusCode,
    required String message,
    required Map<String, dynamic> originalJson,
    this.data,
  }) : super(message: message, statusCode: statusCode, originalJson: originalJson);

  static FetchBuldingsResponse fromJson(Map<String, dynamic> json) {
    return FetchBuldingsResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      originalJson: json,
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  List<Building> buildings = [];

  Data({required this.buildings,});

  static Data fromJson(Map<String, dynamic> json) {
    return Data(
      buildings: List<Building>.from(json['buildings'].map((x) => Building.fromJson(x))),
    );
  }
}

class Building {
  String id;
  String name;
  int state;
  double lat;
  double long;

  Building({
    required this.id,
    required this.name,
    required this.state,
    required this.lat,
    required this.long,
  });

  static Building fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['_id'],
      name: json['name'],
      state: json['state'],
      lat: json['lat'],
      long: json['long'],
    );
  }
}