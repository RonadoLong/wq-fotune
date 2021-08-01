import 'package:flutter/material.dart';
import 'package:wq_fotune/utils/UIData.dart';

class CustomQuoteCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String price;
  final String change;

  CustomQuoteCell(this.icon, this.label, this.price, this.change);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 15, right: 15),
      decoration: new BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: theme.dividerColor,
                width: 0.5,
                style: BorderStyle.solid)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, //纵向对齐方式：起始边对齐
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              alignment: FractionalOffset.centerLeft,
              child: Row(
                children: <Widget>[
                  new Icon(this.icon, color: UIData.primary_color),
                  new Container(
                    alignment: FractionalOffset.centerLeft,
                    margin: const EdgeInsets.only(left: 8.0),
                    child: new Text(
                      label,
                      style: new TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: UIData.normal_font_color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: new Container(
              alignment: FractionalOffset.centerRight,
              height: 56,
              margin: EdgeInsets.only(right: 10.0,bottom: 7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    price,
                    style: new TextStyle(
                      fontSize: 13.0,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    change,
                    style: new TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0,
                        color: change.indexOf("-") != -1
                            ? Colors.green
                            : Colors.red),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
