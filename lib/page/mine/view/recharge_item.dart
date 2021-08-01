
import 'package:flutter/material.dart';
import 'package:wq_fotune/utils/UIData.dart';

class RechargeItem extends StatelessWidget{
  final List data;
  final bool check;
  RechargeItem({Key key, this.data,this.check});


  @override
  Widget build(BuildContext context){
    List<Widget> tiles = [];
    Widget content;
    for (var item in data){
      tiles.add(
        new Container(
          height: 74.0,
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(
              top: 10.0
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              border: new Border(
                  bottom: BorderSide(
                      color: UIData.border_color, width: 1)
              )
          ),
          child: new Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Checkbox(
                value:check,
                activeColor: UIData.blue_color,
                onChanged: (bool val) {
//              this.setState(() {
//                this.check = !this.check;
//              });
                },
              ),
              new Container(
                child: new Column(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(item['name'],style:TextStyle(
                      color: UIData.grey_color,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    )),
                    new Text("  原价：" + item['old_price'].toString(),style:TextStyle(
                      color: UIData.grey_color,
                      fontSize: 12,
                    ))
                  ],
                ),
              ),
              new Container(
                child: new Column(
                  mainAxisAlignment:MainAxisAlignment.end,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment:MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        new Text("现价:",style:TextStyle(
                          color: UIData.grey_color,
                          fontSize: 12,
                        )),
                        new Text(item['price'].toString(),style:TextStyle(
                          color: UIData.red_color,
                          fontSize: 12,
                        ))
                      ],
                    )
                  ],

                ),
              ),
              new Container(
                child: new Column(
                  mainAxisAlignment:MainAxisAlignment.end,
                  children: <Widget>[
                    new Text("有效期："+ item['duration'].toString()  +"个月",style:TextStyle(
                      color: UIData.grey_color,
                      fontSize: 12,
                    ))
                  ],
                ),
              )
            ],
          ),

        )
      );
    }
    content = new Column(
      children: tiles,
    );
    return content;
  }

}