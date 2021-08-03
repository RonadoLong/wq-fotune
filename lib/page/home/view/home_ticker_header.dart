import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/ui_data.dart';

class HomeTickerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return homeTicksHeader();
  }

  Widget homeTicksHeader() {
    return new Container(
        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0),
        margin: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 0),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "推荐策略",
              style: TextStyles.MediumBlackTextSize16,
            ),
          ],
        ));
  }
}
