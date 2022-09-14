import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:information_app/utensils/constants.dart' as constants;

class _DownloadData {
  final _pageURl = "https://eswarsiddu.github.io/JSONAPI/";
  bool timeOut = false;

  Future<dynamic> _getData(String url) async {
    return await http.get(Uri.parse(_pageURl + url)).timeout(
        const Duration(seconds: constants.onlineTimeOut), onTimeout: () {
      timeOut = true;
      return http.Response("", 120);
    });
  }

  Future<String> getJsonOnline(String url) async {
    var response = await _getData(url);
    return response.statusCode == 200 ? response.body : "";
  }

  Future<Uint8List> getImageOnline(
      {required String part,
      required String problem,
      required String name}) async {
    var response = await _getData("Images/$part/$problem/$name");
    return response.statusCode == 200 ? response.bodyBytes : Uint8List(0);
  }

  // TODO: handle timeout
}

// ignore: library_private_types_in_public_api
_DownloadData downloadData = _DownloadData();
