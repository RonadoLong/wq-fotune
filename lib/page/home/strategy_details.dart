import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wq_fotune/api/exchange.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/common/EventBus.dart';
import 'package:wq_fotune/common/NavigatorUtils.dart';
import 'package:wq_fotune/componets/circular_load.dart';
import 'package:wq_fotune/componets/custom_btn.dart';
import 'package:wq_fotune/componets/flutter_k_chart/flutter_k_chart.dart';
import 'package:wq_fotune/global.dart';
import 'package:wq_fotune/model/user_info.dart';
import 'package:wq_fotune/page/home/view/strategy_detail_modal.dart';
import 'package:wq_fotune/page/home/view/strategy_details_body.dart';
import 'package:wq_fotune/page/mine/view/del_modal_view.dart';
import 'package:wq_fotune/utils/toast-utils.dart';
import 'package:http/http.dart' as http;

class StrategyDetails extends StatefulWidget {
  final int id;

  StrategyDetails({this.id});

  @override
  StrategyDetailsState createState() => StrategyDetailsState();
}

class StrategyDetailsState extends State<StrategyDetails> {
  UserInfo userInfo;
  Map data;
  List symbol;
  List remark;
  var bus = new EventBus();
  var dataList = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0];
  List<KLineEntity> datas;
  MainState _mainState = MainState.MA;
  SecondaryState _secondaryState = SecondaryState.MACD;
  bool isLine = false;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
    _getData();
//    getData('1day');
  }

  loadUserInfo() async {
    setState(() {
      userInfo = Global.getUserInfo();
    });
  }

  _getData() async {
    ExchangeApi.getStrategyDetail(widget.id).then((res) {
      if (res.code == 0) {
        var symbolData = res.data['symbol'].split(",");
        var remarkreplace = res.data["remark"].replaceAll(" ", ",");
        var remarkData = remarkreplace.split(",");
        setState(() {
          data = res.data;
          symbol = symbolData;
          remark = remarkData;
        });
      }
    });
  }

  _postStrategy(callback, balance) {
    var params = {"id": data['id'], "balance": balance};
    ExchangeApi.createStrategy(params).then((res) {
      if (res.code != 0) {
        showToast(res.msg);
      } else {
        bus.emit("createStrategy", null);
        showToast("????????????");
        callback();
        Navigator.of(context).pop();
      }
    });
  }

  startDiaLog(context) {
    showModelDiaLog(context, "????????????", "????????????????????????API????????????", (callBack) {
      callBack();
      Navigator.pushNamed(context, '/exchange');
    });
  }

  void tapCreate() {
    if (userInfo == null) {
      //?????????????????????
      gotoLoginPage(context, route: '/strategyDetails')
          .then((value) => {loadUserInfo()});
      return;
    }
    showModal(
      context,
      (balance, callBack) {
        print("balance: $balance");
        _postStrategy(callBack, balance);
      },
    );
  }

  Future<String> getIPAddress(String period) async {
    //??????api???????????????
//    var url = 'https://api.huobi.me/trade/history/kline?period=1day&size=300&symbol=btcusdt';
    var url =
        'https://www.okex.com/api/spot/v3/instruments/BTC-USDT/candles?granularity=86400';
    String result;
    var response = await http.get(url).timeout(Duration(seconds: 7));
    if (response.statusCode == 200) {
      result = response.body;
    } else {
      return Future.error("????????????");
    }
    return result;
  }

  void getData(String period) async {
    String result;
    try {
      result = await getIPAddress('$period');
    } catch (e) {
      print('??????????????????,??????????????????');
//      result = await rootBundle.loadString('assets/kline.json');
    } finally {
      Map parseJson = json.decode(result);
      List list = parseJson['data'];
      datas = list
          .map((item) => KLineEntity.fromOKEXJson(item))
          .toList()
          .reversed
          .toList()
          .cast<KLineEntity>();
      DataUtil.calculate(datas);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildBar("??????"), body: _buildContent(context));
  }

  Widget _buildContent(context) {
    return data == null
        ? CircularLoading()
        : CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    new Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(bottom: 10.0),
                      color: Colors.white,
                      child: new Column(
                        children: <Widget>[
                          ContentTop(data: data, remark: remark),
                        ],
                      ),
                    ),
                    ContentCenter(data: data, symbol: symbol),
                    ContentBottom(data: data),
                    Padding(padding: EdgeInsets.only(top: 20)),
//                    Sparkline(
//                      data: dataList,
//                      fillMode: FillMode.below,
//                      fillColor: Colors.red[200],
//                    ),
//                    Container(
//                      height: 450,
//                      width: double.infinity,
//                      child: KChartWidget(
//                        datas, //??????
//                        isLine: isLine,
//                        //?????????????????????
//                        mainState: _mainState,
//                        //????????????????????????
//                        secondaryState: _secondaryState,
//                        //????????????????????????
//                        volState: VolState.VOL,
//                        //????????????????????????
//                        fractionDigits: 4, //??????????????????
//                      ),
//                    ),
                    RoundBtn(
                      content: "???????????????",
                      isPositioned: false,
                      onPress: () {
                        tapCreate();
                      },
                    ),
                  ],
                ),
              )
            ],
          );
  }
}
