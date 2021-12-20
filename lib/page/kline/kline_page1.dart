import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:wq_fotune/api/market.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/componets/flutter_k_chart/entity/k_line_entity.dart';
import 'package:wq_fotune/componets/flutter_k_chart/flutter_k_chart.dart';
import 'package:wq_fotune/componets/flutter_k_chart/utils/date_format_util.dart';
import 'package:wq_fotune/componets/show_sheet_model.dart';
import 'package:wq_fotune/model/kline.dart';
import 'package:wq_fotune/page/kline/data.dart';
import 'package:wq_fotune/page/mine/view/del_modal_view.dart';
import 'package:wq_fotune/utils/ui_data.dart';

import '../../global.dart';
import 'kline_widget.dart';

class KlinePager1 extends StatefulWidget {
  final String symbol;
  const KlinePager1({Key key, this.symbol}) : super(key: key);

  @override
  _KlinePager1State createState() => _KlinePager1State();
}

class _KlinePager1State extends State<KlinePager1> {
  List<KLineEntity> datas = [];
  bool showLoading = true;
  MainState _mainState = MainState.MA;
  SecondaryState _secondaryState = SecondaryState.MACD;
  bool isLine = false;
  List<DepthEntity> _bids = [], _asks = [];
  KLineEntity kLineEntity;
  bool isUp = true;
  String currentInterval = "1分";

  @override
  void initState() {
    super.initState();
    getData();
    rootBundle.loadString('assets/depth.json').then((result) {
      final parseJson = json.decode(result);
      Map tick = parseJson['tick'];
      var bids = tick['bids']
          .map((item) => DepthEntity(item[0], item[1]))
          .toList()
          .cast<DepthEntity>();
      var asks = tick['asks']
          .map((item) => DepthEntity(item[0], item[1]))
          .toList()
          .cast<DepthEntity>();
      initDepth(bids, asks);
    });
    Global.eventBus.on("refresh_kline", (arg) {
      if (arg != null && datas.length > 0) {
        Kline kline = arg as Kline;
        updateKline(kline);
      }
    });
  }

  void updateKline(Kline kline) {
    if (kline.symbol.contains(widget.symbol.toLowerCase()) &&
        kline.symbol.contains(symbols[currentInterval]) &&
        mounted) {
      setState(() {
        KLineEntity kLine = KLineEntity()
          ..close = double.tryParse(kline.data.close)
          ..open = double.tryParse(kline.data.open)
          ..high = double.tryParse(kline.data.high)
          ..low = double.tryParse(kline.data.low)
          ..amount = double.tryParse(kline.data.amount)
          ..id = int.tryParse(kline.data.time)
          ..vol = double.tryParse(kline.data.vol);
        if (datas.last.id != kLine.id) {
          DataUtil.addLastData(datas, kLine);
        } else {
          datas.last = kLine;
          DataUtil.updateLastData(datas);
        }
        isUp = kLine.close > kLineEntity.close;
        kLineEntity = kLine;
        print("$isUp-${kLine.toJson()}");
      });
    }
  }

  void initDepth(List<DepthEntity> bids, List<DepthEntity> asks) {
    if (bids == null || asks == null || bids.isEmpty || asks.isEmpty) return;
    _bids = [];
    _asks = [];
    double amount = 0.0;
    bids.sort((left, right) => left.price.compareTo(right.price));
    //倒序循环 //累加买入委托量
    bids.reversed.forEach((item) {
      amount += item.amount;
      item.amount = amount;
      _bids.insert(0, item);
    });

    amount = 0.0;
    asks.sort((left, right) => left.price.compareTo(right.price));
    //循环 //累加买入委托量
    asks.forEach((item) {
      amount += item.amount;
      item.amount = amount;
      _asks.add(item);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBar(widget.symbol ?? "BTC"),
      body: ListView(
        children: <Widget>[
          KlineHeader(
            kLineEntity: kLineEntity,
            isUp: true,
          ),
          buildTools(),
          Stack(children: <Widget>[
            Container(
              height: 450,
              width: double.infinity,
              child: KChartWidget(
                datas,
                isLine: isLine,
                mainState: _mainState,
                secondaryState: _secondaryState,
                volState: VolState.VOL,
                fractionDigits: 4,
              ),
            ),
            if (showLoading)
              Container(
                width: double.infinity,
                height: 450,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
          ]),
          Container(
            height: 230,
            width: double.infinity,
            color: Colors.white,
            child: DepthChart(_bids, _asks),
          )
        ],
      ),
    );
  }



  Widget buildTools() {
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: 2),
      padding: EdgeInsets.only(left: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  showSelect(1);
                },
                child: Row(
                  children: [
                    Text(
                      "$currentInterval",
                      style: const TextStyle(
                        color: UIData.default_color,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down_outlined,
                        color: UIData.default_color),
                  ],
                ),
              ),
              SizedBox(width: 15),
              GestureDetector(
                  onTap: () {
                    showSelect(2);
                  },
                  child: Row(
                    children: [
                      Text(
                        "指标",
                        style: const TextStyle(
                          color: UIData.default_color,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down_outlined,
                          color: UIData.default_color),
                    ],
                  )),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.fullscreen_rounded,
              color: UIData.default_color,
            ),
          )
        ],
      ),
    );
  }

  void getData() async {
    String result;
    try {
      await loadData();
    } catch (e) {
      print('获取数据失败,获取本地数据');
      result = await rootBundle.loadString('assets/kline.json');
      Map parseJson = json.decode(result);
      List list = parseJson['data'];
      datas = list
          .map((item) => KLineEntity.fromJson(item))
          .toList()
          .reversed
          .toList()
          .cast<KLineEntity>();
      DataUtil.calculate(datas);
      showLoading = false;
      setState(() {});
    }
  }

  Future loadData() async {
    MarketApi.getKline(symbol: widget.symbol, interval: symbols[currentInterval]).then((result) {
      var dataList = result.data as List<dynamic>;
      List<KLineEntity> list = [];
      dataList.forEach((item) {
        var pjson = json.decode(item);
        Kline kline = Kline.fromJson(pjson);
        KLineEntity kLineEntity = KLineEntity()
          ..close = double.tryParse(kline.data.close)
          ..open = double.tryParse(kline.data.open)
          ..high = double.tryParse(kline.data.high)
          ..low = double.tryParse(kline.data.low)
          ..amount = double.tryParse(kline.data.amount)
          ..id = int.tryParse(kline.data.time)
          ..vol = double.tryParse(kline.data.vol);
        list.add(kLineEntity);
      });
      datas = list.reversed.toList().cast<KLineEntity>();
      kLineEntity = datas.last;
      DataUtil.calculate(datas);
      showLoading = false;
      setState(() {});
    });
  }

  void selectInterval(BuildContext ctx, String val) {
    currentInterval = val;
    String symbol = "${widget.symbol.toLowerCase()}@kline_${symbols[currentInterval]}";
    print("$symbol");
    Global.eventBus.emit("selectInterval", symbol);
    getData();
    Navigator.pop(ctx);
  }

  void selectMainState(BuildContext ctx, MainState mainState) {
    if (mainState != MainState.NONE) {
      _mainState = mainState;
    } else {
      _mainState = mainState == MainState.NONE ? MainState.MA : mainState;
    }
    setState(() {});
    Navigator.pop(ctx);
  }

  void selectSecondaryState(BuildContext ctx, SecondaryState selectState) {
    if (selectState != SecondaryState.NONE) {
      _secondaryState = selectState;
    } else {
      _secondaryState = selectState == SecondaryState.NONE
          ? SecondaryState.MACD
          : selectState;
    }
    setState(() {});
    Navigator.pop(ctx);
  }

  List<Widget> buildSelectData(BuildContext ctx, int type) {
    if (type == 1) {
      List<Widget> list = [];
      symbols.forEach((key, value) {
        list.add(button(key, onPressed: () {
          selectInterval(ctx, key);
        }));
      });
      return [
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          children: list,
        )
      ];
    }
    Widget main = Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 5,
      children: <Widget>[
        button("BOLL", onPressed: () {
          selectMainState(ctx, MainState.BOLL);
        }),
        button("MA", onPressed: () {
          selectMainState(ctx, MainState.MA);
        }),
        button("隐藏", onPressed: () {
          selectMainState(ctx, MainState.NONE);
        }),
      ],
    );

    Widget second = Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 5,
      children: <Widget>[
        button("MACD", onPressed: () {
          selectSecondaryState(ctx, SecondaryState.MACD);
        }),
        button("KDJ", onPressed: () {
          selectSecondaryState(ctx, SecondaryState.KDJ);
        }),
        button("RSI", onPressed: () {
          selectSecondaryState(ctx, SecondaryState.RSI);
        }),
        button("WR", onPressed: () {
          selectSecondaryState(ctx, SecondaryState.WR);
        }),
        button("隐藏", onPressed: () {
          selectSecondaryState(ctx, SecondaryState.NONE);
        }),
      ],
    );
    return [
      Text(
        "主视图:",
        style: const TextStyle(
          color: UIData.default_color,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      main,
      SizedBox(height: 15),
      Text(
        "副视图:",
        style: const TextStyle(
          color: UIData.default_color,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      Container(child: second),
    ];
  }


  void showSelect(int type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<Widget> contentList = buildSelectData(context, type);
        return AlertDialog(
          contentPadding: EdgeInsets.only(
            top: 20.0,
            bottom: 20,
            left: 10,
            right: 10,
          ),
          insetPadding: EdgeInsets.only(left: 10, right: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: UIData.border_color,
            ),
          ),
          content: Container(
            width: double.maxFinite,
            height: 230,
            alignment: Alignment.center,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: contentList,
              ),
            ),
          ),
        );
      },
    );
  }
}
