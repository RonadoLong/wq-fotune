import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wq_fotune/api/recharge.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/componets/fInput_widget.dart';
import 'package:wq_fotune/componets/circular_load.dart';
import 'package:wq_fotune/componets/custom_btn.dart';
import 'package:wq_fotune/page/common/CommonWidget.dart';
import 'package:wq_fotune/page/mine/view/recharge_header.dart';
import 'package:wq_fotune/page/mine/view/recharge_item.dart';
import 'package:wq_fotune/utils/ui_data.dart';
import 'package:wq_fotune/utils/toast-utils.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class RechargePage extends StatefulWidget {
  @override
  RechargePageState createState() => RechargePageState();
}

class RechargePageState extends State<RechargePage> {
  EasyRefreshController _controller = EasyRefreshController();
  var _userNameController = new TextEditingController();
  List dataList;
  Map paymentMethodsMap;
  List dItems = [
    {"id": 1, "name": "USDT"},
    {"id": 2, "name": "支付宝"},
    {"id": 3, "name": "微信"},
  ];
  int _value = 1;

  @override
  void initState() {
    super.initState();
    getMembers();
    getPaymentMethods();
  }

  void getMembers() {
    RechargeApi.members().then((res) {
      if (res.code == 0) {
        setState(() {
          dataList = res.data;
        });
      } else {
        setState(() {
          dataList = [];
        });
      }
    });
  }

  void getPaymentMethods() {
    RechargeApi.paymentMethods().then((res) {
      if (res.code == 0) {
        setState(() {
          paymentMethodsMap = res.data[0];
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBar("充值会员"),
      body: buildBody(),
    );
  }

  buildBody() {
    if (dataList == null || paymentMethodsMap == null) {
      return CircularLoading();
    } else {
      return SingleChildScrollView(
        child: Column(
          children: [
            RechargeHeader("会员套餐"),
            RechargeItem(data: dataList, check: false),
            RechargeHeader('支付方式'),
            selectView(context),
            addressView(),
            tipView(),
            btnView()
          ],
        ),
      );
    }
  }

  Widget buildContent(context, index) {
    if (dataList.length == 0) {
      return buildEmptyView();
    }

    if (index == 0) {
      return RechargeHeader("会员套餐");
    }

    if (index == 1) {
      return RechargeHeader("支付方式");
    }
    if (index == 2) {
      return selectView(context);
    }
    if (index == 3) {
      return addressView();
    }

    if (index == 4) {
      return tipView();
    }
    if (index == 5) {
      return btnView();
    }
    if (dataList.length != 0) {
      return RechargeItem(data: dataList[index - 6], check: false);
    }
  }

  Widget selectView(ctx) {
    List<DropdownMenuItem> _items = [];
    double w = MediaQuery.of(ctx).size.width;
    double inputW = w - 70;
    dItems.forEach((val) {
      _items.add(new DropdownMenuItem(
          child: Container(
            margin: EdgeInsets.only(left: 10.0),
            width: inputW,
            height: 48,
            child: Text(
              val["name"],
            ),
          ),
          value: val["id"]));
    });
    var dtn = DropdownButton(
      items: _items,
      underline: Container(height: 1),
      value: _value,
      isDense: true,
      iconSize: 30,
      onChanged: (T) {
        setState(() {
          this._value = T;
        });
      },
    );
    return new Container(
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: new Border.all(color: UIData.border_color, width: 1),
      ),
      child: new Column(
        children: <Widget>[
          new Padding(padding: new EdgeInsets.all(10.0)),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              dtn,
            ],
          ),
        ],
      ),
    );
  }

  Widget addressView() {
    return new Container(
      margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: new Border.all(color: UIData.border_color, width: 1),
      ),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Text(
                paymentMethodsMap['name'] +
                    " / " +
                    paymentMethodsMap['BitAddr'],
                style: TextStyle(
                  fontSize: 14,
                  color: UIData.grey_color,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new MaterialButton(
                child: new Text(
                  '复制地址',
                  style: TextStyle(
                      fontSize: 12,
                      color: UIData.blue_color,
                      fontWeight: FontWeight.w700),
                ),
                onPressed: () {
                  ClipboardData data = new ClipboardData(
                      text: paymentMethodsMap['BitAddr'] != null
                          ? paymentMethodsMap['BitAddr']
                          : '');
                  Clipboard.setData(data);
                  showToast("复制成功");
                },
              ),
              new MaterialButton(
                child: new Text(
                  '查看二维码',
                  style: TextStyle(
                      fontSize: 12,
                      color: UIData.blue_color,
                      fontWeight: FontWeight.w700),
                ),
                onPressed: () {
                  showDialog<Null>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return new AlertDialog(
                        content: new SingleChildScrollView(
                          child: new ListBody(
                            children: <Widget>[
                              Image.network(paymentMethodsMap['BitCode'])
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text(
                              '确定',
                              style: TextStyle(color: UIData.blue_color),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  ).then((val) {
                    print(val);
                  });
                },
              ),
            ],
          ),
          new Container(
            child: new FInputWidget(
              hintText: "请输入您的支付地址",
              isNumber: true,
              onChanged: (String value) {
                print(value);
              },
              controller: _userNameController,
            ),
          )
        ],
      ),
    );
  }

  Widget tipView() {
    return new Container(
      margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: new Border.all(color: UIData.border_color, width: 1),
      ),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            "温馨提示：",
            style: TextStyle(
              fontSize: 12,
              color: UIData.grey_color,
              fontWeight: FontWeight.w700,
            ),
          ),
          new Padding(padding: new EdgeInsets.all(3.0)),
          new Text(
            "请确认只能把USDT转入该地址，如果把其他币导致丢失，不会赔付。支付成功后请联系客服。",
            style: TextStyle(fontSize: 12, color: UIData.red_color),
          )
        ],
      ),
    );
  }

  Widget btnView() {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      child: RoundBtn(
        content: '确认支付',
        isPositioned: false,
        onPress: () {},
      ),
    );
  }
}
