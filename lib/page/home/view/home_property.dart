import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/ui_data.dart';
import 'dart:math' as math;

class HomeProperty extends StatefulWidget {
  final List dataList;

  const HomeProperty({Key key, this.dataList}) : super(key: key);
  @override
  _HomePropertyState createState() => _HomePropertyState();
}

class _HomePropertyState extends State<HomeProperty> {
  bool isShow = true;
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0),
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: new Column(
        children: <Widget>[
          new Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "交易所资产",
                    style: TextStyles.MediumBlackTextSize16,
                  ),
                  GestureDetector(
                      child: Transform.rotate(
                          angle: math.pi / 2,
                          child: Icon(
                            isShow == true
                                ? Icons.arrow_forward_ios
                                : Icons.arrow_back_ios,
                            color: UIData.three_color,
                            size: 16.0,
                          )),
                      onTap: () {
                        setState(() {
                          isShow = !isShow;
                        });
                      }),
                ],
              )),
          new Visibility(
            visible: isShow,
            child: new Column(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 13.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text("名称", style: TextStyles.RegularGrey3TextSize12),
                      new Text("价格(USDT)",
                          style: TextStyles.RegularGrey3TextSize12)
                    ],
                  ),
                ),
                list(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget list() {
    if (widget.dataList.length == 0) {
      return Container(
        height: 40.0,
        child: new Text(
          '您当前还没有API',
          style: TextStyles.RegularGrey3TextSize12,
        ),
      );
    }

    List<Widget> tilesData = [];
    Widget contentData;
    List.generate(widget.dataList.length, (index) {
      tilesData.add(new Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: new Border(
                bottom: BorderSide(
                    color: index == widget.dataList.length - 1
                        ? Color.fromARGB(255, 255, 255, 255)
                        : UIData.border_color,
                    width: 1))),
        padding: EdgeInsets.fromLTRB(0, 18.0, 0, 18.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(widget.dataList[index]['exchange_name'],
                style: TextStyles.RegularBlackTextSize15),
            new Text(widget.dataList[index]['total_usdt'],
                style: TextStyles.RegularBlackTextSize15)
          ],
        ),
      ));
    });
    contentData = new Column(
      children: tilesData,
    );
    return contentData;
  }
}
