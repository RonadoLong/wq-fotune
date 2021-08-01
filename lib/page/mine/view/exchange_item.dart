import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/format_date.dart';
import 'package:wq_fotune/utils/UIData.dart';

class ExchangeItem extends StatelessWidget {
  final Map item;
  final Function onTap;

  const ExchangeItem(this.item, this.onTap);

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.fromLTRB(6.0, 10.0, 6.0, 10.0),
        margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: UIData.shadow_color,
                blurRadius: 10.0,
                offset: Offset(0.0, 2.0),
              )
            ]),
        child: new GestureDetector(
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Image.asset(
                  'assets/images/Exchange.png',
                  height: 40,
                ),
                margin: EdgeInsets.only(top: 10),
              ),
              new Expanded(
                child: new Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.only(bottom: 10.0),
//                        decoration: new BoxDecoration(
//                          border: Border(
//                            bottom: BorderSide(
//                              color: UIData.border_color,
//                            ),
//                          ),
//                        ),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text(
                                  "${item["exchange_name"]}".toUpperCase(),
                                  style: TextStyles.SemiboldBlackTextSize14,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: UIData.two_color,
                                )
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(top: 6)),
                            new Text(
                              "API: ${item["api_key"]}",
                              maxLines: 2,
                              style: TextStyles.RegularGrey2TextSize13,
                            ),
                            Padding(padding: EdgeInsets.only(top:6.0)),
                            new Text(
                              "时间：" + formatDateToString(item['created_at']),
                              style: TextStyles.RegularGrey2TextSize13,
                            )
                          ],
                        ),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new MaterialButton(
                            minWidth: 80.0,
                            height: 30.0,
                            color: UIData.blue_color,
                            textColor: UIData.default_color,
                            child: new Text(
                              '修改',
                              style: TextStyles.MediumWhiteTextSize13,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side:
                                    BorderSide(color: UIData.blue_color)),
                            onPressed: () {
                              this.onTap(1);
                            },
                          ),
                          new Padding(padding: EdgeInsets.only(left: 30.0)),
                          new MaterialButton(
                            minWidth: 80.0,
                            height: 30.0,
                            color: UIData.red_color,
                            textColor: UIData.default_color,
                            child: new Text(
                              '删除',
                              style: TextStyles.MediumWhiteTextSize13,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: UIData.red_color)),
                            onPressed: () {
                              this.onTap(2);
                            },
                          ),
                          new Padding(padding: EdgeInsets.only(right: 20.0)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            this.onTap(0);
          },
        ));
  }
}
