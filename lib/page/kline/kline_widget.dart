import 'package:flutter/material.dart';
import 'package:wq_fotune/componets/flutter_k_chart/entity/k_line_entity.dart';
import 'package:wq_fotune/componets/show_sheet_model.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/ui_data.dart';

class KlineHeader extends StatefulWidget {
  final KLineEntity kLineEntity;
  final bool isUp;

  KlineHeader({Key key, this.kLineEntity, this.isUp}) : super(key: key);

  @override
  State<KlineHeader> createState() => _KlineHeaderState();
}

class _KlineHeaderState extends State<KlineHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      buildTitle(),
      buildPrice(),
    ]);
  }

  // @override
  // void didUpdateWidget(KlineHeader oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.kLineEntity != null && widget.kLineEntity != null) {
  //     print("${oldWidget.kLineEntity.close}, ${widget.kLineEntity.close}");
  //   }
  // }

  Widget buildTitle() {
    return Container(
      margin: EdgeInsets.only(top: 4, bottom: 2),
      padding: EdgeInsets.only(left: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "BTC永续",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text("/USDT   binance"),
            ],
          ),
          Row(children: [
            IconButton(
              onPressed: () {},
              padding: const EdgeInsets.all(4.0),
              icon: Icon(
                Icons.notifications_active_outlined,
                color: UIData.default_color.withOpacity(0.7),
              ),
            ),
            IconButton(
              onPressed: () {},
              padding: const EdgeInsets.all(4.0),
              icon: Icon(
                Icons.star_border,
                color: UIData.default_color.withOpacity(0.7),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget buildPrice() {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text("${widget.kLineEntity?.close ?? "47001.99"}",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: widget.isUp ? UIData.win_color : UIData.red_color)),
            Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: widget.isUp
                    ? Icon(Icons.arrow_upward_sharp,
                        size: 15, color: UIData.win_color)
                    : Icon(Icons.arrow_downward_sharp,
                        size: 15, color: UIData.red_color)),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                '${widget.kLineEntity != null ? ((widget.kLineEntity.close - widget.kLineEntity.open) / widget.kLineEntity.open * 100).toStringAsFixed(2) : "2.16"}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: UIData.red_color,
                ),
              ),
            ),
          ]),
          SizedBox(height: 10),
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "指数价格",
                    style: TextStyles.RegularGrey2TextSize12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),
                  ),
                  Text(
                    "47001.99",
                    style: TextStyles.RegularGrey2TextSize12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Text(
                    "溢价率",
                    style: TextStyles.RegularGrey2TextSize12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),
                  ),
                  Text(
                    "0.01%",
                    style: TextStyles.RegularGrey2TextSize12,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "持仓量",
                    style: TextStyles.RegularGrey2TextSize12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),
                  ),
                  Text(
                    "11万BTC",
                    style: TextStyles.RegularGrey2TextSize12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Text(
                    "持仓位",
                    style: TextStyles.RegularGrey2TextSize12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 2),
                  ),
                  Text(
                    "￥120.28亿",
                    style: TextStyles.RegularGrey2TextSize12,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "24H高",
                    style: TextStyles.RegularGrey2TextSize12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),
                  ),
                  Text(
                    "46888",
                    style: TextStyles.RegularGrey2TextSize12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Text(
                    "24H低",
                    style: TextStyles.RegularGrey2TextSize12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),
                  ),
                  Text(
                    "40001.11",
                    style: TextStyles.RegularGrey2TextSize12,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "24H量",
                    style: TextStyles.RegularGrey2TextSize12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),
                  ),
                  Text(
                    "46888",
                    style: TextStyles.RegularGrey2TextSize12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Text(
                    "24H额",
                    style: TextStyles.RegularGrey2TextSize12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),
                  ),
                  Text(
                    "￥1210.28亿",
                    style: TextStyles.RegularGrey2TextSize12,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}


Widget button(String text, {VoidCallback onPressed}) {
  return TextButton(
    onPressed: () {
      if (onPressed != null) {
        onPressed();
      }
    },
    child: Text("$text", style: const TextStyle(color: Colors.white)),
    style: TextButton.styleFrom(
      backgroundColor: Colors.blue.withOpacity(0.8),
    ),
  );
}