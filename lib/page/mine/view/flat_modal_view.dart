import 'package:flutter/material.dart';
import 'package:wq_fotune/utils/ui_data.dart';

void showModelDiaLogs(context, title, content, Function onSure,
    {Widget contendView}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(
          title,
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Center(
          heightFactor: 1,
          child: contendView != null ? contendView : Text(content),
        ),
        actions: <Widget>[
          Container(
            width: 300,
            padding: EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new FlatButton(
                  child: new Text(
                    "不平仓",
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  color: Colors.black26,
                  onPressed: () {
                    onSure(false, () {
                      Navigator.of(context).pop();
                    });
//                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("平仓", style: TextStyle(color: Colors.white)),
                  color: UIData.primary_color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  onPressed: () {
                    onSure(true, () {
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ],
            ),
          )
        ],
      );
    },
  );
}

void showModelWithContentView(
  context,
  title,
  contendView,
  Function onSure,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(
          title,
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(
            color: UIData.border_color,
          ),
        ),
        content: Center(heightFactor: 1, child: contendView),
        actions: <Widget>[
          Container(
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new FlatButton(
                  child: new Text(
                    "取消",
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(color: UIData.border_color)),
                  color: Colors.black26,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("确认", style: TextStyle(color: Colors.white)),
                  color: UIData.primary_color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(color: UIData.border_color)),
                  onPressed: () {
                    onSure(() {
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ],
            ),
          )
        ],
      );
    },
  );
}
