import 'package:flutter/material.dart';
import 'package:information_app/utensils/constants.dart' as constants;
import 'package:information_app/Screens/part_selected_screen.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const HomeScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    List<String> keys = data.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text(constants.appTITLE),
      ),
      body: Center(
        child: Wrap(
          children: List.generate(
            keys.length,
            (index) {
              String part = keys[index];
              return ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PartSelected(data: data[part], part: part);
                  }));
                },
                child: Text(part),
              );
            },
          ),
        ),
      ),
    );
  }
}
