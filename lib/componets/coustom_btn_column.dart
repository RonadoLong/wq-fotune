import 'package:flutter/material.dart';
import 'package:wq_fotune/utils/ui_data.dart';

class CustomBtnColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  CustomBtnColumn(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        new Icon(this.icon,
            color: this.color == null ? UIData.primary_color : this.color),
        new Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: new Text(
            label,
            style: new TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: this.color == null ? UIData.normal_font_color : this.color,
            ),
          ),
        ),
      ],
    );
  }
}
