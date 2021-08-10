import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:wq_fotune/api/robot.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/componets/circular_load.dart';
import 'package:wq_fotune/componets/refresh.dart';
import 'package:wq_fotune/page/trade/market_parameters.dart';
import 'package:wq_fotune/res/styles.dart';

import '../../utils/ui_data.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class TransactionDetails extends StatefulWidget {
  String id;

  TransactionDetails({this.id});

  @override
  State<StatefulWidget> createState() => new TransactionDetailsState();
}

class TransactionDetailsState extends State<TransactionDetails> {
  EasyRefreshController _controller;
  String strategyId;
  @protected
  int pageNum = 1;
  int pageSize = 10;
  bool isShowMore = false;
  bool loading = false;
  List dataList;
  Map detailData;
  List buyListData;
  List sellListData;
  Map<DateTime, double> data = {};
  List dItems = [
    {"value": 0, "name": "参数"}
  ];
  int _value;

  @override
  void initState() {
    _controller = EasyRefreshController();
    super.initState();
    loadData();
  }

  loadData() async {
    RobotApi.getStrategyDetails(widget.id).then((res) {
      print('res$res');
      if (res.code == 200) {
        setState(() {
          detailData = res.data['strategyDetail'];
          buyListData = detailData['commissionBuyOrders'];
          sellListData = detailData['commissionSellOrders'];
          if (detailData['evaDailyList'] != null) {
            List evaDailyList = detailData['evaDailyList'];
            Map<DateTime, double> evaDaily = {};
            if (evaDailyList.length > 0) {
              var fData = evaDailyList[0];
              var date =
                  DateTime.parse(fData["date"]).subtract(Duration(days: 1));
              evaDaily[date] = 0.0;
            }
            evaDailyList.forEach((element) {
              var date = DateTime.parse(element["date"]);
              evaDaily[date] = double.parse(element["profit_daily"]);
            });
            data = evaDaily;
            print(data);
          }
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBar("交易详情", actions: [
        Builder(
          builder: (context) {
            return PopupMenuButton<String>(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Container(
                      child: Icon(Icons.settings, color: UIData.blue_color)),
                ),
                itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                      PopupMenuItem<String>(value: '0', child: Text('参数')),
                    ],
                onSelected: (String value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new MarketParameters(
                              id: widget.id,
                              isRun: detailData['isRun'],
                              anchorSymbol:
                                  detailData['anchorSymbol'].toUpperCase())));
                });
          },
        ),
      ]),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (detailData == null) {
      return CircularLoading();
    } else {
      return CommonRefresh(
        controller: _controller,
        sliverList: SliverList(
          delegate: SliverChildListDelegate(
            [
              gridHeader(),
              dataWidget(),
              diagramWidget(),
              buildChart(),
              businessWidget()
            ],
          ),
        ),
        onRefresh: () {
          loadData();
          _controller.resetLoadState();
        },
      );
    }
  }

  Widget gridHeader() {
    return new Container(
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                detailData['name'],
                style: TextStyles.MediumBlackTextSize16,
              ),
              new Text(
                detailData['isRun'] ? "执行中" : "已停止",
                style: TextStyles.MediumBlueTextSize12,
              )
            ],
          ),
          new Padding(padding: new EdgeInsets.all(6.0)),
          new Row(
            children: <Widget>[
              Text(
                detailData['exchange'].toString().toUpperCase(),
                style: TextStyles.MediumBlackTextSize14,
              ),
              Text(
                " · ",
                style: TextStyles.MediumBlackTextSize14,
              ),
              Text(
                detailData['symbol'].toUpperCase(),
                style: TextStyles.MediumBlackTextSize14,
              )
            ],
          ),
          new Padding(padding: new EdgeInsets.all(4.0)),
          Container(
            child: Text(
              detailData['startupTime'],
              style: TextStyles.RegularGrey3TextSize12,
            ),
          )
        ],
      ),
    );
  }

  Widget realizedRevenueView(String realizedRevenue) {
    return realizedRevenue.contains("-")
        ? new Text(
            detailData['realizedRevenue'],
            style: TextStyle(
                color: UIData.red_color,
                fontSize: 20.0,
                fontWeight: FontWeight.w700),
          )
        : new Text(
            "+" + detailData['realizedRevenue'],
            style: TextStyle(
                color: UIData.red_color,
                fontSize: 20.0,
                fontWeight: FontWeight.w700),
          );
  }

  Widget dataWidget() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text("交易数据", style: TextStyles.MediumBlackTextSize16),
              new Container(
                child: new Row(
                  children: <Widget>[
                    Image.asset('assets/images/info.png',
                        width: 12.0, height: 12.0),
                    Text(
                      '投资币种:',
                      style: TextStyles.RegularGrey2TextSize12,
                    ),
                    Text(
                      detailData['anchorSymbol'].toUpperCase(),
                      style: TextStyles.RegularGrey2TextSize12,
                    ),
                  ],
                ),
              )
            ],
          ),
          new Padding(padding: new EdgeInsets.all(6.0)),
          new Text(
            "实现收益(" + detailData['anchorSymbol'].toUpperCase() + ")",
            style: TextStyles.RegularGrey2TextSize12,
          ),
          new Padding(padding: new EdgeInsets.all(4.0)),
          new Row(
            children: <Widget>[
              realizedRevenueView(detailData['realizedRevenue']),
              new Container(
                padding: EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 2.0),
                margin: EdgeInsets.only(left: 4.0),
                decoration: BoxDecoration(
                  color: UIData.red_color,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: new Text(
                  "${detailData['rateReturn']}%",
                  style: TextStyles.MediumWhiteTextSize13,
                ),
              )
            ],
          ),
          new Padding(padding: new EdgeInsets.all(6.0)),
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "年化收益率",
                    style: TextStyles.RegularGrey2TextSize12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),
                  ),
                  detailData['annualReturn'].toString().contains("-")
                      ? Text(
                          "${detailData['annualReturn']}%",
                          style: TextStyles.MediumRedTextSize16,
                        )
                      : Text(
                          "${detailData['annualReturn']}%",
                          style: TextStyles.MediumRedTextSize16,
                        ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Text(
                    "成功买入数量",
                    style: TextStyles.RegularGrey2TextSize12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),
                  ),
                  Text(
                    "${detailData['buyCount']}",
                    style: TextStyles.RegularBlackTextSize16,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "交易数",
                    style: TextStyles.RegularGrey2TextSize12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),
                  ),
                  Text(
                    "${detailData['tradeCount']}",
                    style: TextStyles.RegularBlackTextSize16,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Text(
                    "成功卖出数量", //
                    style: TextStyles.RegularGrey2TextSize12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),
                  ),
                  Text(
                    detailData['sellCount'].toString(),
                    style: TextStyles.RegularBlackTextSize16,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "投资本金",
                    style: TextStyles.RegularGrey2TextSize12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),
                  ),
                  Text(
                    detailData['totalSum'] == null
                        ? "0"
                        : detailData['totalSum'],
                    style: TextStyles.RegularBlackTextSize16,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
//                  Text(
//                    "锚定币持仓数量",
//                    style: TextStyle(
//                      fontSize: 13.0,
//                      color: UIData.blueGrey,
//                      fontWeight: FontWeight.w500,
//                    ),
//                  ),
                  Text(
                    '${detailData['symbol'].contains('usdt') ? detailData['symbol'].toUpperCase().replaceAll("USDT", "") : detailData['symbol'].toUpperCase().replaceAll("BTC", "")}持仓数量',
                    // "${detailData['symbol'].toUpperCase().replaceAll("USDT", "")}持仓数量",
                    style: TextStyles.RegularBlackTextSize12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),
                  ),
                  Text(
                    detailData['symbolPositions'].toString(),
                    style: TextStyles.RegularBlackTextSize16,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget diagramWidget() {
    return new Container(
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: Stack(
        children: <Widget>[
          new Row(
            children: [
              new Text(
                "收益走势",
                style: TextStyles.MediumBlackTextSize16,
              ),
              // new Text('(${detailData['anchorSymbol'].toUpperCase()})',style: TextStyles.RegularGrey2TextSize12,)
            ],
          )
        ],
      ),
    );
  }

  Widget buildChart() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
      // child: AreaChartView(data),
    );
  }

  Widget businessWidget() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
      padding: EdgeInsets.fromLTRB(15, 15, 15, 85),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              child: Text("挂单详情", style: TextStyles.MediumBlackTextSize16)),
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1, //宽度
                  color: UIData.border_color, //边框颜色
                ),
              ),
            ),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  flex: 1,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(
                        "委托买入(${buyListData.length})",
                        style: TextStyles.RegularGreyTextSize10,
                      ),
                      new Text(
                        "价格(${detailData['anchorSymbol']})",
                        style: TextStyles.RegularGreyTextSize10,
                      ),
                    ],
                  ),
                ),
                new Expanded(
                  flex: 1,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(
                        "  委托卖出(${sellListData.length})",
                        style: TextStyles.RegularGreyTextSize10,
                      ),
                      new Text(
                        "价格(${detailData['anchorSymbol']})",
                        style: TextStyles.RegularGreyTextSize10,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                  flex: 1,
                  child: Buy(),
                ),
                Padding(padding: EdgeInsets.fromLTRB(6.0, 0, 6.0, 0)),
                new Expanded(
                  flex: 1,
                  child: Sell(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget Buy() {
    List<Widget> tiles = [];
    Widget content;
    buyListData.sort((a, b) => (b['price']).compareTo(a['price']));
    List.generate(buyListData.length, (index) {
      tiles.add(new Container(
        padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Container(
              child: new Row(
                children: <Widget>[
                  new Container(
                      margin: EdgeInsets.only(right: 6.0),
                      padding: EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 2.0),
                      decoration: BoxDecoration(
                        color: UIData.win_color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: new Text(
                        "${(index + 1).toString()}",
                        textAlign: TextAlign.center,
                        style: TextStyles.MediumWhiteTextSize13,
                      )),
                  new Text(
                    '${buyListData[index]['quantity']}',
                    style: TextStyles.MediumBlackTextSize12,
                  ),
                ],
              ),
            ),
            new Text(
              '${buyListData[index]['price']}',
              style: TextStyles.MediumRedTextSize12,
            ),
          ],
        ),
      ));
    });
    content = new Column(
      children: tiles,
    );
    return content;
  }

  Widget Sell() {
    List<Widget> tiles = [];
    Widget content;
    sellListData.sort((a, b) => (a['price']).compareTo(b['price']));
    List.generate(sellListData.length, (index) {
      tiles.add(new Container(
        padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                '${sellListData[index]['quantity']}',
                style: TextStyles.MediumBlackTextSize12,
              ),
              new Container(
                child: new Row(
                  children: <Widget>[
                    new Text(
                      sellListData[index]['price'].toString(),
                      style: TextStyles.MediumTurquoiseTextSize12,
                    ),
                    new Container(
                      margin: EdgeInsets.only(left: 6.0),
                      padding: EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 2.0),
                      decoration: BoxDecoration(
                        color: UIData.red_color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: new Text("${(index + 1).toString()}",
                          textAlign: TextAlign.center,
                          style: TextStyles.MediumWhiteTextSize13),
                    ),
                  ],
                ),
              ),
            ]),
      ));
    });
    content = new Column(
      children: tiles,
    );
    return content;
  }
}
