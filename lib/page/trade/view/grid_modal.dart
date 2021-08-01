// ignore: avoid_web_libraries_in_flutter

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/componets/custom_btn.dart';
import 'package:wq_fotune/componets/fInput_widget.dart';
import 'package:wq_fotune/componets/loding_btn.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/UIData.dart';
import 'package:wq_fotune/api/Robot.dart';
import 'package:wq_fotune/utils/toast-utils.dart';

bool btnState = true;
var _minPriceController = new TextEditingController();
var _maxPriceController = new TextEditingController();
var _totalSumController = new TextEditingController();
var _gridNumController = new TextEditingController();
var usdtBalance = new TextEditingController();
var infiniteAiUsdtBalance = new TextEditingController();//无限网格AI总投资额
var infiniteManualUsdtBalance = new TextEditingController(); //无限网格手动总投资额
var infiniteManualMinPrice = new TextEditingController(); //无限网格手动最低价格
var infiniteManuaProfitRate = new TextEditingController();//无限网格手动每格利润
var dataManua = {}; //手动请求回来的数据
bool isManua = false;//
var currencyRight; //币本位单位
int  currencyRightInt = 1;//usdt1 btc2



var contexts;
double _sliderItemA = 100.0;
var minMoney;
var minMoneysData;
var typeData;
bool isNext = false;

Duration durationTime = Duration(seconds: 1);
Timer timer;

void showGridModal(context, calculateMoneyData, MarketAccountData, dataMap,
    isAI, minMoney, minMoneysData, type, name, infiniteAiData,Function onTapCreate) {
  double h = MediaQuery.of(context).size.height * 0.9;
  double w = MediaQuery.of(context).size.width;
  _minPriceController.clear();
  _maxPriceController.clear();
  _totalSumController.clear();
  _gridNumController.clear();
  usdtBalance.clear();
  infiniteManualUsdtBalance.clear();
  infiniteManualMinPrice.clear();
  infiniteManuaProfitRate.clear();
  infiniteAiUsdtBalance.clear();


  btnState = isAI;
  minMoney = minMoney;
  contexts = context;
  typeData = type;
  minMoneysData = minMoneysData;
  _minPriceController = TextEditingController.fromValue(TextEditingValue(
    text: calculateMoneyData['minPrice'].toString(),
  ));
  _maxPriceController = TextEditingController.fromValue(TextEditingValue(
    text: calculateMoneyData['maxPrice'].toString(),
  ));
  _totalSumController = TextEditingController.fromValue(TextEditingValue(
    text: calculateMoneyData['totalSum'].toString(),
  ));
  _gridNumController = TextEditingController.fromValue(TextEditingValue(
    text: calculateMoneyData['gridNum'].toString(),
  ));

  var indexData = dataMap['symbol'].indexOf("-");
  currencyRight = dataMap['symbol'].substring(indexData +1);
  if(currencyRight.contains('USDT')){
    currencyRightInt = 1;
  }else{
    currencyRightInt = 2;
  }
  ShapeBorder shape = const RoundedRectangleBorder(
      side: BorderSide(color: Colors.white, style: BorderStyle.solid),
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36), topRight: Radius.circular(36))
//    borderRadius: BorderRadius.all(
//      Radius.circular(36),
//    ),
      );

  double bottomH = 0;

  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    shape: shape,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
           if(bottomH == MediaQuery.of(context).viewInsets.bottom){
             return;
           }
            state((){
              bottomH = MediaQuery.of(context).viewInsets.bottom;
              print("================== $bottomH ${MediaQuery.of(context).viewInsets.bottom}");
            });
        });
        Widget creatBtn = Container(
          padding: EdgeInsets.only(top: 30.0),
          child: RoundBtn(
            content: "创建机器人",
            isPositioned: false,
            onPress: () {

              //手动策略 + 无线网格
              if(!btnState && type == 2){
                ManuaFun(dataMap, onTapCreate, context, calculateMoneyData, minMoneysData, minMoney, MarketAccountData,dataManua);
              };

              //AI策略+无限网格策略
              if(btnState && type == 2){
                infiniteAi(dataMap, onTapCreate, context, calculateMoneyData, minMoneysData, minMoney, MarketAccountData,infiniteAiData);
              };

              if (!btnState && type != 2) {
                AiTap(dataMap, onTapCreate, context, minMoney, MarketAccountData);
              } else if(btnState && type != 2){
                ManualTab(dataMap, onTapCreate, context, calculateMoneyData, minMoneysData, minMoney, MarketAccountData);
              }
            },
          ),
        );
        return Container(
          height: h,
          alignment: Alignment.topCenter,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            margin: EdgeInsets.only(top: 5),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Row(
                        children: <Widget>[
                          new Icon(Icons.grid_off, color: Colors.deepOrange),
                          new Text("   "),
                          new Text(
                            name,
                            style: TextStyles.MediumBlackTextSize14,
                          )
                        ],
                      ),
                      GestureDetector(
                          child: Image.asset(
                            'assets/images/delete-2@3x.png',
                            width: 24.0,
                            height: 24.0,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          })
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  decoration: new BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: UIData.border_color),
                    ),
                  ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Padding(padding: EdgeInsets.only(right: 20.0)),
                      GestureDetector(
                          child: new Container(
                            height: 30.0,
                            decoration: new BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: btnState
                                            ? UIData.blue_color
                                            : Colors.white))),
                            child: new Text(
                              '使用AI策略',
                              textAlign: TextAlign.center,
                              style: btnState ? TextStyles.MediumBlueTextSize14 : TextStyles.RegularGrey3TextSize14,
                            ),
                          ),
                          onTap: () {
                            state(() {
                              btnState = true;
                              _minPriceController.clear();
                              _maxPriceController.clear();
                              _totalSumController.clear();
                              _gridNumController.clear();
                              _minPriceController =
                                  TextEditingController.fromValue(
                                      TextEditingValue(
                                text: calculateMoneyData['minPrice'].toString(),
                              ));
                              _maxPriceController =
                                  TextEditingController.fromValue(
                                      TextEditingValue(
                                text: calculateMoneyData['maxPrice'].toString(),
                              ));
                              _totalSumController =
                                  TextEditingController.fromValue(
                                      TextEditingValue(
                                text: calculateMoneyData['totalSum'].toString(),
                              ));
                              _gridNumController =
                                  TextEditingController.fromValue(
                                      TextEditingValue(
                                text: calculateMoneyData['gridNum'].toString(),
                              ));
                            });
                          }),
                      new Padding(padding: EdgeInsets.only(left: 30.0)),
                      GestureDetector(
                          child: new Container(
                            height: 30.0,
                            decoration: new BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: !btnState
                                            ? UIData.blue_color
                                            : Colors.white))),
                            child: new Text(
                              '手动设置',
                              textAlign: TextAlign.center,
                              style: !btnState ? TextStyles.MediumBlueTextSize14 : TextStyles.RegularGrey3TextSize14,)
                          ),
                          onTap: () {
                            state(() {
                              btnState = false;
                              _minPriceController.clear();
                              _maxPriceController.clear();
                              _totalSumController.clear();
                              _gridNumController.clear();
                              _sliderItemA = 100.0;
                            });
                          }),
                      new Padding(padding: EdgeInsets.only(right: 20.0)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: btnState
                      ? Visibility(
                          visible: btnState,
                          child: new Container(
                            height: h - 200,
                            child: typeData == 2 ? SingleChildScrollView(
                              child: new Column(
                                children: [
                                  Padding(padding: EdgeInsets.only(top:12.0)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "最低价格(${currencyRight})  ",
                                        style: TextStyles.RegularBlackTextSize14,
                                      ),
                                      Text("${infiniteAiData['minPrice']}",
                                        style: TextStyles.RegularBlackTextSize14,
                                      )
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.only(top:12.0)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "每格利润(已扣手续费)  ",
                                        style: TextStyles.RegularBlackTextSize14,
                                      ),
                                      Text("${infiniteAiData['profitRate']}",
                                        style: TextStyles.RegularBlackTextSize14,
                                      )
                                    ],
                                  ),
                                  new Padding(padding: new EdgeInsets.all(8.0)),
                                  new FInputWidget(
                                    hintText: "总投资额",
                                    suffix: "${currencyRight}",
                                    onChanged: (String value) {
                                      timer?.cancel();
                                      timer = new Timer(durationTime, () {
                                        var balance;
                                        if(currencyRightInt == 1){
                                          balance = MarketAccountData['usdt_balance'];
                                        }else{
                                          balance = MarketAccountData['btc_balance'];
                                        }
                                        if (double.parse(value) > double.parse(balance)) {
                                          showToast('策略可用资金不足');
                                          return;
                                        }
                                        var min = infiniteAiData['minTotalSum'].toString();
                                        if (double.parse(value) < double.parse(min)) {
                                          showToast("投资额不能小于" + min.toString() + "${currencyRight}");
                                          return;
                                        }
                                      });
                                    },
                                    controller: infiniteAiUsdtBalance,
                                  ),
                                  new Padding(padding: new EdgeInsets.all(8.0)),
                                  new Row(
                                    children: <Widget>[
                                      new Text(
                                        "开启此网格单的最小投资额为${infiniteAiData['minTotalSum']}(${currencyRight})",
                                        style: TextStyles.RegularRedTextSize12,
                                      ),
                                    ],
                                  ),
                                  new Padding(padding: new EdgeInsets.all(4.0)),
                                  new Row(
                                    children: <Widget>[
                                      new Text("可用余额${currencyRightInt == 1 ? MarketAccountData['usdt_balance'] : MarketAccountData['btc_balance']}${currencyRight}",
                                        style: TextStyles.RegularBlackTextSize14,
                                      ),
                                    ],
                                  ),
                                  creatBtn,

                                ],
                              ),
                            ) :SingleChildScrollView(
                              child: new Column(
                                children: [
                                  Padding(padding: EdgeInsets.only(top:12.0)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "价格范围(${currencyRight})  ",
                                        style: TextStyles.RegularBlackTextSize14,
                                      ),
                                      Text(
                                        minMoneysData['minPrice'].toString() +
                                            " - " +
                                            minMoneysData['maxPrice']
                                                .toString(),
                                        style: TextStyles.RegularBlackTextSize14,
                                      )
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.only(top:12.0)),
                                  new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Text(
                                        "网格数量(个) ",
                                        style: TextStyles.RegularBlackTextSize14,
                                      ),
                                      new Text(
                                        minMoneysData['gridNum'].toString(),
                                        style:TextStyles.RegularBlackTextSize14,
                                      )
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.only(top:12.0)),
                                  new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Text(
                                        "策略可用资金 ",
                                        style: TextStyles.RegularBlackTextSize14,
                                      ),
                                      new Text("${currencyRightInt == 1 ? MarketAccountData['usdt_balance'] : MarketAccountData['btc_balance']}${currencyRight}",
                                        style: TextStyles.RegularBlackTextSize14,
                                      )
                                    ],
                                  ),
                                  new Padding(padding: new EdgeInsets.all(12.0)),
                                  new FInputWidget(
                                    hintText: "投入资金数",
                                    suffix: "${currencyRight}",
//                                        focusNode: _phoneFocusNode,
                                    onChanged: (String value) {
                                      timer?.cancel();
                                      timer = new Timer(durationTime, () {
                                        var balance;
                                        if(currencyRightInt == 1){
                                          balance = MarketAccountData['usdt_balance'];
                                        }else{
                                          balance = MarketAccountData['btc_balance'];
                                        }
                                        if (double.parse(value) > double.parse(balance)) {
                                          showToast('策略可用资金不足');
                                          return;
                                        }
                                        var min = minMoney.toString();
                                        if (double.parse(value) <
                                            double.parse(min)) {
                                          showToast("投资额不能小于" +
                                              minMoney.toString() +
                                              "${currencyRight}");
                                          return;
                                        }
                                        var data = {
                                          'symbol': dataMap['symbol']
                                              .replaceAll('-', '')
                                              .toLowerCase(),
                                          'exchange': dataMap['exchange'],
                                          "totalSum": value.toString()
                                        };
                                        getGridParams(data).then((res) {
                                          if (res.code == 200) {
                                            state(() {
                                              minMoneysData = res.data;
                                              isNext = true;
                                            });
                                          } else {
                                            state(() {
                                              isNext = false;
                                            });

                                            showToast(res.msg);
                                          }
                                        });
                                      });
                                    },
                                    controller: usdtBalance,
                                  ),
                                  new Padding(padding: new EdgeInsets.all(4.0)),
                                  new Row(
                                    children: <Widget>[
                                      new Text(
                                        "开启此网格单的最小投资额为" +
                                            minMoney.toString() +
                                            "(${currencyRight})",
                                        style: TextStyles.RegularRedTextSize12,
                                      ),
                                    ],
                                  ),
                                  creatBtn,
                                ],
                              ),
                            ),
                          ),
                        )
                      : Visibility(
                          visible: !btnState,
                          child: new Container(
                              height: h - 120,
                              child: typeData == 2 ? SingleChildScrollView(
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    new Text(
                                      '最低价格',
                                      style: TextStyles.RegularBlackTextSize14,
                                    ),
                                    Padding(padding: EdgeInsets.all(2.0)),
                                    new FInputWidget(
                                      hintText: "最低价格",
                                      suffix: '${currencyRight}',
                                      onChanged: (String value) {
                                        timer?.cancel();
                                        timer = new Timer(durationTime, () {
                                          _getAutoGridParams(dataMap,(callBack){
                                            state(() {
                                              dataManua = callBack;
                                            });
                                          });
                                        });
                                      },
                                      controller: infiniteManualMinPrice,
                                    ),
                                    Padding(padding: EdgeInsets.all(8.0)),
                                    new Text(
                                      "每格利润（已扣除手续费）",
                                      style: TextStyles.RegularBlackTextSize14,
                                    ),
                                    Padding(padding: EdgeInsets.all(2.0)),
                                    new FInputWidget(
                                      hintText: "每格利润(0.1% ~ 5%)",
                                      suffix: '%',
                                      onChanged: (String value) {
                                        _getAutoGridParams(dataMap,(callBack){
                                          state(() {
                                            dataManua = callBack;
                                          });
                                        });
                                      },
                                      controller: infiniteManuaProfitRate,
                                    ),
                                    Padding(padding: EdgeInsets.all(8.0)),
                                    new Text("总投资额",
                                      style: TextStyles.RegularBlackTextSize14
                                    ),
                                    Padding(padding: EdgeInsets.all(2.0)),
                                    new FInputWidget(
                                      hintText: "总投资额",
                                      suffix: '${currencyRight}',
                                      onChanged: (String value) {
                                        timer?.cancel();
                                        timer = new Timer(durationTime, () {
                                          var balance;
                                          if(currencyRightInt == 1){
                                            balance = MarketAccountData['usdt_balance'];
                                          }else{
                                            balance = MarketAccountData['btc_balance'];
                                          }
                                          if (double.parse(value) > double.parse(balance)) {
                                            showToast('策略可用资金不足');
                                            return;
                                          }
                                          var min = dataManua['minTotalSum'].toString();
                                          if (double.parse(value) < double.parse(min)) {
                                            showToast("投资额不能小于" + min.toString() + "${currencyRight}");
                                            return;
                                          }
                                        });
                                        print(value);
                                      },
                                      controller: infiniteManualUsdtBalance,
                                    ),
                                    Padding(padding: EdgeInsets.all(dataManua.isNotEmpty ? 8.0 : 0)),
                                    new Text(dataManua.isNotEmpty ? "开启此网格单的最小投资额为${dataManua['minTotalSum']}(${currencyRight})" : ' ' , style: TextStyles.RegularRedTextSize12),
                                    new Padding(padding: new EdgeInsets.all(4.0)),
                                    new Row(
                                      children: <Widget>[
                                        new Text("可用余额${currencyRightInt == 1 ? MarketAccountData['usdt_balance'] : MarketAccountData['btc_balance']}${currencyRight}",
                                          style: TextStyles.RegularBlackTextSize14,
                                        ),
                                      ],
                                    ),
                                    creatBtn,
                                    Container(
                                        height: bottomH
                                    ),

                                  ],
                                ),
                              ) : SingleChildScrollView(
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    new Text(
                                      '投入资金数',
                                      style: TextStyles.RegularBlackTextSize14,
                                    ),
                                    Padding(padding: EdgeInsets.all(4.0)),
                                    new FInputWidget(
                                      hintText: "投入资金数",
                                      suffix: '${currencyRight}',
                                      enabled: btnState ? false : true,
                                      onChanged: (String value) {
                                        print(value);
                                      },
                                      controller: _totalSumController,
                                    ),
                                    Padding(padding: EdgeInsets.all(2.0)),
                                    new Text(
                                      "策略可用资金${currencyRightInt == 1 ? MarketAccountData['usdt_balance'] : MarketAccountData['btc_balance']}${currencyRight}",
                                      style: TextStyles.RegularBlackTextSize14,
                                    ),
                                    Padding(padding: EdgeInsets.all(8.0)),
                                    Text(
                                      '网格最低价格',
                                      style: TextStyles.RegularBlackTextSize14,
                                    ),
                                    Padding(padding: EdgeInsets.all(4.0)),
                                    new FInputWidget(
                                      hintText: "网格最低价格",
                                      suffix: '${currencyRight}',
                                      enabled: btnState ? false : true,
                                      onChanged: (String value) {
//
                                      },
                                      controller: _minPriceController,
                                    ),
                                    Padding(padding: EdgeInsets.all(8.0)),
                                    Text(
                                      '网格最高价格',
                                      style: TextStyles.RegularBlackTextSize14,
                                    ),
                                    Padding(padding: EdgeInsets.all(4.0)),
                                    new FInputWidget(
                                      hintText: "网格最高价格",
                                      suffix: '${currencyRight}',
                                      enabled: btnState ? false : true,
                                      onChanged: (String value) {
//
                                      },
                                      controller: _maxPriceController,
                                    ),
                                    Padding(padding: EdgeInsets.all(8.0)),
                                    Text(
                                      '网格数量',
                                      style: TextStyles.RegularBlackTextSize14,
                                    ),
                                    Padding(padding: EdgeInsets.all(4.0)),
                                    new FInputWidget(
                                      hintText: "网格数量(5个 ~ 100个)",
                                      suffix: '个',
                                      enabled: btnState ? false : true,
                                      onChanged: (String value) {
//
                                      },
                                      controller: _gridNumController,
                                    ),
                                    creatBtn,
                                    Container(
                                      height: bottomH
                                    ),
                                  ],
                                ),
                              )),
                        ),
                ),
              ],
            ),
          ),
        );
      });
    },
  );
}

//根据最低价和利润率生成网格参数(手动无限网格使用)
void _getAutoGridParams(dataMap,callBack){
  if(infiniteManualMinPrice.text.trim().isNotEmpty && infiniteManuaProfitRate.text.trim().isNotEmpty){
    var params = {
      "exchange": dataMap['exchange'],
      "symbol": dataMap['symbol'].replaceAll('-', '').toLowerCase(),
      "isAI":false.toString(),
      "minPrice":infiniteManualMinPrice.text.trim(),
      "profitRate":infiniteManuaProfitRate.text.trim() + '%',
    };
    getAutoGridParams(false,params).then((res){
      if(res.code == 200){
        callBack(res.data);
      }else{
        showToast(res.msg);
        callBack({});

      }
    });

  }

}

//无线手动策略
void  ManuaFun(dataMap, onTapCreate, context, calculateMoneyData, minMoneysData, minMoney, MarketAccountData,dataManua){
  if(infiniteManualUsdtBalance.text.trim().isEmpty){
    showToast('投资总额不能为空');
    return;
  }else if(infiniteManualMinPrice.text.trim().isEmpty){
    showToast('最低价格不能为空');
    return;
  }else if(infiniteManuaProfitRate.text.trim().isEmpty){
    showToast('每格利润不能为空');
    return;
  }
  var usdtBalanceData = double.parse(infiniteManualUsdtBalance.text.trim());
  var min = minMoney.toString();
  var balance;
  if(currencyRightInt == 1){
    balance = MarketAccountData['usdt_balance'];
  }else{
    balance = MarketAccountData['btc_balance'];
  }
  if (usdtBalanceData > double.parse(balance)) {
    showToast('策略可用资金不足');
    return;
  }
  if (usdtBalanceData < double.parse(min)) {
    showToast("投资总额不能小于" + min + "${currencyRight}");
    return;
  }
  var params = {
    'minPrice': dataManua['minPrice'],
    'maxPrice': dataManua['maxPrice'],
    'gridNum': dataManua['gridNum'],
    'totalSum': usdtBalanceData,
    'symbol': dataMap['symbol'].replaceAll('-', '').toLowerCase(),
    'exchange': dataMap['exchange'],
    'type': typeData,
    'anchorSymbol':currencyRight
  };

  onTapCreate(params, (err) {
    Loading.dismiss(context);
    if (err == null) {
      Navigator.of(context).pop();
    }
  });


}

//无线AI策略
void infiniteAi(dataMap, onTapCreate, context, calculateMoneyData, minMoneysData, minMoney, MarketAccountData,infiniteAiData){
  if(infiniteAiUsdtBalance.text.trim() == null || infiniteAiUsdtBalance.text.trim() == ''){
    showToast('投资总额不能为空');
    return;
  }
  var usdtBalanceData = double.parse(infiniteAiUsdtBalance.text.trim());
  var min = minMoney.toString();
  var balance;
  if(currencyRightInt == 1){
    balance = MarketAccountData['usdt_balance'];
  }else{
    balance = MarketAccountData['btc_balance'];
  }
  if (usdtBalanceData > double.parse(balance)) {
    showToast('策略可用资金不足');
    return;
  }
  if (usdtBalanceData < double.parse(min)) {
    showToast("投资总额不能小于" + min + "${currencyRight}");
    return;
  }
  var params = {
    'minPrice': infiniteAiData['minPrice'],
    'maxPrice': infiniteAiData['maxPrice'],
    'gridNum': infiniteAiData['gridNum'],
    'totalSum': usdtBalanceData,
    'symbol': dataMap['symbol'].replaceAll('-', '').toLowerCase(),
    'exchange': dataMap['exchange'],
    'type': typeData,
    'anchorSymbol':currencyRight
  };

  onTapCreate(params, (err) {
    Loading.dismiss(context);
    if (err == null) {
      Navigator.of(context).pop();
    }
  });


}


void AiTap(dataMap, onTapCreate, context, minMoney, MarketAccountData) {
  if (_minPriceController.text.trim().length == 0 ||
      _maxPriceController.text.trim().length == 0 ||
      _totalSumController.text.trim().length == 0 ||
      _gridNumController.text.trim().length == 0) {
    showToast("参数不能为空");
    return;
  }
  var params = {
    'minPrice': double.parse(_minPriceController.text.trim()),
    'maxPrice': double.parse(_maxPriceController.text.trim()),
    'gridNum': int.parse(_gridNumController.text.trim()),
    'symbol': dataMap['symbol'].replaceAll('-', '').toLowerCase(),
    'exchange': dataMap['exchange'],
    "totalSum": double.parse(_totalSumController.text.trim()),
    'type': typeData,
    'anchorSymbol':currencyRight
  };
  var min = minMoney.toString();
  var balance;
  if(currencyRightInt == 1){
    balance = MarketAccountData['usdt_balance'];
  }else{
    balance = MarketAccountData['btc_balance'];
  }
  if (params['totalSum'] > double.parse(balance)) {
    showToast('策略可用资金不足');
    return;
  }

  if (params['totalSum'] < double.parse(min)) {
    showToast("投资额不能小于" + min + "${currencyRight}");
    return;
  }

  onTapCreate(params, (err) {
    Loading.dismiss(context);
    if (err == null) {
      Navigator.of(context).pop();
    }
  });
}

void ManualTab(dataMap, onTapCreate, context, calculateMoneyData, minMoneysData, minMoney, MarketAccountData) {
  if (usdtBalance.text.trim() == null || usdtBalance.text.trim() == '') {
    showToast('投入资金数不能为空');
    return;
  }
  var usdtBalanceData = double.parse(usdtBalance.text.trim());
  var min = minMoney.toString();
  var balance;
  if(currencyRightInt == 1){
    balance = MarketAccountData['usdt_balance'];
  }else{
    balance = MarketAccountData['btc_balance'];
  }
  if (usdtBalanceData > double.parse(balance)) {
    showToast('策略可用资金不足');
    return;
  }
  if (usdtBalanceData < double.parse(min)) {
    showToast("投资额不能小于" + min + "${currencyRight}");
    return;
  }

  if (!isNext) {
    showToast('AI策略计算中');
    return;
  }

  var params = {
//    'minPrice': res.data['minPrice'],
//    'maxPrice': res.data['maxPrice'],
//    'gridNum': res.data['gridNum'],
    'minPrice': minMoneysData['minPrice'],
    'maxPrice': minMoneysData['maxPrice'],
    'gridNum': minMoneysData['gridNum'],
    'totalSum': usdtBalanceData,
    'symbol': dataMap['symbol'].replaceAll('-', '').toLowerCase(),
    'exchange': dataMap['exchange'],
    'type': typeData,
    'anchorSymbol':currencyRight
  };

  onTapCreate(params, (err) {
    Loading.dismiss(context);
    if (err == null) {
      Navigator.of(context).pop();
    }
  });
}
