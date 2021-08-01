import 'package:flutter/material.dart';
import 'package:wq_fotune/common/EventBus.dart';
import 'package:wq_fotune/model/ticker.dart';
import 'package:wq_fotune/page/common/CommonWidget.dart';
import 'package:wq_fotune/page/trade/market_page.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/UIData.dart';

class HomeTicksItem extends StatefulWidget {
  final data;
  final length;
  final index;
  HomeTicksItem({Key key, this.data,this.length,this.index}) : super(key: key);

  @override
  _HomeTicksItemState createState() => _HomeTicksItemState();
}

class _HomeTicksItemState extends State<HomeTicksItem> {
  Color _color = UIData.turquoise_color;
  var _bus = new EventBus();

  @override
  void initState() {
    super.initState();
    // 监听刷新行情的事件
    // _bus.on("refreshMarket", (tList) {
    //   if (tList != null) {
    //     try {
    //         for (Ticker t in tList) {
    //           if (t.symbol == widget.data.symbol) {
    //             setState(() {
    //               if (t.change != widget.data.change) {
    //                 _color = t.change.toString().contains("-")
    //                     ? UIData.red_color_200
    //                     : UIData.win_color_200;
    //               }
    //             });
    //             handleRefreshWithDuration(() {
    //               setState(() {
    //                 _color = t.change.toString().contains("-")
    //                     ? UIData.red_color
    //                     : UIData.win_color;
    //               });
    //             }, Duration(milliseconds: 300));
    //             break;
    //           }
    //         }
    //     }catch(e) {
    //
    //     }
    //   }
    //   (tList as List<Ticker>)?.forEach((t) {
    //
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return _buildItem(widget.data,widget.length,widget.index);
  }

  _buildItem(item,length,index) {
    var index = item['symbol'].indexOf("-");
    var left = item['symbol'].substring(0,index);
    var right = item['symbol'].substring(index +1);
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.fromLTRB(0,10.0,0,10.0),
        margin: EdgeInsets.fromLTRB(0.0, 0, 5.0, 1.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: new Border(
                bottom: BorderSide(color: length - 1 == index ? Colors.white : UIData.border_color, width: 0.5))
        ),
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
//                 Expanded(
//                   child: Container(
//                     child: Text(
// //                    "${item.last}",
//                       '预期年化',
//                       textAlign: TextAlign.center,
//                       style: TextStyles.RegularGrey2TextSize12,
//                     ),
//                   ),
//                 ),
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
                    '+' + item['rateYear'],
                    textAlign: TextAlign.center,
                    style: TextStyles.MediumWhiteTextSize13,
                  ),
                )
              ],
            )
          ],
        ),
      ),
      onTap: (){
        _bus.emit('goMarket');
      },
    );
  }
}
