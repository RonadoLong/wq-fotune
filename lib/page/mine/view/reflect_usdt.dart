import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/componets/custom_btn.dart';
import 'package:wq_fotune/componets/wallet_flnput_widget.dart';
import 'package:wq_fotune/api/mine.dart';
import 'package:wq_fotune/utils/toast-utils.dart';

class ReflectUsdt extends StatefulWidget {
  @override
  ReflectUsdtState createState() => ReflectUsdtState();
}

class ReflectUsdtState extends State<ReflectUsdt> {
  @override
  var _addressController = new TextEditingController();
  var _volumeController = new TextEditingController();
  bool isBtn = true;

  void initState() {
    super.initState();
    _addressController.clear();
    _volumeController.clear();
  }

  void _postWalletWithdrawal() async {
    if (_addressController.text.trim() == '') {
      showToast("提现地址不能为空");
      return;
    }
    if (_volumeController.text.trim() == "") {
      showToast("提现数量");
      return;
    }

    if (!isBtn) {
      showToast("操作过于频繁，请稍后再试");
      return;
    }

    var params = {
      "coin": "USDT",
      "address": _addressController.text.trim(),
      "volume": _volumeController.text.trim()
    };
    setState(() {
      isBtn = false;
    });
    MineAPI.postWalletWithdrawal(params).then((res) {
      setState(() {
        isBtn = true;
      });
      if (res.code == 0) {
        showToast("提交审核中");
        Navigator.pop(context);
      } else {
        showToast(res.msg);
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBar("提现USDT"),
      body: buildBody(),
    );
  }

  buildBody() {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: <Widget>[
        new Column(
          children: <Widget>[
            new Padding(padding: new EdgeInsets.only(top: 8.0)),
            new WalletFInputWidget(
              hintText: "请输入提现地址",
              isNumber: true,
              onChanged: (String value) {
                print(value);
              },
              controller: _addressController,
            ),
            new Padding(padding: new EdgeInsets.all(4.0)),
            new Row(
              children: <Widget>[
                new Text(
                  "   支持erc20,请确认后输入，地址错误概不负责",
                  style: TextStyle(
                      color: Color.fromRGBO(102, 102, 102, 1), fontSize: 12.0),
                ),
              ],
            ),
            new Padding(padding: new EdgeInsets.all(10.0)),
            new Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 3,
                    child: new Text(
                      "   提现数量",
                      style: TextStyle(
                          color: Color.fromRGBO(51, 51, 51, 1), fontSize: 14.0),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: new WalletFInputWidget(
                      hintText: "请输入数量",
                      isNumber: true,
                      onChanged: (String value) {
                        print(value);
                      },
                      controller: _volumeController,
                    ),
                  ),
                ],
              ),
            ),
            new Padding(padding: new EdgeInsets.all(4.0)),
          ],
        ),
        RoundBtn(
          content: "确认提现",
          onPress: () {
            _postWalletWithdrawal();
          },
        )
      ],
    );
  }
}
