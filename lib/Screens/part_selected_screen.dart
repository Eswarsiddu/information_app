import 'package:flutter/material.dart';
import 'package:information_app/Screens/problem_selected_screen.dart';
import 'package:information_app/utensils/ui_parts.dart';

class PartSelected extends StatelessWidget {
  final Map<String, dynamic> data;
  final String part;
  const PartSelected({super.key, required this.data, required this.part});

  @override
  Widget build(BuildContext context) {
    List<String> keys = data.keys.toList();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Center(child: Text(part)),
      ),
      body: Wrap(
        runAlignment: WrapAlignment.spaceEvenly,
        children: List.generate(keys.length, (index) {
          String problem = keys[index];
          return UIParts.partProblemButton(
            text: problem,
            action: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProblemSelected(
                      data: data[problem], problem: problem, part: part)),
            ),
          );
        }),
      ),
    );
  }
}
