import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:information_app/utensils/download_data.dart';

class _OnlineJsonData {
  final _versionJsonUrl = "JsonData/Version.json";
  final _dataJsonUrl = "JsonData/Data.json";
  final _imagesJsonUrl = "JsonData/Images.json";

  late String _versionJson;
  String _imagesJson = "";
  String _dataJson = "";

  late bool _connected;
  late bool _downloaded;

  bool get isConnected => _connected && _downloaded && !downloadData.timeOut;

  String get version => _versionJson;
  Future<String> get data async {
    if (_dataJson.isEmpty) {
      _dataJson = await downloadData.getJsonOnline(_dataJsonUrl);
    }
    return _dataJson;
  }

  Future<String> get images async {
    if (_imagesJson.isEmpty) {
      _imagesJson = await downloadData.getJsonOnline(_imagesJsonUrl);
    }
    return _imagesJson;
  }

  Future<void> setup() async {
    _connected = false;
    _downloaded = true;

    try {
      ConnectivityResult connectionStatus =
          await Connectivity().checkConnectivity();
      if (connectionStatus == ConnectivityResult.wifi ||
          connectionStatus == ConnectivityResult.mobile ||
          connectionStatus == ConnectivityResult.ethernet) _connected = true;
    } on PlatformException catch (_) {}

    if (!_connected) return;

    _versionJson = await downloadData.getJsonOnline(_versionJsonUrl);
    _imagesJson = await downloadData.getJsonOnline(_imagesJsonUrl);

    if (_versionJson.isEmpty ||
        _versionJson == "{}" ||
        _imagesJson.isEmpty ||
        _imagesJson == "{}") {
      _downloaded = false;
    }
  }
}

// ignore: library_private_types_in_public_api
final _OnlineJsonData onlineJsonData = _OnlineJsonData();
