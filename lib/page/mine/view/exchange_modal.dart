import 'package:flutter/material.dart';
import 'package:wq_fotune/componets/fInput_widget.dart';
import 'package:wq_fotune/componets/popup_input.dart';
import 'package:wq_fotune/utils/toast-utils.dart';
import 'package:wq_fotune/utils/UIData.dart';

class ExchangeModel {
  var _ApiKeyController = new TextEditingController();
  var _SecretCodeController = new TextEditingController();
  var _passphraseCodeController = new TextEditingController();

  BuildContext ctx;
  int _value = 1;
  List dItems;
  Function onSure;

  ExchangeModel({this.ctx, this.dItems, this.onSure});

  void showExchangeAddOrUpdateDiaLog({dynamic item}) {
    double w = MediaQuery.of(ctx).size.width;
    double inputW = w - 80;
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, state) {
            List<DropdownMenuItem> _items = [];
            dItems.forEach((val) {
              _items.add(new DropdownMenuItem(
                  child: Container(
                    width: inputW - 100,
                    height: 22,
                    child: Text(val["exchange"],),
                  ),
                  value: val["id"]));
            });
            var dtn = DropdownButton(
              items: _items,
              underline:
                  Container(height: 1, color: Colors.green.withOpacity(0.7)),
              value: _value,
              isDense: true, iconSize: 30,
              onChanged: (T) {
                state(() {
                  this._value = T;
                });
              },
            );

            return AlertDialog(
              title: new Text(
                "绑定交易所",
                textAlign: TextAlign.center,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                  side: BorderSide(color: UIData.border_color)),
              scrollable: true,
              insetPadding: EdgeInsets.all(10),
              content: Container(
                width: w - 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Padding(padding: new EdgeInsets.all(10.0)),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        dtn,
                      ],
                    ),
                    Padding(padding: new EdgeInsets.all(10.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          width: inputW,
                          child: FInputWidget(
                            hintText: "输入apiKey",
                            onChanged: (String value) {
                              print(value);
                            },
                            controller: _ApiKeyController,
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: new EdgeInsets.all(10.0)),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: inputW,
                          child: new PopupInputWidget(
                            hintText: "输入Secret",
                            onChanged: (String value) {
                              print(value);
                            },
                            controller: _SecretCodeController,
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: new EdgeInsets.all(10.0)),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: inputW,
                          child: new PopupInputWidget(
                            hintText: "输入passphrase",
                            onChanged: (String value) {
                              print(value);
                            },
                            controller: _passphraseCodeController,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Container(
                  width: w - 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        child: Container(
                          width: 80,
                          child: Text(
                            "取消",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                            side: BorderSide(color: UIData.border_color)),
                        color: Colors.black26,
                        onPressed: () {
                          _ApiKeyController.clear();
                          _SecretCodeController.clear();
                          _passphraseCodeController.clear();
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Container(
                          width: 80,
                          child: Text(
                            "导入",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        color: UIData.primary_color,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                            side: BorderSide(color: UIData.border_color)),
                        onPressed: () {
                          var exchangeId = _value;
                          var apiKey = _ApiKeyController.text.trim();
                          var secret = _SecretCodeController.text.trim();
                          var passphrase =
                              _passphraseCodeController.text.trim();
                          var params = {
                            "exchange_id": exchangeId,
                            "api_key": apiKey,
                            "secret": secret,
                            "passphrase": passphrase,
                          };
                          if (item != null) {
                            // 修改状态
                            params["api_id"] = item["id"];
                            if (apiKey.length == 0 &&
                                secret.length == 0 &&
                                passphrase.length == 0) {
                              showToast("请填写完整的信息");
                              return;
                            }
                          } else {
                            if (apiKey.length == 0 || secret.length == 0) {
                              showToast("请填写完整的信息");
                              return;
                            }
                          }
                          onSure(params, () {
                            _ApiKeyController.clear();
                            _SecretCodeController.clear();
                            _passphraseCodeController.clear();
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
      },
    );
  }
}
