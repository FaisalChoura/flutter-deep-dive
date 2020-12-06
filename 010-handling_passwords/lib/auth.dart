import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth {
  FlutterSecureStorage storage;
  Auth() {
    storage = new FlutterSecureStorage();
  }

  void setPassword(String uid, String password) {
    storage.write(key: uid, value: password);
  }

  Future<bool> checkPassword(String uid, String password) async {
    String storedPassword = await storage.read(key: uid);
    return Future.value(storedPassword == password);
  }
}
