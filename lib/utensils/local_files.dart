import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:information_app/utensils/assets_data.dart';
import 'package:information_app/utensils/constants.dart';
import 'package:information_app/utensils/download_data.dart';

class _JsonFile {
  late File _file;

  Future<void> _setup(String path) async {
    _file = File(_LocalFiles._applicationPath + path);
  }

  Future<void> setJson(String jsonData) async {
    await _file.writeAsString(jsonData);
  }

  Future<String> get getJson async => await _file.readAsString();
}

class _ImagesManager {
  Future<void> updateImages(
      {Map<String, dynamic> oldJson = const {},
      required Map<String, dynamic> newJson}) async {
    for (String part in newJson.keys) {
      for (String problem in newJson[part].keys) {
        if (oldJson.isNotEmpty) {
          if (newJson[part][problem][KEYS.version] >
              oldJson[part][problem][KEYS.version]) deleteImages(part, problem);
        }
        _downloadImages(part, problem, newJson[part][problem][KEYS.data]);
      }
    }
  }

  Future<void> _downloadImages(
      String part, String problem, List<dynamic> names) async {
    for (dynamic name in names) {
      name = name.toString();
      Uint8List image = await downloadData.getImageOnline(
          part: part, problem: problem, name: name);
      setImage(part: part, problem: problem, name: name, image: image);
    }
  }

  Future<void> setImage(
      {required String part,
      required String problem,
      required String name,
      required Uint8List image}) async {
    String path = "${_LocalFiles._applicationPath}/Images/$part/$problem";
    if (!await Directory(path).exists()) {
      Directory(path).create(recursive: true);
    }
    path = "$path/$name";
    File f = await File(path).create(recursive: true);
    f.writeAsBytes(image);
  }

  File getImage(
          {required String part,
          required String problem,
          required String name}) =>
      File("${_LocalFiles._applicationPath}/Images/$part/$problem/$name");

  Future<bool> deleteImages(String part, String problem) async {
    try {
      Directory dir =
          Directory("${_LocalFiles._applicationPath}/Images/$part/$problem");
      Stream<FileSystemEntity> files = dir.list();
      await for (FileSystemEntity file in files) {
        await file.delete();
      }
    } catch (_) {
      return false;
    }
    return true;
  }

  Future<void> updateImagesAssets() async {
    Map<String, dynamic> imagesjson = jsonDecode(await AssetsData.imagesJson);
    for (String part in imagesjson.keys) {
      for (String problem in imagesjson[part].keys) {
        for (String name in imagesjson[part][problem]) {
          Uint8List image = await AssetsData.getImageOnline(
              part: part, problem: problem, name: name);
          setImage(part: part, problem: problem, name: name, image: image);
        }
      }
    }
  }
}

class _LocalFiles {
  static String _applicationPath = "";

  _JsonFile versionJson = _JsonFile();
  _JsonFile dataJson = _JsonFile();
  _JsonFile imagesJson = _JsonFile();
  _ImagesManager imageManager = _ImagesManager();

  bool get isFilesExisted => _existed;

  late bool _existed;

  Future<void> setup() async {
    Directory? externalDirectory = await getExternalStorageDirectory();
    if (externalDirectory == null) return;
    _applicationPath = externalDirectory.path;
    String jsonpath = "$_applicationPath/Json";
    _existed = await Directory(jsonpath).exists();
    if (!_existed) await Directory(jsonpath).create(recursive: true);
    await versionJson._setup("/Json/Versoin.json");
    await dataJson._setup("/Json/Data.json");
    await imagesJson._setup("/Json/Images.json");
  }
}

// ignore: library_private_types_in_public_api
final _LocalFiles localFiles = _LocalFiles();
