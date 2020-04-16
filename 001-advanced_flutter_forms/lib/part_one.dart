import 'package:flutter/material.dart';

import 'models/payment.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fomrs'),
      ),
      body: PaymentForm(), // We'll add this in a bit
    );
  }
}

class PaymentForm extends StatefulWidget {
  PaymentForm({Key key}) : super(key: key);
  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  CardDetails _cardDetails = new CardDetails();
  String expiryMonth; // new line
  String expiryYear; // new line
  final List yearsList =
      List.generate(12, (int index) => index + 2020); // new line
  Address _paymentAddress = new Address();
  Map<String, bool> touched = {
    "cardNumberField": false,
  };
  final _cardNumberController = TextEditingController();
  bool rememberInfo = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              onSaved: (val) => _cardDetails.cardHolderName = val,
              decoration: InputDecoration(
                labelText: 'Name on card',
                icon: Icon(Icons.account_circle),
              ),
              validator: (value) {
                if (value.isEmpty) return "This form value must be filled";
                return null;
              },
            ),
            TextFormField(
              controller: _cardNumberController,
              onSaved: (val) => _cardDetails.cardNumber = val,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Card number',
                icon: Icon(Icons.credit_card),
              ),
              autovalidate: touched['cardNumberField'],
              validator: (value) {
                if (value.isEmpty) return "This form value must be filled";
                if (value.length != 16) return "Please enter a valid number";
                return null;
              },
              onChanged: (value) {
                setState(() {
                  touched['cardNumberField'] = true;
                });
              },
            ),
            TextFormField(
              onSaved: (val) => _cardDetails.securityCode = int.parse(val),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Security Code',
                icon: Icon(Icons.lock_outline),
              ),
              maxLength: 4,
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
                    value: val.toString(),
                  );
                },
              ).toList(),
              onChanged: (val) {
                setState(() {
                  expiryYear = val.toString();
                });
              },
              decoration: InputDecoration(
                labelText: 'Expiry Year',
                icon: Icon(Icons.calendar_today),
              ),
            ),
            TextFormField(
              onSaved: (val) => _paymentAddress.postCode = val,
              decoration: InputDecoration(
                  labelText: 'Post Code', icon: Icon(Icons.location_on)),
            ),
            TextFormField(
              onSaved: (val) => _paymentAddress.addressLine = val,
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
                print('Payment Complete');
              },
            ),
          ],
        ),
      ),
    );
  }
}
