import 'dart:async';
import 'dart:io';

import 'package:backup_restore_json/person.dart';
import 'package:backup_restore_json/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Reading and Writing Files',
      home: FlutterDemo(storage: Storage()),
    ),
  );
}

class FlutterDemo extends StatefulWidget {
  final Storage storage;

  FlutterDemo({Key key, this.storage}) : super(key: key);

  @override
  _FlutterDemoState createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  List<Person> people = [];

  Future<File> addPeople() {
    setState(() {
      people.addAll([
        new Person(name: 'Mark', gender: 'Male'),
        new Person(name: 'Kate', gender: 'Female'),
        new Person(name: 'Tyler', gender: 'Male'),
      ]);
    });

    return widget.storage.writePeople(people);
  }

  void readPeople() async {
    var importedPeople = await widget.storage.readPeople();
    setState(() {
      people = importedPeople;
    });
  }

  void readPeopleFromFilePicker() async {
    var importedPeople = await widget.storage.readFromFilePicker();
    setState(() {
      people = importedPeople;
    });
  }

  void delete() {
    setState(() {
      people = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reading and Writing Files')),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () => addPeople(),
                  child: Text('Write'),
                ),
                TextButton(
                  onPressed: () => readPeople(),
                  child: Text('Read'),
                ),
                TextButton(
                  onPressed: () => widget.storage.share(),
                  child: Text('Share'),
                ),
                TextButton(
                  onPressed: () => delete(),
                  child: Text('Clear'),
                ),
                TextButton(
                  onPressed: () => readPeopleFromFilePicker(),
                  child: Text('File Picker'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: people.length,
                  itemBuilder: (context, index) {
                    var person = people[index];
                    return ListTile(
                      title: Text(person.name),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
