# Flutter Forms Guide

This guide will take you through the steps on how to build advanced reactive forms in Flutter (Material). Here is a list of what we're going to do:

- Text fields with different input types (Text, numbers, etc..) (Part 1)
- Drop downs and check boxes (Part 1)
- Local and server validations (Part 1)
- Typeaheads for local and server auto completing. (Part 2)
- Automatic text field population (Part 2)
- Loading indicators and snack bars once the form is submitted. (Part 2)

We'll start small and build up on that. I do not want to repeat what's on the documentation I will explain anything needed for the tutorial here but if you need to look more into something the [docs](https://api.flutter.dev/) are an incredible source.

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

# Part II

Welcome back to those of you who have read part one. If you just landed here, here's a quick look of what the last guide was about and what's covered in this one.

- Text fields with different input types (Text, numbers, etc..) (Part 1)
- Drop downs and check boxes (Part 1)
- Local and server validations (Part 1)
- Typeaheads for local and server auto completing. (Part 2)
- Automatic text field population (Part 2)
- Loading indeicators and snack bars once the form is submited. (Part 2)

Here's a link to [part one](https://medium.com/@faisal.choura/advanced-flutter-forms-part-1-e575422176ed).

If you want to follow through with this feel free to get the `part_one` code from the [repo](https://github.com/refactord/flutter-deep-dive/tree/master/lib/minis/forms_mini)

## Typeahead (auto completion)

Let's add some auto completion to our post code form field. When a user types in the field we make a call to the backend or get a local list to suggest some options to choose from.

Flutter does not support typeaheads out of the box so we're going to use a package called `flutter_typeahead`. Please add this to your pubspec file and save it.

```
flutter_typeahead: ^1.8.0
```

a newer version will probably be out by the time you read this to please get the right one from [here](https://pub.dev/packages/flutter_typeahead). Don't forget to import it!

Now we need to replace the `TextFormField` with the `TypeAheadFormField` widget, that has all the properties of `TextFormField`.

```dart
TypeAheadFormField(
  onSaved: (val) => _paymentAddress.postCode = val,
  textFieldConfiguration: TextFieldConfiguration(
    decoration: InputDecoration(
      labelText: 'Post Code',
      icon: Icon(Icons.location_on),
    ),
  ),
  suggestionsCallback: (pattern) {},
  itemBuilder: (context, Address address) {},
  onSuggestionSelected: (Address address) {},
),
```

- **textFieldConfiguration** is where most of the properties that belong to to `TextFormField` are added.
- **suggestionsCallback** takes a function that's called when the user edits the field and uses the value as the argument. It returns a list of data to be used. It can be both synchronous and asynchronous.
- **itemBuilder** buildes a widget for each value in the list that's returned from `suggestionsCallback`
- **onSuggestionSelected** a call back that is called once a suggestion is tapped

We should now have something that looks identical to what we had.

Now let's start adding functionality to the typeahead starting with `suggestionCallback`.

```dart
suggestionsCallback: (pattern) {
  List<Address> addresses = [
    new Address(postCode: 'E4 9PS', addressLine: 'some address 1'),
    new Address(postCode: 'E4 9PS', addressLine: 'some address 1.1'),
    new Address(postCode: 'W11 1DZ', addressLine: 'some address 2'),
    new Address(postCode: 'N1 8YF', addressLine: 'some address 3')
  ];
  return addresses.where((a) => a.postCode == pattern);
},
```

- We create a list of addresses to search through, filter them based on the entry and return the corect list.

To perform an async call you would need an async function. It would look something like this.

```dart
suggestionsCallback: (pattern) async {
  addresses = await someApiCall(pattern);
  // any other code
  return addresses;
}
```

once you add that, it still won't work as our item builder is empty. We're going to create a simple `ListTile` to present each address.

```dart
itemBuilder: (context, Address address) {
  return ListTile(
    leading: Icon(Icons.location_city),
    title: Text(address.addressLine),
    subtitle: Text(address.postCode),
  );
},
```

- the **itemBuilder** takes in a function that has context and an address (or whatever type you're using) as arguments.
- **ListTile** is a simple way to present a list. More on it [here](https://api.flutter.dev/flutter/material/ListTile-class.html)

Now you should have a working autocomplete, that does not do anything once a suggestion is chosen. Let's take a look at auto filling in the next section.

## Automatic text field population (auto fill)

Now let's fill the address line automatically based on what the user clicks. In order to do that we need to create a `TextEditingController`.

Add this to the declarations at the top of the class

```dart
final _addressLineController = TextEditingController();
```

Now let's link our address line text field to the controller by adding the controller to our text field. It should look like this

```dart
TextFormField(
  onSaved: (val) => _paymentAddress.addressLine = val,
  controller: _addressLineController, // add this line
  decoration: InputDecoration(
    labelText: 'Address Line',
    icon: Icon(Icons.location_city),
  ),
),
```

Now we need to fill out the `onSuggestionSelected` callback with a simple assigning line of code

```dart
onSuggestionSelected: (Address address) {
  _addressLineController.text = address.addressLine;
},
```

- We use the text property on the addressLineController to assign the address line to the text field.

more on `TextEditingController` functionality [here](https://api.flutter.dev/flutter/widgets/TextEditingController-class.html)

Once the suggestion is clicked it will automatically fill in the field with the appropriate address line.

## Spinner & Snack Bar

To make things as close to a real world example let's finish everything up by adding a spinner and a snack bar to alert us when the payment is complete.

I like using [flutter_spinkit](https://pub.dev/packages/flutter_spinkit) for spinners as they have a few option and it's very easy to integrate.

Add this to you pubspec file and save. Don't forget to import it!

```yaml
flutter_spinkit: "^4.1.2"
```

Let's add a loading boolean to our form class.

```dart
bool loading = false;
```

We also need to change the of the button to a spinner once the button is clicked

```dart
RaisedButton(
  child: loading
    ? SpinKitWave(
        color: Colors.white,
        size: 15.0,
      )
    : Text('Process Payment'),
    //rest of the button code
),
```

- We're using an inline if statement to check if loading is set to true. If it is we show our SpinKit
- The **SpinKitWave** is an indicator that looks like a wave and takes a color and a size.

Now let's edit our onPressed functionality of the proccess payment button to enable the spinner and show the `SnackBar`. It should look like this

```dart
onPressed: () {
  if (_formKey.currentState.validate()) {
    setState(() {
      loading = true;
    });
    _formKey.currentState.save();
    Timer(Duration(seconds: 4), () {
      Payment payment = new Payment(
          address: _paymentAddress,
          cardDetails: _cardDetails);
      setState(() {
        loading = false;
      });
      final snackBar =
        SnackBar(content: Text('Payment Proccessed'));
      Scaffold.of(context).showSnackBar(snackBar);
      print('Saved');
    });
  }
},
```

- Once the button is pressed we set the loading state to true and that triggers the spinner
- We use a timer to mimic an async call and show the spinner for 4 seconds.
- Once the timer is done we return the state to false and trigger the snack bar.

_Notes_

- `Timer` needs to be imported from `'dart:async'`
- if you would like to show the snack bar on a different page then take a look at this [cook book](https://flutter.dev/docs/cookbook/navigation/returning-data) provided on the flutter website.

## Conclusion

We now have a fully functional real life example form, with all the major fields and a few added bells and wistles. I hope you find this helpful or it helped you figure something out. If you find anything wrong or think you can add to these posts please feel free to send me a pull request.

You can find the github version [here](https://github.com/refactord/flutter-deep-dive/tree/master/lib/minis/forms_mini)
