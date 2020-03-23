# Flutter Forms Guide

In this tutorial we will go through how to build advanced reactive forms in Flutter (Material). Here is a list of what we're going to do:
- Text fields with different input types (Text, numbers, etc..) (Part 1)
- Drop downs and check boxes (Part 1)
- Local and server validations (Part 1)
- Type heads for local and server auto completing. (Part 2)
- Automatic text field population (Part 2)
- Loading indeicators and snack bars once the form is submited. (Part 2)

We'll start small and build up on that. I do not want to repeat what's on the documentation I will explain anything needed for the tutorial here but if you need to look more into something the [docs](https://api.flutter.dev/) are an incredible source.

Here is what you should have by the end of this tutorial:

(INSERT GIF HERE)

## Getting things ready
I'll assume you already have a flutter project created and want to add this as a widget. I like to put all my screen widgets in a folder called screens.

Let' create our form file in `lib\screens\payment_form.dart`. Let's add a Scaffold with an app bar

```dart
import 'package:flutter/material.dart';

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
```

Most if not all reactive forms in flutter require some kind of state to be maintained. This means that we need to create the form inside a __StatefulWidget__. 
```dart
class PaymentForm extends StatefulWidget {
  PaymentForm({Key key}) : super(key: key);

  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(), // we will work in here
      ),
    );
  }
}
```
- __formKey__ which is used to identity our form so we can reference it in our code (to check for validity and other form related features).
- We will put our form fields in a colum to lay them out vertically. _This tutorial won't focus on design and layout_

## Creating our models

We now need to create some models that we will be using in our form. I like placing my models in a designated folder under `lib`. So let's create a new file in `lib\models\payment.dart`

```dart
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
}
```
__Note:__ _Please feel free to redajust the models to your liking this is just how I did it at the time if you think you can structure it better go ahead_


## TextFields

Let's create a __FormTextField__ for the card holder's name and get its value.
We will discuss two ways to get data from a FormTextField. In this text field we'll use the simple appraoch which works by saving the value to an instance of __CardDetails__.

let's create that instance:
```dart
class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  CardDetails _cardDetails = new CardDetails(); // new line
  // rest of our code
```
Now that we have that we can create the text field as shown bellow.

```dart
// inside the column widget
children: <Widget>[
  TextFormField(
    onSaved: (val) => _cardDetails.cardHolderName = val,
    decoration: InputDecoration(
        labelText: 'Name on card',
        icon: Icon(Icons.account_circle),
    ),
  ),
]
```
- __onSaved__ does not get triggered until we do it manually (we'll do that later).
- __decoration__ is used to style the input field. Here we add a label to the field and an icon.

There are many more properties you can use with a TextField that you can find in the [docs](https://api.flutter.dev/flutter/material/TextField-class.html)

Now let's create card number and security code text fields with a numbers only keyboard. Saving functionality will be identical to the previsuos text field.

```dart
// After the Card holder text field inside the widget list
TextFormField(
  onSaved: (val) => _cardDetails.cardNumber = val,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
    labelText: 'Card number',
    icon: Icon(Icons.credit_card),
  ),
),
TextFormField(
  onSaved: (val) => _cardDetails.securityCode = int.parse(val),
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
    labelText: 'Security Code',
    icon: Icon(Icons.lock_outline),
  ),
),
```
- __keyboadType__ lets us set the input type. In this case we use number but there are other constants such as (datetime, email address, etc..) You can read more about TextInputType in the [docs](https://api.flutter.dev/flutter/services/TextInputType-class.html)

## Drop down fields

We now need a way for the user to enter their expiry information. For that we're going to use __DropdownButtonFormField__ for the months and years. It has the item property that takes a list of __DropdownMenuItem__ . The thing about __DropdownButtonFormField__ is that it does not update automaticaly. It needs a value and an onChanged function to update its value once an event is triggered.

Let's add the expiryMonth and expiryYear vars at the top of the widget. We also need a list of years to accept (here we generate a list with dates from 2020 upto 2032)

```dart
class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  CardDetails _cardDetails = new CardDetails();
  String expiryMonth; // new line
  String expiryYear; // new line
  final List yearsList =
      List.generate(12, (int index) => index + 2020); // new line
  // rest of our code
```
and now let's create the months drop down widget and add it to our widget list

```Dart
// after the security code text field widget
DropdownButtonFormField<String>(
  onSaved: (val) => _cardDetails.expiryMonth = val,
  value: expiryMonth,
  items: [
    'Jan','Feb','Mar','Apr','May','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec'
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
```

add the years widget as well

```dart
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
```

To have a full form by the end of this part. Let's create 2 simple text fields for post code and address and a sumbit button. In the next part of the tutorial I will expand on how to use typeheads and auto form population for these 2 text fields.

add this to the top of your class

```dart
Address _paymentAddress = new Address();
```
then create the widgets

```dart
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
RaisedButton(
  child: Text('Process Payment'),
  color: Colors.pinkAccent,
  textColor: Colors.white,
  onPressed: () {
    print('Payment Complete');
  },
),
```

## Validation
It is time to add some validation to our form. Let's start by validating that the fields are not empty. To do this we need to add the validator property to any of the form fields.

```dart
validator: (value) {
  if (value.isEmpty) return "This form value must be filled";
  return null;
},
```
- __validator__ Takes a function that returns a string (if a string is returned that means there's an error). 

We're also going to add a card number length validation to our card number textfield

```dart
// After the Card holder text field inside the widget list
TextFormField(
  onSaved: (val) => _cardDetails.cardNumber = val,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
    labelText: 'Card number',
    icon: Icon(Icons.credit_card),
  ),
  // new lines bellow
  validator: (value) {
    if (value.isEmpty) return "This form value must be filled";
    if (value.length != 16) return "Please enter a valid number";
    return null;
  },
),
```

We will come across multiple ways to run a validator. For this text field let us enable autovalidation (which means that validation happens everytime the value changes)

Add this to our Card Number text field.

```dart
autovalidate: true,
```

There's one issue with this approach. The validator runs as soon as the widget loads which will return our empty error by default. To tackle this minor issue we need to add a variable in our stateful widget to check when we need to start auto validating.

```dart
class _PaymentFormState extends State<PaymentForm> {
  // old code here
  String expiryMonth;
  String expiryYear;
  final List yearsList = List.generate(12, (int index) => index + 2020);
  // Add the lines below
  Map<String, bool> touched = { 
    "cardNumberField": false,
  };
  // rest of our code
```
and change autoValidate to 
``` dart
autovalidate: touched['cardNumberField'],
```

Let's use a map in case we need to add more auto validated text fields. If you would prefer creating a boolean varaible for each go ahead with that.

Now let's change the value of cardNumberField to true once someone changes our text field. We can do that using onChanged and setState.

```dart
onChanged: (value) {
  setState(() {
    touched['cardNumberField'] = true;
  });
},
```

If you need to validate a field asynchronosly then you would need to do that when submiting the form because for the time being the validator property only accepts synchronos functions. You could use third party packages like [flutter_bloc](https://pub.dev/packages/flutter_form_bloc) but we won't do that in this tutorial. Let's work with async validation to validate the card number when submitting the form.

We need to edit our onPressed function in our RaisedButton widget. We also need to create an instance of __TextEditingController__ for the card number field. This allows us to have better control on the text field and get the value associated to it.

Let's add this to the top of the class

```dart
final _cardNumberController = TextEditingController();
```
and then assign it to the card textfield widget

```dart
controller: _cardNumberController,
```
The text field should look like this now

```dart
TextFormField(
  onSaved: (val) => _cardDetails.cardNumber = val,
  controller: _cardNumberController,  // new line
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
    labelText: 'Card number',
    icon: Icon(Icons.credit_card),
  ),
  onChanged: (value) {
    setState(() {
      touched['cardNumberField'] = true;
    });
  },
  autovalidate: touched['cardNumberField'],
  validator: (value) {
    if (value.isEmpty) return "This form value must be filled";
    if (value.length != 16) return "Please enter a valid number";
    return null;
  },
),
```
now let's update the onPress function in our RaisedButton

```dart
onPressed: () async {
  // this should be your async call
  var validCardNumber =
    await validCardNumberCheck(_cardNumberController.text);
  // then you would need to check for it and that the form is valid before proceeding
  if (_formKey.currentState.validate() && validCardNumber) {
    _formKey.currentState.save();
    Payment payment = new Payment(
      address: _paymentAddress,
      cardDetails: _cardDetails,
    );
    // async call to your backend to process the payment
    handlePayment(payment);
    // Use a print or a breakpoint to check that payment is saved properly
    print(payment.cardDetails.cardHolderName);
  }
},
```

## Conclusion
We have created a form with popular field options and validated it both localy and remotely. For more information about anything else I recommend the docs as they are the most up to date resource.

In Part 2 we will look into more advanced functionality to make this form more feature rich and responsive.