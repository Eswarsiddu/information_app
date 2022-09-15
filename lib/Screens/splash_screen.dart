import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:information_app/Screens/home_screen.dart';
import 'package:information_app/utensils/assets_data.dart';
import 'package:information_app/utensils/constants.dart' as constants;
import 'package:information_app/utensils/local_files.dart';
import 'package:information_app/utensils/online_json_data.dart';

//TODO: Add Animation of loading

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late bool isLoaded;

  @override
  void initState() {
    isLoaded = false;
    super.initState();
    initialize();
  }

  void initialize() async {
    await localFiles.setup();
    await onlineJsonData.setup();

    if (!localFiles.isFilesExisted) {
      createData();
      return;
    }

    if (!onlineJsonData.isConnected) {
      loadData();
      return;
    }

    updateVersion(onlineJsonData.version);

    Map<String, bool> versions = await checkVersions();
    if (versions[constants.KEYS.version] == true) {
      updateData(await onlineJsonData.data);
    }

    if (versions[constants.KEYS.images] == true) {
      String newjson = await onlineJsonData.images;
      localFiles.imageManager.updateImages(
          newJson: convert.jsonDecode(newjson),
          oldJson: convert.jsonDecode(await localFiles.imagesJson.getJson));
      updateImageJson(newjson);
    }

    //TODO : Implement app update popup

    loadData();
  }

  Future<Map<String, bool>> checkVersions() async {
    Map<String, bool> versions = {};
    Map<String, dynamic> onlineDataVersion =
        convert.jsonDecode(onlineJsonData.version);
    Map<String, dynamic> localDataVersion =
        convert.jsonDecode(await localFiles.versionJson.getJson);
    for (var key in [
      constants.KEYS.version,
      constants.KEYS.update,
      constants.KEYS.images
    ]) {
      versions[key] = onlineDataVersion[key] > localDataVersion[key];
    }

    return versions;
  }

  void createData() async {
    late String versionString;
    late String dataString;
    late String imageString;
    if (onlineJsonData.isConnected) {
      versionString = onlineJsonData.version;
      dataString = await onlineJsonData.data;
      imageString = await onlineJsonData.images;
      await localFiles.imageManager
          .updateImages(newJson: convert.jsonDecode(imageString));
    } else {
      versionString = await AssetsData.versionJson;
      dataString = await AssetsData.dataJson;
      dataString = await AssetsData.imagesJson;
      await localFiles.imageManager.updateImagesAssets();
    }
    await updateVersion(versionString);
    await updateData(dataString);
    await updateImageJson(imageString);
    loadData();
  }

  void loadData() async {
    question = "question";
    option1 = "yes";
    option2 = "no";
    setState(() {
      isLoaded = true;
    });
  }

  void loadNextScreen(String option) async {
    if (option == "yes") {
      Map<String, dynamic> data =
          convert.jsonDecode(await localFiles.dataJson.getJson);
      // TODO: Implement something for no

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomeScreen(data: data);
      }));
    }
  }

  late String question;
  late String option1;
  late String option2;

  @override
  Widget build(BuildContext context) {
    if (isLoaded) {
      return displayQuestion();
    }
    return const Scaffold(
      body: Center(
        child: Text("Updating"),
      ),
    );
  }

  Scaffold displayQuestion() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(constants.appTITLE),
      ),
      body: Column(
        children: [
          Text(question),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    loadNextScreen(option1);
                  },
                  child: Text(option1)),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    loadNextScreen(option2);
                  },
                  child: Text(option2)),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> updateImageJson(String imageJson) async {
    await localFiles.imagesJson.setJson(imageJson);
  }

  Future<void> updateData(String dataJson) async {
    await localFiles.dataJson.setJson(dataJson);
  }

  Future<void> updateVersion(String jsonData) async {
    await localFiles.versionJson.setJson(jsonData);
  }
}
