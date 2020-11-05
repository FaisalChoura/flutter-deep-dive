import 'dart:convert';

import 'package:http/http.dart' as http;

class Address {
  Address();

  Future<String> getAddress() async {
    final resp = await http.get(
        "https://my-json-server.typicode.com/refactord/deep-dive-db/addresses");
    if (resp.statusCode == 200) {
      return jsonDecode(resp.body).toString();
    } else {
      throw Exception('Failed to load album');
    }
  }
}
