import 'dart:convert';
import 'dart:io';

import 'package:backup_restore_json/person.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

class Storage {
  Future<String> get _localPath async {
    // 1
    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;
    return path;
  }

  Future<File> get _localFile async {
    // 2
    final path = await _localPath;
    return File('$path/backup.json');
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

  Future<List<Person>> readPeople(
      [bool local = true, File selectedFile]) async {
    try {
      File file;
      if (local) {
        file = await _localFile;
      } else {
        file = selectedFile;
      }

      // Read the file
      final jsonContents = await file.readAsString();
      List<dynamic> jsonResponse = json.decode(jsonContents);
      return jsonResponse.map((i) => Person.fromJson(i)).toList();
    } catch (e) {
      // If encountering an error, return 0
      return [];
    }
  }

  void share() async {
    File file = await _localFile; // 1
    Share.shareFiles([file.path], text: 'Back up'); // 2
  }

  Future<List<Person>> readFromFilePicker() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(); // 1

    if (result == null) {
      // 2
      return Future.value(readPeople());
    }

    File file = File(result.files.single.path); // 3
    var people = readPeople(false, file); // 4
    writePeople(await people); // 5
    return people;
  }
}
