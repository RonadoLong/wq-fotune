import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/utils/ui_data.dart';

class RoundBtn extends StatelessWidget {
  final String content;
  final Function onPress;
  final bool isPositioned;

  const RoundBtn({
    Key key,
    this.content,
    this.isPositioned = true,
    this.onPress,
  }) : super(key: key);

  _buildBtn(context) {
    double width = MediaQuery.of(context).size.width * 0.8;
    return FlatButton(
      color: UIData.primary_color,
      onPressed: onPress,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: UIData.primary_color),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        width: width,
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: new Text(
          content,
          textAlign: TextAlign.center,
          style: new TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isPositioned
        ? Positioned(
            bottom: 100,
            child: _buildBtn(context),
          )
        : Center(
            child: _buildBtn(context),
          );
  }
}
