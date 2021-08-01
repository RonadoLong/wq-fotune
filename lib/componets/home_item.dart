import 'package:flutter/material.dart';
import 'package:wq_fotune/utils/UIData.dart';

class HomeItem extends StatelessWidget {

  final Map data;
  final Function press;

  HomeItem({Key key, this.data, this.press}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        this.press(data['id']);
      },
      child: new Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.fromLTRB(5.0, 0, 5.0, 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10), //圆角
          boxShadow: [
            BoxShadow(
                color: UIData.border_color,
                offset: Offset(0.0, 1.0), //阴影xy轴偏移量
                blurRadius: 10.0, //阴影模糊程度
                spreadRadius: 0.1 //阴影扩散程度
            )
          ],
        ),
        child: new Column(
          children: <Widget>[
            Container(
              height: 30.0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Expanded(
                    child: new Text(
                      data['name'],
                      style: TextStyle(
                        color: UIData.grey_color,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: UIData.normal_line_color,
                  ),
                ],
              ),
            ),
            Container(
              height: 60.0,
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Text(
                          "${data['rate_return']}%",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: UIData.win_color,
                          ),
                        ),
                        new Text(
                          "总收益率",
                          style: TextStyle(
                              fontSize: 13,
                              color: UIData.default_color,
                              height: 2.0),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Text(
                          "${data['rate_return_year']}%",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: UIData.win_color,
                          ),
                        ),
                        new Text(
                          "年化收益率",
                          style: TextStyle(
                              fontSize: 13,
                              color: UIData.default_color,
                              height: 2.0),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Text(
                          "${data['symbol'].toString().replaceAll("-SWAP", "")}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: UIData.win_color,
                          ),
                        ),
                        new Text(
                          "交易对",
                          style: TextStyle(
                              fontSize: 13,
                              color: UIData.default_color,
                              height: 2.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}