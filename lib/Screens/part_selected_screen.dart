import 'package:flutter/material.dart';
import 'package:information_app/Screens/problem_selected_screen.dart';

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
      body: Center(
        child: Wrap(
          children: List.generate(keys.length, (index) {
            String problem = keys[index];
            return ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProblemSelected(
                      data: data[problem], problem: problem, part: part);
                }));
              },
              child: Text(problem),
            );
          }),
        ),
      ),
    );
  }
}
