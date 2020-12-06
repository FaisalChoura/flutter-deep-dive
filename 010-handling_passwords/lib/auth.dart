import 'package:crypt/crypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth {
  FlutterSecureStorage storage;
  Auth() {
    storage = new FlutterSecureStorage();
  }

  void setPassword(String uid, String password) {
    String hashedPassword = Crypt.sha256(password).toString();
    storage.write(key: uid, value: hashedPassword);
  }

  Future<bool> checkPassword(String uid, String password) async {
    String storedHashedPassword = await storage.read(key: uid);
    return Future.value(Crypt(storedHashedPassword).match(password));
  }
}
