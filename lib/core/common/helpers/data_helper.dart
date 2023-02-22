import 'dart:convert';
import 'dart:typed_data';

abstract class DataHelper {
  static decodeBytes(Uint8List bytes) {
    final jsonString = utf8.decode(bytes);
    final responseData = json.decode(jsonString);
    return responseData;
  }
}
