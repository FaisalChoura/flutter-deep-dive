class Person {
  String name;
  String gender;

  Person({this.gender, this.name});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'] as String,
      gender: json['gender'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'gender': this.gender,
    };
  }
}
