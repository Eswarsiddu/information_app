import 'package:flutter/material.dart';
import 'package:information_app/utensils/local_files.dart';
import 'package:information_app/utensils/constants.dart';

class ProblemSelected extends StatelessWidget {
  final Map<String, dynamic> data;
  final String problem;
  final String part;
  const ProblemSelected(
      {super.key,
      required this.data,
      required this.problem,
      required this.part});

  List<Widget> buildImages() {
    return [
      data.containsKey(KEYS.images)
          ? getHeading("Refernce Images")
          : const SizedBox(),
      Wrap(
        spacing: 10,
        runAlignment: WrapAlignment.spaceEvenly,
        children: List.generate(
          data.containsKey(KEYS.images) ? data[KEYS.images].length : 0,
          (index) => Image.file(
            localFiles.imageManager.getImage(
                part: part, problem: problem, name: data[KEYS.images][index]),
            width: Constants.imgSize,
            height: Constants.imgSize,
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Center(child: Text(problem)),
      ),
      body: ListView(
        children: [
          ...buildImages(),
          getHeading("Medicines to Take"),
          ...List.generate(data[KEYS.medicine].length,
              (index) => getMedicineText(data[KEYS.medicine][index])),
          getHeading("When to consult doctor"),
          ...List.generate(data[KEYS.doctor].length,
              (index) => getMedicineText(data[KEYS.doctor][index]))
        ],
      ),
    );
  }

  Widget getHeading(String text) {
    return Container(
      color: Colors.redAccent,
      height: 40,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget getMedicineText(String text) {
    return Container(
        color: Colors.lightBlueAccent,
        height: 30,
        child: Center(child: Text(text)));
  }

  Widget getDoctorText(String text) {
    return Container(
        color: Colors.lightBlueAccent,
        height: 30,
        child: Center(child: Text(text)));
  }
}
