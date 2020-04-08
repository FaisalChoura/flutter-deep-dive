class Payment {
  Address address;
  CardDetails cardDetails;
  Payment({this.address, this.cardDetails});
}

class CardDetails {
  String cardHolderName;
  String cardNumber;
  String expiryMonth;
  String expiryYear;
  int securityCode;
  CardDetails(
      {this.cardHolderName,
      this.cardNumber,
      this.expiryMonth,
      this.expiryYear,
      this.securityCode});
}

class Address {
  String postCode;
  String addressLine;
  Address({this.postCode, this.addressLine});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      postCode: json['postCode'],
      addressLine: json['address'],
    );
  }
}
