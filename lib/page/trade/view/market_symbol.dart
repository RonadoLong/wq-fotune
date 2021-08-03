import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:wq_fotune/model/ticker.dart';
import 'package:wq_fotune/model/user_info.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/ui_data.dart';

class MarketSymbol extends StatelessWidget {
  Ticker ticker;

  Map currentSymbol;

  Map dataMap;

  List apiList;

  UserInfo userInfo;

  Function onDataChange;

  MarketSymbol(
      {this.ticker,
      this.dataMap,
      this.userInfo,
      this.onDataChange,
      this.apiList,
      this.currentSymbol});

  bool isVisible = true;

  Color changeColor() {
    if (ticker != null && ticker.change.toString().contains("-")) {
      return UIData.red_color;
    }
    return UIData.turquoise_color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: Column(
        children: [
          headerSelect(),
        ],
      ),
    );
  }

  Widget headerSelect() {
    print("currentSymbol====${currentSymbol}");
    return GestureDetector(
      onTap: () {
        onDataChange();
      },
      child: Container(
        // padding: EdgeInsets.fromLTRB(0, 0, 0, 15.0),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/images/icon_eth@3x.png',
                    width: 25.0, height: 25.0),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: new Row(
                    children: <Widget>[
                      new Text(
                        currentSymbol.length != 0
                            ? currentSymbol["symbol"]?.replaceAll("-", " / ")
                            : '',
                        style: TextStyles.MediumBlackTextSize14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  ticker != null ? " ${ticker.last}" : "00.00",
                  style: TextStyle(
                    color: changeColor(),
                    fontSize: 14.0,
                    fontFamily: 'fontFamily: PingFangSC-Medium, PingFang SC',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                AnimatedContainer(
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  height: 28,
                  // width: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    color: changeColor(),
                  ),
                  duration: Duration(milliseconds: 500),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        ticker != null ? ("${ticker.change}") : ("0.00%"),
                        style: TextStyles.MediumWhiteTextSize13,
                      ),
                    ],
                  ),
                ),
                Container(width: 8.0),
                Icon(
                  Icons.arrow_forward_ios,
                  color: UIData.two_color,
                  size: 18,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
