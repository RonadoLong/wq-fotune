import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/utils/ui_data.dart';
import 'package:wq_fotune/page/mine/view/transfer_usdt.dart';

class IfcWalletView extends StatefulWidget {
  @override
  final data;
  IfcWalletView({Key key, this.data}) : super(key: key);
  IfcWalletViewState createState() => IfcWalletViewState();
}

class IfcWalletViewState extends State<IfcWalletView> {
  @override
  Widget build(BuildContext context) {
    ShapeBorder shape = const RoundedRectangleBorder(
        side: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(4)));
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Container(
            width: size.width,
            height: 196.0,
            child: Image.asset("assets/images/wallet_ifc.webp",
                fit: BoxFit.cover)),
        Positioned(
          top: 0,
          left: 0,
          width: size.width,
          height: 196.0,
          child: Container(
            margin: EdgeInsets.fromLTRB(30, 16, 30, 20),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Text(
                      widget.data['symbol'].toUpperCase() + ' 钱包',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                new Padding(padding: new EdgeInsets.only(top: 16.0)),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      '总余额:',
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                    ),
                    new Text(
                      widget.data['total'] +
                          "  " +
                          widget.data['symbol'].toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                    ),
                  ],
                ),
                new Padding(padding: new EdgeInsets.only(top: 10.0)),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      '可用余额:',
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                    ),
                    new Text(
                      widget.data['available'] +
                          "  " +
                          widget.data['symbol'].toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                    ),
                  ],
                ),
                new Padding(padding: new EdgeInsets.only(top: 5.0)),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    MaterialButton(
                      minWidth: 80.0,
                      height: 36.0,
                      textColor: Colors.white,
                      shape: shape,
                      child: new Text(
                        '划转',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new TransferUsdt()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
//   return Container(
//     child: new Column(
//       children: <Widget>[
//         new Container(
//          margin: EdgeInsets.only(top:10.0),
//           padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
//           decoration: BoxDecoration(
////             borderRadius: BorderRadius.circular(8),
//             image: DecorationImage(
//               image: AssetImage('assets/images/wallet_ifc.webp'),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: new Column(
//             children: <Widget>[
//               new Padding(padding: new EdgeInsets.only(top: 16.0)),
//               new Row(
//                 children: <Widget>[
//                   new Text(widget.data['symbol'].toUpperCase() + ' 钱包',style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 14.0,
//                     fontWeight: FontWeight.w500
//                   ),),
//                 ],
//               ),
//               new Padding(padding: new EdgeInsets.only(top: 16.0)),
//               new Row(
//                   mainAxisAlignment:MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                   new Text('总余额:',style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14.0
//                   ),),
//                   new Text(widget.data['total'] + "  " +  widget.data['symbol'].toUpperCase(),style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14.0
//                   ),),
//                 ],
//               ),
//               new Padding(padding: new EdgeInsets.only(top: 10.0)),
//               new Row(
//                 mainAxisAlignment:MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   new Text('可用余额:',style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14.0
//                   ),),
//                   new Text(widget.data['available'] + "  " + widget.data['symbol'].toUpperCase(),style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14.0
//                   ),),
//                 ],
//               ),
//               new Padding(padding: new EdgeInsets.only(top: 10.0)),
//               new Row(
//                 mainAxisAlignment:MainAxisAlignment.end,
//                 children: <Widget>[
//                   MaterialButton(
//                     minWidth: 80.0,
//                     height: 36.0,
////                     color: Colors.white,
//                     textColor: Colors.white,
//                     shape: shape,
//                     child: new Text(
//                       '划转',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.white
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         new MaterialPageRoute(builder: (context) => new TransferUsdt()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               new Padding(padding: new EdgeInsets.only(top: 12.0)),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
  }
}
