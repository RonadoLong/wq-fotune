import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/api/mine.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/componets/circular_load.dart';
import 'package:wq_fotune/componets/custom_btn.dart';
import 'package:wq_fotune/componets/fInput_widget.dart';
import 'package:wq_fotune/utils/ui_data.dart';
import 'package:wq_fotune/utils/toast-utils.dart';

import '../../../global.dart';

class AddApiPage extends StatefulWidget {
  int id;
  AddApiPage({this.id});

  @override
  AddApiPageState createState() => AddApiPageState();
}

class AddApiPageState extends State<AddApiPage> {
  var _ApiKeyController = new TextEditingController();
  var _SecretCodeController = new TextEditingController();
  var _passphraseCodeController = new TextEditingController();

  BuildContext ctx;
  int _value;
  List dItems;
  String exchange;

  @override
  void initState() {
    super.initState();
    _getExchangeInfo();
  }

  // 获取交易所列表
  _getExchangeInfo() async {
    MineAPI.getExchangeInfo().then((res) {
      if (res.code == 0) {
        setState(() {
          dItems = res.data;
          if (dItems.isNotEmpty) {
            this._value = dItems[0]["id"];
            // this.exchange = dItems[0]["exchange"];
            this.exchange = dItems[0]["name"];
          }
        });
      }
    });
  }

  // 添加确认
  void onTapSure(Map params, Function callBack) {
    if (params.containsKey('api_id')) {
      _exchangeOrderExchangeApiUpdate(params, callBack);
    } else {
      _exchangeOrderApiAdd(params, callBack);
    }
  }

  // 添加交易所
  void _exchangeOrderApiAdd(params, callBack) {
    MineAPI.addExchangeOrderApi(params).then((res) {
      if (res.code != 0) {
        showToast(res.msg);
      } else {
        callBack();
        showToast("添加成功");
        Navigator.of(context).pop("ApiRefresh");
      }
    });
  }

  // 更新交易所
  void _exchangeOrderExchangeApiUpdate(params, callBack) {
    MineAPI.updateExchangeOrderExchangeApi(params).then((res) {
      if (res.code != 0) {
        showToast(res.msg);
      } else {
        callBack();
        showToast("交易所修改成功");
        Navigator.of(context).pop("refresh");
//        this.loadData();
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBar(widget.id == null ? "添加API" : "修改API"),
      body: SafeArea(child: buildBody()),
    );
  }

  buildBody() {
    if (dItems == null) {
      return Center(child: CircularLoading());
    }
    return Stack(
      children: [
        SingleChildScrollView(
          child: new Padding(
            padding: new EdgeInsets.only(
                left: 30.0, top: 10.0, right: 30.0, bottom: 0.0),
            child: new Column(
              children: [
                new Container(
                  child: new Column(
                    children: <Widget>[
                      new Padding(padding: new EdgeInsets.all(8.0)),
                      headerSelect(context),
                      new Padding(padding: new EdgeInsets.all(8.0)),
                      new FInputWidget(
                        hintText: "输入apiKey",
                        onChanged: (String value) {
                          print(value);
                        },
                        controller: _ApiKeyController,
                      ),
                      new Padding(padding: new EdgeInsets.all(8.0)),
                      new FInputWidget(
                        hintText: "输入Secret",
                        onChanged: (String value) {
                          print(value);
                        },
                        controller: _SecretCodeController,
                      ),
                      new Padding(padding: new EdgeInsets.all(8.0)),
                      _showPass(),
                    ],
                  ),
                ),
                new Padding(padding: new EdgeInsets.all(30.0)),
                RoundBtn(
                  content: "导入",
                  isPositioned: false,
                  onPress: () {
                    var exchangeId = _value;
                    var apiKey = _ApiKeyController.text.trim();
                    var secret = _SecretCodeController.text.trim();
                    var passphrase = _passphraseCodeController.text.trim();
                    var params = {
                      "exchange_id": exchangeId,
                      "api_key": apiKey,
                      "secret": secret,
                      "passphrase": passphrase,
                    };

                    if (widget.id != null) {
                      // 修改状态
                      params["api_id"] = widget.id;
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
                    onTapSure(params, () {
                      _ApiKeyController.clear();
                      _SecretCodeController.clear();
                      _passphraseCodeController.clear();
                    });
                  },
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _showPass() {
    if (this.exchange != null && this.exchange.toLowerCase() == "okex") {
      return new FInputWidget(
        hintText: "输入passphrase",
        onChanged: (String value) {
          print(value);
        },
        controller: _passphraseCodeController,
      );
    }
    return Container();
  }

  Widget headerSelect(ctx) {
    double w = MediaQuery.of(ctx).size.width;
    double inputW = w - 130;
    List<DropdownMenuItem> _items = [];
    dItems.forEach((val) {
      _items.add(new DropdownMenuItem(
          child: Container(
            margin: EdgeInsets.only(left: 10.0),
            width: inputW,
            height: 48,
            child: new Row(
              children: <Widget>[
                Text(
                  // val["exchange"],
                  val['name'],
                  style: TextStyle(fontSize: 16.0, color: UIData.grey_color),
                ),
              ],
            ),
          ),
          value: val["id"]));
    });

    var dtn = DropdownButton(
      items: _items,
      underline: Container(height: 1),
      value: _value,
      isDense: true,
      iconSize: 22,
      onChanged: (T) {
        setState(() {
          this._value = T;
          for (var item in this.dItems) {
            if (item["id"] == T) {
              // this.exchange = item["exchange"];
              this.exchange = item["name"];
            }
          }
        });
      },
    );
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: Color.fromRGBO(245, 245, 245, 1),
      ),
      child: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Container(
                child: new Column(
                  children: <Widget>[
                    new Padding(padding: new EdgeInsets.all(2.0)),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        dtn,
                      ],
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
