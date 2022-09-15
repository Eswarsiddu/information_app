import 'package:flutter/material.dart';
import 'package:information_app/utensils/constants.dart';

class UIParts {
  static Widget partProblemButton(
          {required Function() action, required String text}) =>
      ElevatedButton(onPressed: action, child: Text(text.toTitle()));
}
