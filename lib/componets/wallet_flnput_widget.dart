import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/utils/UIData.dart';

/// 带图标的输入框
class WalletFInputWidget extends StatefulWidget {
  final bool obscureText;

  final String hintText;

  final IconData iconData;

  final FocusNode focusNode;

  final ValueChanged<String> onChanged;

  final TextStyle textStyle;

  final TextEditingController controller;

  final bool isNumber;

  final bool enabled;



  WalletFInputWidget(
      {Key key,
        this.hintText,
        this.iconData,
        this.onChanged,
        this.textStyle,
        this.controller,
        this.focusNode,
        this.enabled,
        this.obscureText = false,
        this.isNumber = false})
      : super(key: key);

  @override
  _FInputWidgetState createState() => new _FInputWidgetState();
}

/// State for [FInputWidget] widgets.
class _FInputWidgetState extends State<WalletFInputWidget> {
  _FInputWidgetState() : super();

  @override
  Widget build(BuildContext context) {
    return new TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      enabled: widget.enabled,
      cursorColor: UIData.normal_line_color,
      focusNode:widget.focusNode,
      keyboardType: widget.isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: UIData.normal_line_color,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.only(left: 10.0),
        filled: true,
        fillColor: widget.enabled == false ?  Colors.white : Colors.white,
        icon: widget.iconData == null ? null : new Icon(widget.iconData),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
//            color: Color.fromRGBO(245,245,245,1), //边框颜色
            width: 2, //边线宽度
          ),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white, //边框颜色
              width: 2, //边线宽度
            )
        ),
      ),
    );
  }
}


