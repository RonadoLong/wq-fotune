import 'package:flutter/material.dart';
import 'package:wq_fotune/utils/UIData.dart';

class remarkList extends StatelessWidget{
  List remark;
  remarkList({Key key, this.remark}) : super(key: key);

  @override
  Widget build(BuildContext context){
    List<Widget> tiles = [];
    Widget content;
    if (remark != null) {
      for (int i = 0; i < remark.length; i++) {
        var index = i + 1;
        tiles.add(
            new Row(
              children: <Widget>[
                new Text(
                  "   " + "$index " + ". " + remark[i],
                  style: TextStyle(
                    color: UIData.red_color,
                    fontSize: 14,
                    height: 2,
                  ),
                ),
              ],
            )
        );
      }
    }
    content = new Column(children: tiles);
    return content;
  }
}