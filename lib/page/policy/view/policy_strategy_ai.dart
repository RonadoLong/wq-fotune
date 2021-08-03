import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:wq_fotune/api/robot.dart';
import 'package:wq_fotune/componets/custom_btn.dart';
import 'package:wq_fotune/componets/fInput_widget.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/toast-utils.dart';

class policyAi extends StatefulWidget {
  final dataMap;
  final minMoney;
  final calculateMoneyData;
  final MarketAccountData;
  final type;
  final infiniteAiData;
  final Function callBack;

  policyAi(
      {this.dataMap,
      this.minMoney,
      this.calculateMoneyData,
      this.MarketAccountData,
      this.type,
      this.infiniteAiData,
      this.callBack});

  @override
  policyAiState createState() => policyAiState();
}

class policyAiState extends State<policyAi> {
  var _minPriceController = new TextEditingController();
  var _maxPriceController = new TextEditingController();
  var _totalSumController = new TextEditingController();
  var _gridNumController = new TextEditingController();
  Map minMoneysData;

  Duration durationTime = Duration(seconds: 1);
  Timer timer;

  int currencyRightInt = 1; //usdt1 btc2
  String currency; //币本位单位
  String availableBalance; //可用余额

  bool isNext = false;

  void initState() {
    super.initState();
    if (widget.type == 2 && widget.infiniteAiData != null) {
      _minPriceController = TextEditingController.fromValue(TextEditingValue(
        text: widget.infiniteAiData['minPrice'].toString(),
      ));
      //每格利润
      _gridNumController = TextEditingController.fromValue(TextEditingValue(
        text: widget.infiniteAiData['profitRate'].toString(),
      ));
    } else if (widget.calculateMoneyData != null) {
      //初始化设置默认值
      _minPriceController = TextEditingController.fromValue(TextEditingValue(
        text: widget.calculateMoneyData['minPrice'].toString(),
      ));
      _maxPriceController = TextEditingController.fromValue(TextEditingValue(
        text: widget.calculateMoneyData['maxPrice'].toString(),
      ));
      _gridNumController = TextEditingController.fromValue(TextEditingValue(
        text: widget.calculateMoneyData['gridNum'].toString(),
      ));
    }

    var indexData = widget.dataMap['symbol'].indexOf("-");
    var currencyRight = widget.dataMap['symbol'].substring(indexData + 1);
    if (currencyRight.contains('USDT')) {
      currencyRightInt = 1;
      currency = 'USDT';
      availableBalance = widget.MarketAccountData['usdt_balance'];
    } else {
      currencyRightInt = 2;
      currency = 'BTC';
      availableBalance = widget.MarketAccountData['btc_balance'];
    }
  }

  void infiniteAi() {
    if (_gridNumController.text.trim() == null ||
        _gridNumController.text.trim() == '') {
      showToast('投入金额不能为空');
      return;
    }
    var usdtBalanceData = double.parse(_totalSumController.text.trim());
    var min = widget.infiniteAiData['minTotalSum'].toString();

    if (usdtBalanceData > double.parse(availableBalance)) {
      showToast('策略可用资金不足');
      return;
    }
    if (usdtBalanceData < double.parse(min)) {
      showToast("投资总额不能小于" + min + "${currency}");
      return;
    }
    var params = {
      'minPrice': widget.infiniteAiData['minPrice'],
      'maxPrice': widget.infiniteAiData['maxPrice'],
      'gridNum': widget.infiniteAiData['gridNum'],
      'totalSum': usdtBalanceData,
      'symbol': widget.dataMap['symbol'].replaceAll('-', '').toLowerCase(),
      'exchange': widget.dataMap['exchange_name'],
      'type': widget.type,
      'anchorSymbol': currency,
      "apiKey": widget.dataMap['api_key'],
      "uid": widget.dataMap['uid'],
    };
    widget.callBack(params);
  }

  void Ai() {
    if (_totalSumController.text.trim() == null ||
        _totalSumController.text.trim() == '') {
      showToast('投入资金数不能为空');
      return;
    }
    var usdtBalanceData = double.parse(_totalSumController.text.trim());
    var min = widget.minMoney.toString();
    if (usdtBalanceData > double.parse(availableBalance)) {
      showToast('策略可用资金不足');
      return;
    }
    if (usdtBalanceData < double.parse(min)) {
      showToast("投资额不能小于" + min + "${currency}");
      return;
    }

    if (!isNext) {
      showToast('AI策略计算中');
      return;
    }

    var params = {
      'minPrice': minMoneysData['minPrice'],
      'maxPrice': minMoneysData['maxPrice'],
      'gridNum': minMoneysData['gridNum'],
      'totalSum': usdtBalanceData,
      'symbol': widget.dataMap['symbol'].replaceAll('-', '').toLowerCase(),
      'exchange': widget.dataMap['exchange_name'],
      'type': widget.type,
      'anchorSymbol': currency.toLowerCase(),
      "apiKey": widget.dataMap['api_key'],
      "uid": widget.dataMap['uid'],
    };
    widget.callBack(params);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == 2) {
      return Stack(
        children: [
          SingleChildScrollView(
              child: new Padding(
                  padding: new EdgeInsets.only(top: 8.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new Padding(padding: new EdgeInsets.all(6.0)),
                      new Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: new Container(
                              margin: EdgeInsets.only(right: 8.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  new Text('区间最低价格',
                                      style: TextStyles.RegularBlackTextSize14),
                                  new Padding(padding: new EdgeInsets.all(4.0)),
                                  new FInputWidget(
                                    hintText: "区间最低价格",
                                    suffix: currency,
                                    enabled: false,
                                    onChanged: (String value) {
                                      print(value);
                                    },
                                    controller: _minPriceController,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      new Padding(padding: new EdgeInsets.all(10.0)),
                      new Text('每格利润(已扣除手续费)',
                          style: TextStyles.RegularBlackTextSize14),
                      new Padding(padding: new EdgeInsets.all(4.0)),
                      new FInputWidget(
                        hintText: "每格利润",
                        suffix: "%",
                        enabled: false,
                        onChanged: (String value) {},
                        controller: _gridNumController,
                      ),
                      new Padding(padding: new EdgeInsets.all(10.0)),
                      new Text('投入金额',
                          style: TextStyles.RegularBlackTextSize14),
                      new Padding(padding: new EdgeInsets.all(4.0)),
                      new FInputWidget(
                        hintText: "投入金额",
                        suffix: currency,
                        onChanged: (String value) {
                          timer?.cancel();
                          timer = new Timer(durationTime, () {
                            if (double.parse(value) >
                                double.parse(availableBalance)) {
                              showToast('策略可用资金不足');
                              return;
                            }
                            var min =
                                widget.infiniteAiData['minTotalSum'].toString();
                            if (double.parse(value) < double.parse(min)) {
                              showToast("投资额不能小于${min}${currency}");
                              return;
                            }
                          });
                        },
                        controller: _totalSumController,
                      ),
                      new Padding(padding: new EdgeInsets.all(4.0)),
                      new Text(
                          "开启此网格单的最小投资额为${widget.infiniteAiData['minTotalSum']}${currency}",
                          style: TextStyles.RegularRedTextSize14),
                      new Padding(padding: new EdgeInsets.all(4.0)),
                      new Text("可用余额${availableBalance}${currency}",
                          style: TextStyles.RegularBlackTextSize14),
                      new Padding(padding: new EdgeInsets.all(20.0)),
                      RoundBtn(
                        content: '创建机器人',
                        isPositioned: false,
                        onPress: () {
                          infiniteAi();
                        },
                      )
                    ],
                  )))
        ],
      );
    } else {
      return Stack(
        children: [
          SingleChildScrollView(
              child: new Padding(
                  padding: new EdgeInsets.only(top: 8.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new Padding(padding: new EdgeInsets.all(8.0)),
                      new Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: new Container(
                              margin: EdgeInsets.only(right: 8.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  new Text('区间最低价格',
                                      style: TextStyles.RegularBlackTextSize14),
                                  new Padding(padding: new EdgeInsets.all(4.0)),
                                  new FInputWidget(
                                    hintText: "区间最低价格",
                                    suffix: currency,
                                    enabled: false,
                                    onChanged: (String value) {
                                      print(value);
                                    },
                                    controller: _minPriceController,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: new Container(
                              margin: EdgeInsets.only(left: 8.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  new Text('区间最高价格',
                                      style: TextStyles.RegularBlackTextSize14),
                                  new Padding(padding: new EdgeInsets.all(4.0)),
                                  new FInputWidget(
                                    hintText: "区间最高价格",
                                    suffix: currency,
                                    enabled: false,
                                    onChanged: (String value) {
                                      print(value);
                                    },
                                    controller: _maxPriceController,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      new Padding(padding: new EdgeInsets.all(10.0)),
                      new Text('网格数量',
                          style: TextStyles.RegularBlackTextSize14),
                      new Padding(padding: new EdgeInsets.all(4.0)),
                      new FInputWidget(
                        hintText: "网格数量",
                        suffix: "个",
                        enabled: false,
                        onChanged: (String value) {},
                        controller: _gridNumController,
                      ),
                      new Padding(padding: new EdgeInsets.all(8.0)),
                      new Text(
                        '平均每格利润：${widget.calculateMoneyData['averageProfitRate']}',
                        style: TextStyles.RegularBlackTextSize14,
                      ),
                      new Padding(padding: new EdgeInsets.all(10.0)),
                      new Text('投入金额',
                          style: TextStyles.RegularBlackTextSize14),
                      new Padding(padding: new EdgeInsets.all(4.0)),
                      new FInputWidget(
                        hintText: "投入金额",
                        suffix: currency,
                        onChanged: (String value) {
                          timer?.cancel();
                          timer = new Timer(durationTime, () {
                            if (double.parse(value) >
                                double.parse(availableBalance)) {
                              showToast('策略可用资金不足');
                              return;
                            }
                            var min = widget.minMoney.toString();
                            print('min${min}');
                            if (double.parse(value) < double.parse(min)) {
                              showToast("投资额不能小于${widget.minMoney}${currency}");
                              return;
                            }
                            var data = {
                              'symbol': widget.dataMap['symbol']
                                  .replaceAll('-', '')
                                  .toLowerCase(),
                              'exchange': widget.dataMap['exchange_name'],
                              "totalSum": value.toString()
                            };
                            getGridParams(data).then((res) {
                              if (res.code == 200) {
                                setState(() {
                                  minMoneysData = res.data;
                                  isNext = true;
                                });
                              } else {
                                setState(() {
                                  isNext = true;
                                });
                                showToast(res.msg);
                              }
                            });
                          });
                        },
                        controller: _totalSumController,
                      ),
                      new Padding(padding: new EdgeInsets.all(4.0)),
                      new Text("开启此网格单的最小投资额为${widget.minMoney}${currency}",
                          style: TextStyles.RegularRedTextSize14),
                      new Padding(padding: new EdgeInsets.all(4.0)),
                      new Text(
                        "可用余额${availableBalance}${currency}",
                        style: TextStyles.RegularBlackTextSize14,
                      ),
                      new Padding(padding: new EdgeInsets.all(20.0)),
                      RoundBtn(
                        content: '创建机器人',
                        isPositioned: false,
                        onPress: () {
                          Ai();
                        },
                      )
                    ],
                  )))
        ],
      );
    }
  }
}
