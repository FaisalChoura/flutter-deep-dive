import 'dart:convert';

import 'package:deep_dive/models/models.dart';
import 'package:deep_dive/models/payment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class FormsMini extends StatelessWidget {
  const FormsMini({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fomrs'),
      ),
      body: CustomForm(),
    );
  }
}

/// Form widgets are stateful widgets

class CustomForm extends StatefulWidget {
  CustomForm({Key key}) : super(key: key);

  @override
  _CustomFormState createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  Map<String, bool> validateField = {
    "cardField": false,
    "postCodeField": false
  };
  String expiryMonth;
  int expiryYear;
  bool rememberInfo = false;
  Address _paymentAddress = new Address();
  CardDetails _cardDetails = new CardDetails();

  final _formKey = GlobalKey<FormState>();
  final _addressLineController = TextEditingController();
  final List yearsList = List.generate(12, (int index) => index + 2020);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Text('Payment Info'),
            TextFormField(
              onSaved: (val) => _cardDetails.cardHolderName = val,
              decoration: InputDecoration(
                  labelText: 'Name on card', icon: Icon(Icons.account_circle)),
            ),
            TextFormField(
              onSaved: (val) => _cardDetails.cardNumber = val,
              autovalidate: validateField['cardField'],
              onChanged: (value) {
                setState(() {
                  validateField['cardField'] = true;
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Card number', icon: Icon(Icons.credit_card)),
              validator: (value) {
                if (value.length != 16) return "Please enter a valid number";
              },
            ),
            TextFormField(
              onSaved: (val) => _cardDetails.securityCode = int.parse(val),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Security Code', icon: Icon(Icons.credit_card)),
            ),
            DropdownButtonFormField<String>(
              onSaved: (val) => _cardDetails.expiryMonth = val,
              value: expiryMonth,
              items: [
                'Jan',
                'Feb',
                'Mar',
                'Apr',
                'May',
                'Jun',
                'Jul',
                'Aug',
                'Sep',
                'Oct',
                'Nov',
                'Dec'
              ].map<DropdownMenuItem<String>>(
                (String val) {
                  return DropdownMenuItem(
                    child: Text(val),
                    value: val,
                  );
                },
              ).toList(),
              onChanged: (val) {
                setState(() {
                  expiryMonth = val;
                });
              },
              decoration: InputDecoration(
                labelText: 'Expiry Month',
                icon: Icon(Icons.calendar_today),
              ),
            ),
            DropdownButtonFormField(
              onSaved: (val) => _cardDetails.expiryYear = val.toString(),
              value: expiryYear,
              items: yearsList.map<DropdownMenuItem>(
                (val) {
                  return DropdownMenuItem(
                    child: Text(val.toString()),
                    value: val,
                  );
                },
              ).toList(),
              onChanged: (val) {
                setState(() {
                  expiryYear = val;
                });
              },
              decoration: InputDecoration(
                labelText: 'Expiry Year',
                icon: Icon(Icons.calendar_today),
              ),
            ),
            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  labelText: 'Post Code',
                  icon: Icon(Icons.location_on),
                ),
              ),
              suggestionsCallback: (pattern) async {
                return await _fetchAddress(pattern);
              },
              itemBuilder: (context, Address address) {
                return ListTile(
                  leading: Icon(Icons.location_city),
                  title: Text(address.addressLine),
                  subtitle: Text(address.postCode),
                );
              },
              onSuggestionSelected: (Address address) {
                _addressLineController.text = address.addressLine;
              },
              onSaved: (val) => this._paymentAddress.postCode = val,
            ),
            TextFormField(
              onSaved: (val) => _paymentAddress.addressLine = val,
              controller: _addressLineController,
              decoration: InputDecoration(
                  labelText: 'Address Line', icon: Icon(Icons.location_city)),
            ),
            CheckboxListTile(
              value: rememberInfo,
              onChanged: (val) {
                setState(() {
                  rememberInfo = val;
                });
              },
              title: Text('Remember Information'),
            ),
            RaisedButton(
              child: Text('Process Payment'),
              color: Colors.pinkAccent,
              textColor: Colors.white,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  Payment payment = new Payment(
                      address: _paymentAddress, cardDetails: _cardDetails);
                  print('Saved');
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<List<Address>> _fetchAddress(String postCode) async {
    final response = await http.get(
        "https://my-json-server.typicode.com/refactord/deep-dive-db/addresses");
    if (response.statusCode == 200) {
      return _searchAddresses(response, postCode);
    } else {
      throw Exception('Failed to load addresses');
    }
  }

  ///This should be done on the server side but due to the use of a basic custom JSON server
  /// I'll manually do the search here
  List<Address> _searchAddresses(Response response, String postCode) {
    Map<String, dynamic> body = json.decode(response.body);
    var addresses = body[postCode];
    if (addresses != null) {
      addresses = (addresses as List).map((a) => Address.fromJson(a)).toList();
      return addresses;
    }
    return null;
  }
}
