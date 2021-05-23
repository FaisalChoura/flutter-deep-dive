import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:backup_restore_json/person.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Reading and Writing Files',
      home: FlutterDemo(storage: PersonStorage()),
    ),
  );
}

class PersonStorage {
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    var path = directory.path;
    return path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/backup.json');
  }

  Future<List<Person>> readPeople() async {
    try {
      final file = await _localFile;

      // Read the file
      final jsonContents = await file.readAsString();
      List<dynamic> jsonResponse = json.decode(jsonContents);
      return jsonResponse.map((i) => Person.fromJson(i)).toList();
    } catch (e) {
      // If encountering an error, return 0
      return [];
    }
  }

  Future<File> writePeople(List<Person> people) async {
    if (!await Permission.storage.request().isGranted) {
      return Future.value(null);
    }

    final file = await _localFile;
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    String encodedPeople = jsonEncode(people);
    return file.writeAsString(encodedPeople);
  }
}

class FlutterDemo extends StatefulWidget {
  final PersonStorage storage;

  FlutterDemo({Key key, this.storage}) : super(key: key);

  @override
  _FlutterDemoState createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  List<Person> people = [];

  @override
  void initState() {
    super.initState();
  }

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

  readPeople() async {
    var importedPeople = await widget.storage.readPeople();
    setState(() {
      people = importedPeople;
    });
  }

  Future<File> delete() {
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
                  onPressed: null,
                  child: Text('Share'),
                ),
                TextButton(
                  onPressed: () => delete(),
                  child: Text('Clear'),
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
