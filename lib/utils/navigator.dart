import 'package:flutter/material.dart';

class Navigation {
  static navigate(BuildContext context, Widget view) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => view));
  }

  static navigatePush(BuildContext context, Widget view) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => view));
  }
}