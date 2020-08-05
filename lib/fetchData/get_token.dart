import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<String> get jwtOrEmpty async {
  final storage = FlutterSecureStorage();
  var jwt = await storage.read(key: "jwt");
  if(jwt == null) return "";
  return jwt;
}
