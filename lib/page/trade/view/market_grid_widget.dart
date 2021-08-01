import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/UIData.dart';

class MarketGridWidget extends StatefulWidget {
  final data;

  const MarketGridWidget({Key key,this.data}) : super(key: key);
  @override
  _MarketGridWidgetState createState() => _MarketGridWidgetState();
}

class _MarketGridWidgetState extends State<MarketGridWidget>{

  @override
  Widget build(BuildContext context){
    return gridWidget();
  }

  Widget quotationWidget(){
    List<Widget> tilesData = [];
    Widget contentData;
    widget.data['labels'].forEach((item){
      tilesData.add(
          new Container(
            padding: EdgeInsets.fromLTRB(6, 4, 6, 4),
            margin: EdgeInsets.all(2.0),
            decoration: new BoxDecoration(
                borderRadius:
                BorderRadius.all(Radius.circular(4.0)),
                color: UIData.border_color,
                boxShadow: [
                  BoxShadow(
                    color: UIData.border_color,
                    blurRadius: 20.0,
                    offset: Offset(1.0, 1.0),
                  )
                ]),
            child: new Text(
              item,
              style: TextStyles.RegularGrey2TextSize12,
            ),
          )
      );
    });
    contentData = new Row(
      children: tilesData,
    );
    return contentData;
  }

  Widget gridWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
      margin: EdgeInsets.fromLTRB(5, 6.0, 5, 0),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: UIData.border_color,
              blurRadius: 10.0,
              offset: Offset(1.0, 1.0),
            )
          ]),
      child: new Row(
        children: <Widget>[
          new Container(
            child: new Column(
              children: <Widget>[
                new Icon(Icons.grid_off, color: Colors.deepOrange, size: 18,),
                new Text(" "),
                new Text(" "),
                new Text(" "),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(2.0)),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Text(
                      widget.data['name'],
                      style:TextStyles.MediumBlackTextSize16,
                    )
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                      child: new Row(
                        children: <Widget>[
                          new Text(
                            "适用行情：",
                            style: TextStyles.MediumBlackTextSize14,
                          ),
                          quotationWidget()
                        ],
                      ),
                    ),
                    new Icon(
                      Icons.arrow_forward_ios,
                      color: UIData.default_color,
                    )
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Text(
                      widget.data['describe'],
                      style: TextStyles.RegularGrey2TextSize12,
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

}