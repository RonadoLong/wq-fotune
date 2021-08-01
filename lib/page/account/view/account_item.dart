import 'package:flutter/material.dart';
import 'package:wq_fotune/common/EventBus.dart';
import 'package:wq_fotune/model/account.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/UIData.dart';

class AccountItems extends StatefulWidget {
  final Function changeTap;
  final Balance_detail data;

  const AccountItems({Key key, this.changeTap, this.data}) : super(key: key);

  @override
  _AccountItemsState createState() => _AccountItemsState();
}

class _AccountItemsState extends State<AccountItems> {
  Color _bgColor = Colors.white;
  var bus = EventBus();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.fromLTRB(10.0, 20, 10, 20),
        margin: EdgeInsets.fromLTRB(5.0, 0, 5.0, 1.0),
        decoration: BoxDecoration(
          color: _bgColor,
          border: new Border(
            bottom: BorderSide(color: UIData.border_color, width: 0.5),
          ),
        ),
        child: new Column(
          children: <Widget>[
            new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: [
                      Container(
                        width: 85,
                        child: Text(
                          widget.data.symbol,
                          style: TextStyles.RegularBlackTextSize14,
                        ),
                      ),
                      Container(
                        width: 140,
                        child: Text(
                          widget.data.balance,
                          textAlign: TextAlign.left,
                          style: TextStyles.RegularBlackTextSize14,
                        ),
                      ),
                    ],
                  ),
                ),
               Text(
                  widget.data.price,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyles.RegularRedTextSize14,
                ),
              ],
            )
          ],
        ),
      ),
      onTap: () {},
    );
  }
}
