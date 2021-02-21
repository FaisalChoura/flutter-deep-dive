import 'package:flutter/material.dart';
import 'package:riverpod_filters/providers.dart';
import 'package:flutter_riverpod/all.dart';

class Filters extends StatefulWidget {
  Filters({Key key}) : super(key: key);

  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  // 1
  bool _direct;
  TextEditingController priceController = new TextEditingController();

  // 2
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
          // 3
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
              // 4
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
            // 5
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              icon: Icon(Icons.attach_money),
              labelText: 'Max Price',
            ),
          ),
        ),
        ListTile(
          // 6
          title: Text('Apply Filters'),
          onTap: () {
            context.read(priceFilterProvider).state =
                double.parse(priceController.text);
            context.read(directFilterProvider).state = _direct;
            Navigator.pop(context);
          },
        ),
        ListTile(
          // 7
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
