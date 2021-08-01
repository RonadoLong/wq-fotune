import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wq_fotune/utils/UIData.dart';

/// 带图标的输入框
class PopupInputWidget extends StatefulWidget {
  final bool obscureText;

  final String hintText;

  final IconData iconData;

  final ValueChanged<String> onChanged;

  final TextStyle textStyle;

  final TextEditingController controller;

  final bool isNumber;

  PopupInputWidget(
      {Key key,
        this.hintText,
        this.iconData,
        this.onChanged,
        this.textStyle,
        this.controller,
        this.obscureText = false,
        this.isNumber = false})
      : super(key: key);

  @override
  _FInputWidgetState createState() => new _FInputWidgetState();
}

/// State for [FInputWidget] widgets.
class _FInputWidgetState extends State<PopupInputWidget> {
  _FInputWidgetState() : super();

  @override
  Widget build(BuildContext context) {
    return new TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      cursorColor: UIData.blue_color,
      keyboardType: widget.isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: UIData.normal_line_color,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.only(left: 10.0),
        filled: true,
        fillColor: Color.fromRGBO(245, 245, 245, 1),
        icon: widget.iconData == null ? null : new Icon(widget.iconData),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(245,245,245,1), //边框颜色
            width: 2, //边线宽度
          ),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: UIData.blue_color, //边框颜色
              width: 2, //边线宽度
            )
        ),
      ),
    );
  }
}


