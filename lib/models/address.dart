class Address {
  int id;
  String postCode;
  String addressLine;
  Address({this.id, this.postCode, this.addressLine});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      postCode: json['postCode'],
      addressLine: json['address'],
    );
  }
}
