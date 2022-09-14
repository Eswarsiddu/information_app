import 'package:flutter/services.dart';

class AssetsData {
  static Future<String> get versionJson async =>
      await rootBundle.loadString("assets/version.json");
  static Future<String> get dataJson async =>
      await rootBundle.loadString("assets/data.json");
  static Future<String> get imagesJson async =>
      await rootBundle.loadString("assets/images.json");
  static Future<Uint8List> getImageOnline(
      {required String part,
      required String problem,
      required String name}) async {
    ByteData bytes = await rootBundle.load("assets/$part/$problem/$name");
    Uint8List imagebytes =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    return imagebytes;
  }
}
