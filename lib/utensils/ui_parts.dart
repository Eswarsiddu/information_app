import 'package:flutter/material.dart';

class UIParts {
  static Widget partProblemButton(
          {required Function() action, required String text}) =>
      ElevatedButton(onPressed: action, child: Text(text));
}
