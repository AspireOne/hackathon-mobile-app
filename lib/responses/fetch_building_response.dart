import 'action_response.dart';

class FetchBuildingResponse extends ActionResponse {
  Data? data;

  // Crete constructor and pass parameters to superclass.
  FetchBuildingResponse({
    required int statusCode,
    required String message,
    required Map<String, dynamic> originalJson,
    this.data,
  }) : super(message: message, statusCode: statusCode, originalJson: originalJson);

  static FetchBuildingResponse fromJson(Map<String, dynamic> json) {
    return FetchBuildingResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      originalJson: json,
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  FetchedBuilding building;

  Data({
    required this.building
  });

  static Data fromJson(Map<String, dynamic> json) {
    return Data(
      building: FetchedBuilding.fromJson(json['building']),
    );
  }
}

class FetchedBuilding {
  String id;
  String name;
  int state;
  String address;
  List<Floor> floors;

  FetchedBuilding({
    required this.id,
    required this.name,
    required this.state,
    required this.address,
    required this.floors,
  });

  static FetchedBuilding fromJson(Map<String, dynamic> json) {
    return FetchedBuilding(
      id: json['_id'],
      name: json['name'],
      state: json['state'],
      address: json['address'],
      floors: List<Floor>.from(json['floors'].map((x) => Floor.fromJson(x))),
    );
  }
}

class Floor {
  String id;
  String type;
  FloorContent content;

  Floor({
    required this.id,
    required this.type,
    required this.content,
  });

  static Floor fromJson(Map<String, dynamic> json) {
    return Floor(
      id: json['_id'],
      type: json['type'],
      content: FloorContent.fromJson(json['warehouse'] ?? json['shop']),
    );
  }
}

class FloorContent {
  String id;
  String name;

  FloorContent({
    required this.id,
    required this.name,
  });

  static fromJson(Map<String, dynamic> json) {
    return FloorContent(
      id: json['_id'],
      name: json['name'],
    );
  }
}