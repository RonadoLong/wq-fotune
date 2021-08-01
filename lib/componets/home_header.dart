import 'package:flutter/cupertino.dart';
import 'package:wq_fotune/utils/UIData.dart';

class HomeHeader extends StatelessWidget {
  final String title;

  HomeHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 8.0),
      padding: EdgeInsets.only(top: 10.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: UIData.blue_color,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
