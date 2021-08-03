import 'package:flutter/material.dart';
import 'package:wq_fotune/utils/ui_data.dart';

Widget buildBar(String title, {actions}) {
  return AppBar(
    iconTheme: new IconThemeData(color: UIData.default_color),
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    title: Container(
      margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: Text(
        title,
        style: new TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: UIData.default_color,
        ),
      ),
    ),
    actions: actions,
    centerTitle: true,
    elevation: 0.0,
  );
}
