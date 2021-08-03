import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/page/mine/view/recharge_usdt.dart';
import 'package:wq_fotune/page/mine/view/reflect_usdt.dart';
import 'package:wq_fotune/page/mine/view/transfer_usdt.dart';

class UsdtWalletView extends StatefulWidget {
  @override
  final data;
  UsdtWalletView({Key key, this.data}) : super(key: key);
  UsdtWalletViewState createState() => UsdtWalletViewState();
}

class UsdtWalletViewState extends State<UsdtWalletView> {
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
            child: Image.asset("assets/images/wallet_usdt.webp",
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MaterialButton(
                      minWidth: 80.0,
                      height: 36.0,
//                      color: Colors.white,
                      textColor: Colors.white,
                      shape: shape,
                      child: new Text(
                        '充值' + widget.data['symbol'].toUpperCase(),
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new RechargeUsdt()),
                        );
                      },
                    ),
                    MaterialButton(
                      minWidth: 80.0,
                      height: 36.0,
//                      color: Colors.white,
                      textColor: Colors.white,
                      shape: shape,
                      child: new Text(
                        '提现' + widget.data['symbol'].toUpperCase(),
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new ReflectUsdt()),
                        );
                      },
                    ),
                    MaterialButton(
                      minWidth: 80.0,
                      height: 36.0,
//                      color: Colors.white,
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
  }
}
