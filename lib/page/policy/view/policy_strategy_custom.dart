
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:wq_fotune/api/Robot.dart';
import 'package:wq_fotune/common/common.dart';
import 'package:wq_fotune/componets/custom_btn.dart';
import 'package:wq_fotune/componets/fInput_widget.dart';
import 'package:wq_fotune/page/trade/view/grid_modal.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/toast-utils.dart';

class PolicyCustom extends StatefulWidget {
  final dataMap;
  final minMoney;
  final marketAccountData;
  final type;
  final infiniteAiData;
  final Function callBack;
  PolicyCustom({this.dataMap,this.minMoney,this.marketAccountData,this.type,this.infiniteAiData,this.callBack});

  @override
  PolicyCustomState createState() => PolicyCustomState();
}
class PolicyCustomState extends State<PolicyCustom>{
  var _minPriceController = new TextEditingController();
  var _maxPriceController = new TextEditingController();
  var _totalSumController = new TextEditingController();
  var _gridNumController = new TextEditingController();


  int  currencyRightInt = 1;//usdt1 btc2
  String currency; //币本位单位
  String availableBalance;//可用余额

  var dataManua = {}; //手动请求回来的数据

  @override

  void initState() {
    super.initState();


    var indexData = widget.dataMap['symbol'].indexOf("-");
    var currencyRight = widget.dataMap['symbol'].substring(indexData +1);
    if(currencyRight.contains('USDT')){
      currencyRightInt = 1;
      currency = 'USDT';
      availableBalance = widget.marketAccountData['usdt_balance'];
    }else{
      currencyRightInt = 2;
      currency = 'BTC';
      availableBalance = widget.marketAccountData['btc_balance'];
    }



  }

  void custom(){
    if (_minPriceController.text.trim().length == 0 || _maxPriceController.text.trim().length == 0 || _totalSumController.text.trim().length == 0 || _gridNumController.text.trim().length == 0) {
      showToast("参数不能为空");
      return;
    }
    var params = {
      'minPrice': double.parse(_minPriceController.text.trim()),
      'maxPrice': double.parse(_maxPriceController.text.trim()),
      'gridNum': int.parse(_gridNumController.text.trim()),
      "totalSum": double.parse(_totalSumController.text.trim()),
      'symbol': widget.dataMap['symbol'].replaceAll('-', '').toLowerCase(),
      'exchange': widget.dataMap['exchange_name'],
      'type': widget.type,
      'anchorSymbol':currency,
      "apiKey": widget.dataMap['api_key'],
      "uid": widget.dataMap['uid'],
    };
    var min = widget.minMoney.toString();
    var balance;
    if(currencyRightInt == 1){
      balance = widget.marketAccountData['usdt_balance'];
    }else{
      balance = widget.marketAccountData['btc_balance'];
    }
    if (params['totalSum'] > double.parse(balance)) {
      showToast('策略可用资金不足');
      return;
    }

    if (params['totalSum'] < double.parse(min)) {
      showToast("投资额不能小于" + min + "${currency}");
      return;
    }
    print(params);
    widget.callBack(params);
  }

  void infiniteCustom(){
    if(_totalSumController.text.trim().isEmpty){
      showToast('投资总额不能为空');
      return;
    }else if(_minPriceController.text.trim().isEmpty){
      showToast('最低价格不能为空');
      return;
    }else if(_gridNumController.text.trim().isEmpty){
      showToast('每格利润不能为空');
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
      'minPrice': dataManua['minPrice'],
      'maxPrice': dataManua['maxPrice'],
      'gridNum': dataManua['gridNum'],
      'totalSum': usdtBalanceData,
      'symbol': widget.dataMap['symbol'].replaceAll('-', '').toLowerCase(),
      'exchange': widget.dataMap['exchange_name'],
      'type': widget.type,
      'anchorSymbol':currency,
      "apiKey": widget.dataMap['api_key'],
      "uid": widget.dataMap['uid'],
    };
    print(params);
    widget.callBack(params);
  }

  //根据最低价和利润率生成网格参数(手动无限网格使用)
  void _getAutoGridParams(){
    if(_minPriceController.text.trim().isNotEmpty && _gridNumController.text.trim().isNotEmpty){
      var params = {
        "exchange": widget.dataMap['exchange_name'],
        "symbol": widget.dataMap['symbol'].replaceAll('-', '').toLowerCase(),
        "isAI":false.toString(),
        "minPrice":_minPriceController.text.trim(),
        "profitRate":_gridNumController.text.trim() + '%',
      };
      getAutoGridParams(false,params).then((res){
        if(res.code == 200){
          setState(() {
            dataManua = res.data;
          });
          // callBack(res.data);
        }else{
          showToast(res.msg);
          dataManua = {};
        }
      });

    }

  }

  Widget build(BuildContext context) {
    if(widget.type == 2){
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
                                  new Text('区间最低价格',style: TextStyles.RegularBlackTextSize14),
                                  new Padding(padding: new EdgeInsets.all(4.0)),
                                  new FInputWidget(
                                    hintText: "区间最低价格",
                                    suffix: currency,
                                    onChanged: (String value) {
                                      timer?.cancel();
                                      timer = new Timer(durationTime, () {
                                        _getAutoGridParams();
                                      });
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
                            ),
                          )
                        ],
                      ),
                      new Padding(padding: new EdgeInsets.all(10.0)),
                      new Text('每格利润(已扣除手续费)',style: TextStyles.RegularBlackTextSize14),
                      new Padding(padding: new EdgeInsets.all(4.0)),
                      new FInputWidget(
                        hintText: "每格利润(0.1% ~ 5%)",
                        suffix: "%",
                        onChanged: (String value) {
                          timer?.cancel();
                          timer = new Timer(durationTime, () {
                            _getAutoGridParams();
                          });
                        },
                        controller: _gridNumController,
                      ),
                      new Padding(padding: new EdgeInsets.all(10.0)),
                      new Text('投入金额',style: TextStyles.RegularBlackTextSize14),
                      new Padding(padding: new EdgeInsets.all(4.0)),
                      new FInputWidget(
                        hintText: "投入金额",
                        suffix: currency,
                        onChanged: (String value) {
                          timer?.cancel();
                          timer = new Timer(durationTime, () {
                            if (double.parse(value) > double.parse(availableBalance)) {
                              showToast('策略可用资金不足');
                              return;
                            }
                            var min = widget.infiniteAiData['minTotalSum'].toString();
                            if (double.parse(value) < double.parse(min)) {
                              showToast("投资额不能小于" + min.toString() + "${currencyRight}");
                              return;
                            }
                          });
                        },
                        controller: _totalSumController,
                      ),
                      new Padding(padding: new EdgeInsets.all(4.0)),
                      new Text("可用余额${availableBalance}${currency}", style: TextStyles.RegularBlackTextSize14),
                      new Padding(padding: new EdgeInsets.all(20.0)),
                      RoundBtn(
                        content: '创建机器人',
                        isPositioned: false,
                        onPress: () {
                          infiniteCustom();
                        },
                      )
                    ],
                  )
              )
          )
        ],
      );
    }else{
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
                                  new Text('区间最低价格',style: TextStyles.RegularBlackTextSize14),
                                  new Padding(padding: new EdgeInsets.all(4.0)),
                                  new FInputWidget(
                                    hintText: "区间最低价格",
                                    suffix: currency,
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
                                  new Text('区间最高价格',style: TextStyles.RegularBlackTextSize14),
                                  new Padding(padding: new EdgeInsets.all(4.0)),
                                  new FInputWidget(
                                    hintText: "区间最高价格",
                                    suffix: currency,
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
                      new Text('网格数量',style: TextStyles.RegularBlackTextSize14),
                      new Padding(padding: new EdgeInsets.all(4.0)),
                      new FInputWidget(
                        hintText: "网格数量(5个 ~ 100个)",
                        suffix: "个",
                        onChanged: (String value) {

                        },
                        controller: _gridNumController,
                      ),
                      new Padding(padding: new EdgeInsets.all(4.0)),
                      new Text('每格利润：0.32%-0.37%',style: TextStyles.RegularGrey3TextSize12,),
                      new Padding(padding: new EdgeInsets.all(10.0)),
                      new Text('投入金额',style: TextStyles.RegularBlackTextSize14),
                      new Padding(padding: new EdgeInsets.all(4.0)),
                      new FInputWidget(
                        hintText: "投入金额",
                        suffix: currency,
                        onChanged: (String value) {

                        },
                        controller: _totalSumController,
                      ),
                      new Padding(padding: new EdgeInsets.all(4.0)),
                      new Text("可用余额${availableBalance}${currency}", style: TextStyles.RegularBlackTextSize14),
                      new Padding(padding: new EdgeInsets.all(20.0)),
                      RoundBtn(
                        content: '创建机器人',
                        isPositioned: false,
                        onPress: () {
                          custom();
                        },
                      )
                    ],
                  )
              )
          )
        ],
      );
    }

  }

}