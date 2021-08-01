import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/utils/UIData.dart';

class marketTitle extends StatelessWidget {
  final String title;

  marketTitle(this.title);
  @override
  Widget build(BuildContext context) {
   return new Container(
     padding: EdgeInsets.fromLTRB(10.0, 10.0, 0, 10.0),
     margin: EdgeInsets.fromLTRB(0, 2.0, 0, 2.0),
     decoration: new BoxDecoration(
         borderRadius: BorderRadius.all(Radius.circular(4.0)),
         color: Colors.white,
         boxShadow: [
           BoxShadow(
             color: UIData.shadow_color,
             blurRadius: 4.0,
             offset: Offset(0.0, 3.0),
           )
         ]),
     child: new Row(
       children: <Widget>[
         new Text(
           "|  ",
           style: TextStyle(
               color: UIData.blue_color,
               fontSize: 16,
               fontWeight: FontWeight.w700),
         ),
         new Text(
           "$title",
           style: TextStyle(
               color: UIData.blck_color,
               fontSize: 14,
               fontWeight: FontWeight.w700),
         )
       ],
     ),
   );
  }

}