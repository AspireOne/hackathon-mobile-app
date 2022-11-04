// This will maybe be changed to something else.

class User {
  String? name;
  String? surname;
  String? email;

  User({this.name, this.surname, this.email});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    surname = json['surname'];
    email = json['email'];
  }

  // Returns the name + surname, or if one of them is null, returns the other one.
  // If both is null, returns null.
  String? getFullName() {
    String fullName = (name ?? "") + " " + (surname ?? "");
    return fullName.isEmpty ? null : fullName;
  }

  String? getInicials() {
    return (name?.substring(0, 1) ?? "") + (surname?.substring(0, 1) ?? "");
  }
}