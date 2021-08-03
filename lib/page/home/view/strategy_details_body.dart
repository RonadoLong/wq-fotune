import 'package:flutter/material.dart';
import 'package:wq_fotune/utils/ui_data.dart';
import 'package:wq_fotune/page/home/view/strategy_remark_widget.dart';
import 'package:wq_fotune/page/home/view/strategy_symbol_widget.dart';

class ContentBottom extends StatelessWidget {
  const ContentBottom({
    Key key,
    @required this.data,
  }) : super(key: key);

  final Map data;

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
      margin: EdgeInsets.only(bottom: 10.0),
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.all(10.0),
            child: new Column(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(bottom: 10.0),
                  decoration: new BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: UIData.border_color, width: 1))),
                  child: new Row(
                    children: <Widget>[
                      new Text(
                        "收益情况",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: UIData.blck_color,
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Column(
                        children: <Widget>[
                          new Text(
                            data["rate_return"] + "%",
                            style: TextStyle(
                                fontSize: 17,
                                color: UIData.turquoise_color,
                                fontWeight: FontWeight.w700),
                          ),
                          new Text(
                            "历史收益率",
                            style: TextStyle(
                              fontSize: 14,
                              color: UIData.blck_color,
                            ),
                          ),
                        ],
                      ),
                      new Column(
                        children: <Widget>[
                          new Text(
                            data["rate_return_year"] + "%",
                            style: TextStyle(
                                fontSize: 17,
                                color: UIData.turquoise_color,
                                fontWeight: FontWeight.w700),
                          ),
                          new Text(
                            "历史年化率",
                            style: TextStyle(
                              fontSize: 14,
                              color: UIData.blck_color,
                            ),
                          ),
                        ],
                      ),
                      new Column(
                        children: <Widget>[
                          new Text(
                            data["rate_win"] + "%",
                            style: TextStyle(
                                fontSize: 17,
                                color: UIData.turquoise_color,
                                fontWeight: FontWeight.w700),
                          ),
                          new Text(
                            "历史胜率率",
                            style: TextStyle(
                              fontSize: 14,
                              color: UIData.blck_color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContentCenter extends StatelessWidget {
  const ContentCenter({
    Key key,
    @required this.data,
    @required this.symbol,
  }) : super(key: key);

  final Map data;
  final List symbol;

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
      margin: EdgeInsets.only(bottom: 10.0),
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.all(10.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(bottom: 10.0),
                  decoration: new BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: UIData.border_color, width: 1))),
                  child: new Row(
                    children: <Widget>[
                      new Text(
                        "支持品种",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: UIData.blck_color,
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: symbolList(symbol: symbol),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContentTop extends StatelessWidget {
  const ContentTop({
    Key key,
    @required this.data,
    @required this.remark,
  }) : super(key: key);

  final Map data;
  final List remark;

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
      child: new Column(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(bottom: 10.0),
            decoration: new BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: UIData.border_color, width: 1))),
            child: new Row(
              children: <Widget>[
                new Text(
                  data['name'],
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: UIData.blck_color,
                  ),
                ),
              ],
            ),
          ),
          new Container(
            margin: EdgeInsets.only(top: 10.0),
            child: new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Text(
                      "说明:  ",
                      style: TextStyle(
                        color: UIData.red_color,
                        fontSize: 16,
                        height: 2,
                      ),
                    ),
                  ],
                ),
                remarkList(
                  remark: remark,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
