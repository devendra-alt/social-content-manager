import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

void writeToSecureStorage(key, value) async {
  await storage.write(key: key, value: value);
}

Future<String?> readFromSecureStorage(key) async {
  return await storage.read(key: key);
}

void deleteFromSecureStorage(key) async {
  await storage.delete(key: key);
}
