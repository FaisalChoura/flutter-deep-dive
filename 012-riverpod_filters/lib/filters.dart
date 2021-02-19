import 'package:flutter/material.dart';
import 'package:riverpod_filters/providers.dart';
import 'package:flutter_riverpod/all.dart';

class Filters extends StatefulWidget {
  Filters({Key key}) : super(key: key);

  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  bool _direct;
  TextEditingController priceController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _direct = context.read(directFilterProvider).state;
    priceController.text = context.read(priceFilterProvider).state.toString();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text(
            'Filters',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        Row(
          children: [
            Checkbox(
              value: _direct,
              onChanged: (bool value) {
                setState(() {
                  _direct = value;
                });
              },
            ),
            Text('Direct')
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: TextFormField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              icon: Icon(Icons.attach_money),
              labelText: 'Max Price',
            ),
          ),
        ),
        ListTile(
          title: Text('Apply Filters'),
          onTap: () {
            context.read(priceFilterProvider).state =
                double.parse(priceController.text);
            context.read(directFilterProvider).state = _direct;
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Clear Filters'),
          onTap: () {
            setState(() {
              _direct = false;
              priceController.text = '0';
            });
            context.read(priceFilterProvider).state = 0;
            context.read(directFilterProvider).state = false;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
