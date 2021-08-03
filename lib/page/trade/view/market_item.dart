import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/common/EventBus.dart';
import 'package:wq_fotune/model/ticker.dart';
import 'package:wq_fotune/page/common/CommonWidget.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/ui_data.dart';
import 'package:wq_fotune/utils/device_utils.dart';
import 'package:wq_fotune/utils/format_date.dart';

import 'market_share.dart';

class MarketItem extends StatefulWidget {
  final Map item;
  final String recommend;
  final Function press;
  final Function onTapStop;

  const MarketItem(
      {Key key, this.item, this.recommend, this.press, this.onTapStop})
      : super(key: key);

  @override
  _MarketItemState createState() => _MarketItemState();
}

class _MarketItemState extends State<MarketItem> {
  var _bus = new EventBus();
  // var lowest = "0";
  // var highest = "0";
  MarketShare _share = MarketShare();

  @override
  void initState() {
    super.initState();
    // 监听刷新行情的事件
//     _bus.on("refreshMarket", (tList) {
//       (tList as List<Ticker>)?.forEach((t) {
//         if (widget.item != null) {
//           var symbol = "${widget.item['symbol']}";
// //          print("refreshMarket === ${symbol} --- ${t.symbol}");
//           if (t.symbol.replaceAll("-", "").toLowerCase() ==
//               symbol.replaceAll("-", "").toLowerCase()) {
//             if (this.mounted) {
//               setState(() {
//                 lowest = "${t.low}";
//                 highest = "${t.last}";
// //                 highest = "${t.high}";
//               });
//             }
//           }
//         }
//       });
//     });
  }

  @override
  Widget build(BuildContext context) {
    var h = formatDateH(widget.item['startupTime']);
    return new Container(
      // padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      margin: EdgeInsets.fromLTRB(10.0, .0, 10.0, 10),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: UIData.border_color,
            blurRadius: 5.0,
            offset: Offset(0.0, 2.0),
          )
        ],
      ),
      child: new Column(
        children: <Widget>[
          new Container(
            // height: 76.0,
            padding: EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 4.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: UIData.border_color))),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Text(widget.item['name'],style: TextStyles.MediumBlackTextSize14),
                // Container(
                //   child: new Column(
                //     children: [
                //       new Container(
                //         padding: EdgeInsets.fromLTRB(13.0, 4.0, 13.0, 4.0),
                //         margin: EdgeInsets.only(bottom: 2.0),
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.all(Radius.circular(3.0)),
                //           color: UIData.red_color
                //         ),
                //         child: Text('${widget.item["rateReturn"]}%',style: TextStyles.MediumWhiteTextSize13,),
                //       ),
                //       Text('实际收益率',style: TextStyles.RegularGrey2TextSize11,)
                //     ],
                //   ),
                // ),
                Container(
                  height: 16,
                  width: 4,
                  decoration: BoxDecoration(
                    color: UIData.primary_color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                new Expanded(
                  child: Text(
                    widget.item['name'] +
                        ' & ${widget.item['exchange'].toString().toUpperCase()}',
                    style: TextStyles.MediumBlackTextSize16,
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.power_settings_new,
                      color: UIData.red_color,
                      size: 22,
                    ),
                    onPressed: () {
                      if (this.widget.onTapStop != null) {
                        this.widget.onTapStop(this.widget.item);
                      }
                    })
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "交易对 ${widget.item['symbol'].toUpperCase()}",
                  style: TextStyles.MediumBlackTextSize15,
                ),
                // new Row(
                //   children: [
                //     Image.asset('assets/images/cog@2x.png',
                //         width: 16.0, height: 16.0),
                //     Padding(padding: EdgeInsets.only(left: 2.0)),
                //     Text(
                //       '参数设置',
                //       style: TextStyles.RegularBlackTextSize14,
                //     )
                //   ],
                // )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8.0),
            padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "运行时间 ${widget.item['startupTime']}",
                  style: TextStyles.RegularGrey2TextSize12,
                ),
                Text(
                  "执行时长：${h}小时",
                  style: TextStyles.RegularGrey2TextSize12,
                ),
              ],
            ),
          ),
          buildView(),
          buildRadioView(),
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
            margin: EdgeInsets.only(top: 16.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: UIData.border_color,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Device.isWeb
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          _share.showModel(
                              context, widget.item, widget.recommend);
                          _share.shareImage();
                        },
                        child: Container(
                          width: 80.0,
                          padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: UIData.blue_color, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0))),
                          child: Text(
                            '分享',
                            style: TextStyles.RegularBlueTextSize14,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.only(left: 30),
                ),
                GestureDetector(
                  onTap: () {
                    //详情的逻辑
                    if (this.widget.press != null) {
                      this.widget.press(widget.item);
                    }
                    // if (this.widget.onTapStop != null) {
                    //   this.widget.onTapStop(this.widget.item);
                    // }
                  },
                  child: Container(
                    width: 80.0,
                    padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: UIData.blue_color, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(3.0))),
                    child: Text(
                      '查看详情',
                      style: TextStyles.RegularBlueTextSize14,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRadioView() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "投资本金",
                style: TextStyles.RegularGrey2TextSize12,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4),
              ),
              Text(
                "${widget.item["totalSum"]}",
                style: TextStyles.MediumBlackTextSize16,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              Text(
                "最低价/" + widget.item['anchorSymbol'].toUpperCase(),
                style: TextStyles.RegularGrey2TextSize12,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4),
              ),
              Text(
                widget.item['low'],
                style: TextStyles.MediumBlackTextSize16,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "年化收益率",
                style: TextStyles.RegularGrey2TextSize12,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4),
              ),
              Text(
                "${widget.item['annualReturn']}%",
                style: TextStyles.MediumBlackTextSize16,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              Text(
                "当前价格/" + widget.item['anchorSymbol'].toUpperCase(),
                style: TextStyles.RegularGrey2TextSize12,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4),
              ),
              Text(
                widget.item['last'],
                style: TextStyles.MediumBlackTextSize16,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "交易次数",
                style: TextStyles.RegularGrey2TextSize12,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4),
              ),
              Text(
                "${widget.item['tradeCount']}",
                style: TextStyles.MediumBlackTextSize16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildView() {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0),
      decoration: BoxDecoration(
          color: UIData.ImgBg_color,
          borderRadius: BorderRadius.all(Radius.circular(6.0))),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "已实现收益",
                    style: TextStyles.RegularBlackTextSize14,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),
                  ),
                  Text(
                    "${widget.item['realizedRevenue']}",
                    style: TextStyles.BoldBlueTextSize18,
                  )
                ],
              ),
            ),
            flex: 2,
          ),
          Container(
            height: 30.0,
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                        width: 1, color: UIData.three_color.withOpacity(0.6)))),
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "总利润/" + widget.item['anchorSymbol'].toUpperCase(),
                    style: TextStyles.RegularBlackTextSize14,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),
                  ),
                  Text(
                    "${widget.item["totalProfit"]}(${widget.item["rateReturn"]}%)",
                    style: TextStyles.BoldBlueTextSize18,
                  )
                ],
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  time() {
    DateTime now = new DateTime.now();
  }
}
