import 'package:flutter/material.dart';
import 'package:wq_fotune/utils/UIData.dart';
class MarketDetalisItem extends StatelessWidget {
  final Map data;
  final Function press;

  MarketDetalisItem({Key key, this.data, this.press});
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Container(
          height: 116.0,
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          margin: EdgeInsets.only(bottom: 10.0),
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: UIData.shadow_color,
                  blurRadius: 4.0,
                  offset: Offset(0.0, 4.0),
                )
              ]),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Text(
                    data['symbol'],
                    style: TextStyle(
                        fontSize: 14,
                        color: UIData.blck_color,
                        fontWeight: FontWeight.w700,
                        height: 2.0),
                  ),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    "已实现盈亏：" + data['realize_profit'],
                    style: TextStyle(
                        fontSize: 14, color: UIData.blck_color, height: 2.0),
                  ),
                  new Text(
                    "持仓：" + data['position'].toString(),
                    style: TextStyle(
                        fontSize: 14, color: UIData.blck_color, height: 2.0),
                  )
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    "未实现盈亏：" + data['un_realize_profit'],
                    style: TextStyle(
                        fontSize: 14, color: UIData.blck_color, height: 2.0),
                  ),
                  new Text(
                    "总收益率：" + data['rate_return'].toString(),
                    style: TextStyle(
                        fontSize: 14, color: UIData.blck_color, height: 2.0),
                  )
                ],
              ),
            ],
          )),
      onTap: () {

      },
    );
  }
}
