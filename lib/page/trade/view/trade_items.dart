import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/common/EventBus.dart';
import 'package:wq_fotune/utils/ui_data.dart';

class TradeItems extends StatefulWidget {
  final Function changeTap;
  final Map data;

  const TradeItems({Key key, this.changeTap, this.data}) : super(key: key);

  @override
  _TradeItemsState createState() => _TradeItemsState();
}

class _TradeItemsState extends State<TradeItems> {
  Color _bgColor = Colors.white;
  var bus = EventBus();
  @override
  void initState() {
    super.initState();
    _listenColor();
  }

  _listenColor() {
    bus.on("TradeItemsChangeDefault", (symbol) {
      if (symbol == widget.data["symbol"]) {
        return;
      }
      setState(() {
        _bgColor = Colors.white;
      });
    });
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  widget.data['symbol'],
                  style: TextStyle(
                    color: UIData.default_color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.data['price'],
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: UIData.default_color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.data['change'],
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: widget.data['change'].contains("-")
                        ? UIData.red_color
                        : UIData.win_color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      onTap: () {
        setState(() {
          _bgColor = _bgColor == UIData.border_color
              ? Colors.white
              : UIData.border_color;
        });
        widget.changeTap(widget.data);
        bus.emit("TradeItemsChangeDefault", widget.data["symbol"]);
      },
    );
  }
}
