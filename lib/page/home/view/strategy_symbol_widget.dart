import 'package:flutter/material.dart';
import 'package:wq_fotune/utils/ui_data.dart';

class symbolList extends StatelessWidget {
  List symbol;
  symbolList({Key key, this.symbol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> tiles = [];
    Widget content;
    if (symbol == null) {
    } else {
      for (var item in symbol) {
        tiles.add(
          Container(
            margin: EdgeInsets.only(right: 20),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: UIData.border_color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: new Text(
              item,
              style: TextStyle(
                color: UIData.blck_color,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }
    }
    content = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: tiles,
      ),
    );
    return content;
  }
}
