class User {
  int id;
  String userName;
  String fullName;
  User({this.id, this.userName, this.fullName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'], userName: json['username'], fullName: json['fullName']);
  }
}
