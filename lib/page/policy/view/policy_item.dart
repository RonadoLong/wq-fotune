import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/UIData.dart';

import '../policy_detail.dart';

class PolicyItem extends StatefulWidget {
  final data;
  final length;
  final index;
  final Function onPress;

  PolicyItem({Key key, this.data, this.length, this.index, this.onPress})
      : super(key: key);

  @override
  PolicyItemState createState() => PolicyItemState();
}

class PolicyItemState extends State<PolicyItem> {
  @override
  Widget build(BuildContext context) {
    return _buildItem(widget.data, widget.length, widget.index);
  }

  _buildItem(item, length, index) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
        margin: EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
          color: UIData.white_color,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: UIData.border_color,
              blurRadius: 5.0,
              offset: Offset(0.0, 2.0),
            )
          ],
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 16.0, 0, 14.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedContainer(
                        width: 68.0,
                        height: 24,
                        decoration: BoxDecoration(
                          color: UIData.red_color,
                          borderRadius: BorderRadius.circular(4), //圆角
                        ),
                        duration: Duration(milliseconds: 300),
                        alignment: Alignment.center,
                        child: Text(
                          '+${item['rateYear'] != null ? item['rateYear'] : "120%"}',
                          textAlign: TextAlign.center,
                          style: TextStyles.MediumWhiteTextSize13,
                        ),
                      ),
                      SizedBox(height: 7,),
                      Text(
                        'AI预测年化',
                        style: TextStyles.RegularGrey2TextSize13,
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(left: 22.0)),
                  new Expanded(
                      flex: 3,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'],
                            style: TextStyles.MediumBlackTextSize16,
                          ),
                          SizedBox(height: 4,),
                          quotationWidget()
                        ],
                      )),
                  new Expanded(
                    flex: 2,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${item["runCount"]}人使用',
                          style: TextStyles.RegularGrey3TextSize14,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: size.width,
              padding: EdgeInsets.fromLTRB(0, 12.0, 0, 12.0),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1, color: UIData.border_color),
                ),
              ),
              child: Text(
                item['describe'],
                style: TextStyles.RegularGrey2TextSize14,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        widget.onPress();
      },
    );
  }

  Widget quotationWidget() {
    List<Widget> tilesData = [];
    Widget contentData;
    widget.data['labels'].forEach((item) {
      tilesData.add(
        Container(
          padding: EdgeInsets.all(4.0),
          margin: EdgeInsets.only(right: 6.0),
          decoration: BoxDecoration(
            color: UIData.border_color,
            borderRadius: BorderRadius.circular(3.0),
          ),
          child: Text(
            item,
            style: TextStyles.RegularGrey2TextSize12,
          ),
        ),
      );
    });
    contentData = new Row(
      children: tilesData,
    );
    return contentData;
  }
}
