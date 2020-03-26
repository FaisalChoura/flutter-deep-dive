# Flutter Forms Guide

This guide will take you through the steps on how to build advanced reactive forms in Flutter (Material). Here is a list of what we're going to do:

- Text fields with different input types (Text, numbers, etc..) (Part 1)
- Drop downs and check boxes (Part 1)
- Local and server validations (Part 1)
- Type heads for local and server auto completing. (Part 2)
- Automatic text field population (Part 2)
- Loading indicators and snack bars once the form is submitted. (Part 2)

We'll start small and build up on that. I do not want to repeat what's on the documentation I will explain anything needed for the tutorial here but if you need to look more into something the [docs](https://api.flutter.dev/) are an incredible source.

Here is what you should have by the end of this tutorial:

(INSERT GIF HERE)

## Getting things ready

I'll assume you already have a flutter project created and want to add a form widget. I like to put all my screen widgets in a folder called screens.

Let' create our form file in `lib\screens\payment_form.dart`. Let's add a Scaffold with an app bar

```dart
import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forms'),
      ),
      body: PaymentForm(), // We'll add this in a bit
    );
  }
}
```

Most if not all reactive forms in flutter require some kind of state to be maintained. This means that we need to create the form inside a **StatefulWidget**.

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
        child: ListView(
          children: <Widget>[
            Column(), // we will work in here
          ],
        ),
      ),
    );
  }
}
```

- **formKey** which is used to identity our form so we can reference it in our code (to check for validity and other form related features).
- We will put our form fields in a column that's a child of a ListView to lay them out vertically with scrolling functionality. _This tutorial won't focus on design and layout_

## Creating our models

We now need to create some models that we will be using in our form. I like placing my models in a designated folder under `lib`. So let's create a new file in `lib\models\payment.dart`.

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

We need to import this file into our form widget file.

**Note:** _Please feel free to readjust the models to your liking this is just how I did it at the time if you think you can structure it better go ahead_

## TextFields

Let's create a **FormTextField** for the card holder's name and get its value.
We will discuss two ways to get data from a FormTextField. In this text field we'll use the simple approach which works by saving the value to an instance of **CardDetails**.

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

- **onSaved** does not get triggered until we do it manually (we'll do that when we submit our form).
- **decoration** is used to style the input field. Here we add a label to the field and an icon.

There are many more properties you can use with a TextField that you can find in the [docs](https://api.flutter.dev/flutter/material/TextField-class.html)

Now let's create card number and security code text fields with a numbers only keyboard. Security Code will have a max length of 4 digits. Saving functionality will be identical to the previous text field.

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
  maxLength: 4,
),
```

- **keyboardType** lets us set the input type. In this case we use number but there are other constants such as (datetime, email address, etc..) You can read more about TextInputType in the [docs](https://api.flutter.dev/flutter/services/TextInputType-class.html)
- **maxLength** Sets the max length on the text field.

## Drop down fields

We now need a way for the user to enter their expiry information. For that we're going to use **DropdownButtonFormField** for the months and years. It has the item property that takes a list of type **DropdownMenuItem** . The thing about **DropdownButtonFormField** is that it does not update automatically. It needs a value and an onChanged function to update its value once an event is triggered.

Let's add the expiryMonth and expiryYear vars at the top of the widget. We also need a list of years to accept (here we generate a list with dates from 2020 to 2032)

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

## Completing Form

To have a full form by the end of this part. Let's create 2 simple text fields for post code and address, a checkbox and a submit button. In the next part of the tutorial I will expand on the text fields and go through how to use typeheads and auto form population for these 2 text fields.

add the paymentAddress and rememberInfo (for our checkbox) variables to the top of your class.

```dart
Address _paymentAddress = new Address();
bool rememberInfo = false;
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
```

- **CheckBoxListTile** also needs to have an onChanged function to change it's value as it does not do that automatically.

## Validation

Our form fields need to be validated. Let's start by validating that the fields are not empty. To do this we need to add the validator property to any of the form fields.

```dart
validator: (value) {
  if (value.isEmpty) return "This form value must be filled";
  return null;
},
```

- **validator** Takes a function that returns a string (if a string is returned that means there's an error).

We're also going to add a card number length validation to our card number text field

```dart
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

We will come across multiple ways to run a validator. For this text field let us enable auto validation (which means that validation happens every time the value changes)

Add this to our Card Number text field.

```dart
autovalidate: true,
```

There's one issue with this approach. The validator runs as soon as the widget loads which will return our empty error message by default. To tackle this issue we need to add a variable in our stateful widget to check when we need to start auto validating.

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

```dart
autovalidate: touched['cardNumberField'],
```

Let's use a map in case we need to add more auto validated text fields. If you would prefer creating a boolean variable for each go ahead with that.

Now let's change the value of cardNumberField to true once someone changes our text field. We can do that using onChanged and setState.

```dart
onChanged: (value) {
  setState(() {
    touched['cardNumberField'] = true;
  });
},
```

If you need to validate a field asynchronously then you would need to do that when submitting the form because for the time being the validator property only accepts synchronous functions. You could use third party packages like [flutter_bloc](https://pub.dev/packages/flutter_form_bloc) but we won't do that in this tutorial. Let's work with async validation to validate the card number when submitting the form.

We need to edit our onPressed function in our RaisedButton widget. We also need to create a **TextEditingController** for the card number field. This allows us to have better control on the text field and get the value associated to it.

Let's add this to the top of the class

```dart
final _cardNumberController = TextEditingController();
```

and then assign it to the card number text field widget

```dart
controller: _cardNumberController,
```

The Card number text field should look like this now

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

now let's update the onPressed function in our RaisedButton.

```dart
onPressed: () async {
  var validCardNumber =
    await validCardNumberCheck(_cardNumberController.text);
  if (_formKey.currentState.validate() && validCardNumber) {
    _formKey.currentState.save();
    Payment payment = new Payment(
      address: _paymentAddress,
      cardDetails: _cardDetails,
    );
    handlePayment(payment);
    // Use a print or a breakpoint to check that payment is saved properly
    print(payment.cardDetails.cardHolderName);
  }
},
```

- We switch the function to an async function and await for the value that's returned from the backend call
- Then we use `_formKey.currentState.validate()` to check the state of all the validators in our form.
- Once that passes we create our payment and make the api call to the backend to process it.

## Conclusion

We have created a form with popular field options and validated it both locally and remotely. For more information about anything else I recommend the docs as they are the most up to date resource.

In Part 2 we will look into more advanced functionality to make this form more feature rich and responsive.
