import 'package:flutter/material.dart';
import 'package:wq_fotune/componets/flutter_k_chart/utils/date_format_util.dart';
import 'package:wq_fotune/global.dart';
import 'package:wq_fotune/page/common/CommonWidget.dart';
import 'package:wq_fotune/page/kline/kline_page.dart';
import 'package:wq_fotune/page/kline/kline_page1.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/ui_data.dart';

class HomeTicksItem extends StatefulWidget {
  final data;
  final length;
  final index;
  HomeTicksItem({Key key, this.data, this.length, this.index})
      : super(key: key);

  @override
  _HomeTicksItemState createState() => _HomeTicksItemState();
}

class _HomeTicksItemState extends State<HomeTicksItem> {
  Color _color = UIData.turquoise_color;
  var last = "0.0";

  @override
  void initState() {
    super.initState();
    // 监听刷新行情的事件
    Global.eventBus.on("refreshMarket", (tList) {
      reloadTikerData(tList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildItem(widget.data, widget.length, widget.index);
  }

  reloadTikerData(tList) {
    if (tList != null) {
      try {
        var exchange = "binance";
        var symbol = widget.data["symbol"];
        var anchorSymbol = "usdt";
        if (symbol.contains('usdt')) {
          symbol = symbol.replaceFirst('usdt', '-usdt').toUpperCase();
        } else if (symbol.contains('btc')) {
          symbol = symbol.replaceFirst('btc', '-btc').toUpperCase();
        }
        var dataMap = tList[exchange][anchorSymbol][symbol];
        // print("${widget.data} -- ${dataMap["change"]}");
        var change = dataMap["change"];
        if (this.mounted) {
          setState(() {
            last = "${dataMap["last"]}";
            // if (change != widget.data["change"]) {
            //   _color = change.toString().contains("-")
            //       ? UIData.red_color_200
            //       : UIData.win_color_200;
            // }
          });
          // handleRefreshWithDuration(() {
          //   setState(() {
          //     _color = change.toString().contains("-")
          //         ? UIData.red_color
          //         : UIData.win_color;
          //   });
          // }, Duration(milliseconds: 300));
        }
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  _buildItem(item, length, index) {
    var index = item['symbol'].indexOf("-");
    var left = item['symbol'].substring(0, index);
    var right = item['symbol'].substring(index + 1);
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
        margin: EdgeInsets.fromLTRB(0.0, 0, 5.0, 1.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: new Border(
                bottom: BorderSide(
                    color: length - 1 == index
                        ? Colors.white
                        : UIData.border_color,
                    width: 0.5))),
        child: new Column(
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: new Row(
                    children: <Widget>[
                      new Text(
                        left,
                        style: TextStyles.RegularBlackTextSize14,
                      ),
                      new Text(
                        " / ",
                        style: TextStyles.RegularGrey2TextSize12,
                      ),
                      new Text(
                        right,
                        style: TextStyles.RegularGrey2TextSize12,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      "${last}",
                      // '预期年化',
                      textAlign: TextAlign.center,
                      style: TextStyles.RegularGrey2TextSize12,
                    ),
                  ),
                ),
                AnimatedContainer(
                  width: 75.0,
                  height: 30,
                  decoration: BoxDecoration(
                    color: _color,
                    borderRadius: BorderRadius.circular(4), //圆角
                  ),
                  duration: Duration(milliseconds: 300),
                  alignment: Alignment.center,
                  child: Text(
                    '+' + item['rate_year'],
                    textAlign: TextAlign.center,
                    style: TextStyles.MediumWhiteTextSize13,
                  ),
                )
              ],
            )
          ],
        ),
      ),
      onTap: () {
        // Global.eventBus.emit('goMarket');
        var symbol = item['symbol'].toString().replaceAll("-", "");
        print("symbol: $symbol");
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new KlinePager1(symbol: symbol,)));
      },
    );
  }
}
