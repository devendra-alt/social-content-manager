Future<bool> writeToSecureStorage(key, value) async {
  try {
    await storage.write(key: key, value: value);
    return true;
Future<bool> writeToSecureStorage(key, value) async {
  try {
    await storage.write(key: key, value: value);
    return true;
  } catch (e) {
    return false;
  }
    await storage.write(key: key, value: value);
    return true;
  } catch (e) {
    return false;
  }
  }
