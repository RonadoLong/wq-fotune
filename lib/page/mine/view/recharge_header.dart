import 'package:flutter/cupertino.dart';
import 'package:wq_fotune/utils/UIData.dart';

class RechargeHeader extends StatelessWidget {
  final String title;

  RechargeHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(top: 10.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 14,
              color: UIData.blue_color,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

}