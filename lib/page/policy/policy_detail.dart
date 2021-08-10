import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wq_fotune/api/mine.dart';
import 'package:wq_fotune/api/robot.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/componets/circular_load.dart';
import 'package:wq_fotune/componets/refresh.dart';
import 'package:wq_fotune/model/ticker.dart';
import 'package:wq_fotune/model/user_info.dart';
import 'package:wq_fotune/page/common/CommonWidget.dart';
import 'package:wq_fotune/page/policy/view/policy_strategy_ai.dart';
import 'package:wq_fotune/page/policy/view/policy_strategy_custom.dart';
import 'package:wq_fotune/page/trade/market_choice_trade.dart';
import 'package:wq_fotune/page/trade/view/add_api.dart';
import 'package:wq_fotune/page/trade/view/market_account.dart';
import 'package:wq_fotune/page/trade/view/market_symbol.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/store.dart';
import 'package:wq_fotune/utils/ui_data.dart';
import 'package:wq_fotune/utils/toast-utils.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../global.dart';

class policyAdd extends StatefulWidget {
  final type;
  final List exchangeApiList;

  policyAdd({Key key, this.type, this.exchangeApiList}) : super(key: key);

  @override
  policyAddState createState() => policyAddState();
}

class policyAddState extends State<policyAdd> {
  EasyRefreshController _controller = EasyRefreshController();
  bool isVisible = true;
  UserInfo userInfo = Global.getUserInfo();
  Map currentSymbolParams; //用来存储计算网格总共需要资金参数
  Map calculateMoneyData; //计算AI网格需要多少资金
  var minMoney; //AI网格最少投资额
  Map marketAccountData;
  Map balanceData;
  var minMoneysData;
  var infiniteAiData; //无线网格AI策略

  List exchangeApiList = [];
  Ticker ticker;
  Map currentSymbol = {}; // 当前品种

  final FocusNode verifyNode = FocusNode();

  final marketData = Global.marketData;

  @override
  void initState() {
    super.initState();

    var dataMap = {}; //没有选择设置默认值

    if (widget.exchangeApiList != null) {
      exchangeApiList = widget.exchangeApiList;
      Map selectAccount = exchangeApiList[0];
      print('当前选择的账户: $selectAccount');
      save("exchange_name", selectAccount);
      marketAccountData = selectAccount;
    }

    var exchange_name =
        marketAccountData['exchange_name'].toString().toLowerCase();
    dataMap = marketData[exchange_name]['usdt']['ETH-USDT'];
    // dataMap = marketData[0];
    get('symbolObject').then((val) {
      currentSymbolParams = {
        "symbol": "ETH-USDT",
        "exchange_name": marketAccountData['exchange_name'],
        "api_key": marketAccountData['api_key'],
        "uid": userInfo.userId,
      };
      if (val != null && this.mounted) {
        // 已经选择过的交易对
        Map map = json.decode(val);
        currentSymbol = {
          'symbol': map["symbol"],
        };
        currentSymbolParams["symbol"] = map["symbol"];
        ticker = Ticker()
          ..change = map['change'] // 加载 map['symbol'] 行情
          ..last = map['price'] // 加载 map['symbol'] 行情
          ..symbol = map['symbol'];
      } else {
        // 还没选择过的使用默认的交易对
        ticker = Ticker()
          ..change = dataMap['change'] // 加载ETH-USDT行情数据
          ..last = dataMap['last'] // 加载ETH-USDT行情数据
          ..symbol = "ETH-USDT";
        currentSymbol = {
          'symbol': "ETH-USDT",
        };
      }
      setState(() {});
      this._getAutoGridParams(true, 2);
      getCreat();
    });

    // 监听刷新行情的事件
    Global.eventBus.on("refreshMarket", (tList) {
      (tList as List<Ticker>)?.forEach((t) {
        if (t.symbol.contains(currentSymbol["symbol"])) {
          setState(() {
            ticker = t;
          });
        }
      });
    });
  }

  _loadData() {
    MineAPI.getExchangeApiList().then((res) {
      if (res.code == 0) {
        setState(() {
          exchangeApiList = res.data;
          if (exchangeApiList.length > 0) {
            Map selectAccount = exchangeApiList[0];
            print('res${selectAccount}');
            save("exchange_name", selectAccount.toString());
            currentSymbolParams = {
              "symbol": currentSymbolParams['symbol'],
              "exchange_name": selectAccount['exchange_name'],
              "api_key": selectAccount['api_key'],
              "uid": userInfo.userId,
            };
            marketAccountData = selectAccount;
            this._getAutoGridParams(true, 2);
            getCreat();
          }
        });
      } else {
        if (exchangeApiList == null) {
          setState(() {
            exchangeApiList = [];
          });
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBar("设置网格"),
      body: buildBody(),
    );
  }

  selectAccount(data) {
    if (data == null) {
      return;
    }
    setState(() {
      currentSymbolParams = {
        "symbol": currentSymbolParams['symbol'],
        "exchange_name": data['exchange_name'],
        "api_key": data['api_key'],
        "uid": userInfo.userId,
      };
      marketAccountData = data;
    });
    this._getAutoGridParams(true, 2);
    getCreat();
  }

  changeSymbolHandler() {
    if (exchangeApiList == null || exchangeApiList.length == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddApiPage(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MarketChoiceTrade(
            exchangeName: currentSymbolParams['exchange_name'],
          ),
        ),
      ).then((value) {
        print("=====${value.toString()}");
        if (value == null) {
          return;
        }
        minMoney = null;
        calculateMoneyData = null;
        currentSymbol = value;
        Ticker newTicker = Ticker()
          ..change = value['change']
          ..last = value['price']
          ..symbol = value['symbol'];
        ticker = newTicker;
        currentSymbolParams = {
          "symbol": value['symbol'],
          "exchange_name": currentSymbolParams['exchange_name'],
          "api_key": currentSymbolParams['api_key'],
          "uid": userInfo.userId,
        };
        setState(() {});
        save("symbolObject", value);
        getCreat();
      });
    }
  }

  buildBody() {
    if (exchangeApiList == null) {
      return CircularLoading();
    }
    return CommonRefresh(
      controller: _controller,
      sliverList: SliverList(
        delegate: SliverChildListDelegate(
          [
            MarketAccount(
              userInfo: userInfo,
              apiList: exchangeApiList,
              selectAccount: marketAccountData,
              callBackSelectAccount: (data) => selectAccount(data),
            ),
            currentSymbol.isNotEmpty
                ? MarketSymbol(
                    apiList: exchangeApiList,
                    userInfo: userInfo,
                    currentSymbol: currentSymbol,
                    ticker: ticker,
                    onDataChange: () => changeSymbolHandler(),
                  )
                : Container(),
            marketAddWidget()
          ],
        ),
      ),
      onRefresh: () {
        _loadData();
        // _getExchangeInfo();
      },
    );
  }

  void getCreat() async {
    var p = {
      "exchange": currentSymbolParams['exchange_name'].toString().toLowerCase(),
      "symbol": currentSymbolParams['symbol'].replaceAll('-', '').toLowerCase(),
    };
    this.getMinMoneyData(p);
  }

  void getMinMoneyData(params) async {
    RobotApi.getMinMoney(params).then((res) {
      print(res);
      if (res.code == 200) {
        var minMoneyData = res.data['minMoney'];
        this.getGridParamsData(params, res.data['minMoney']);
        setState(() {
          minMoney = minMoneyData;
        });
      } else {
        setState(() {
          minMoney = 0;
        });
        showToast(res.msg);
      }
    });
  }

  void getGridParamsData(params, minMoney) {
    var data = {
      "exchange": params['exchange'],
      "symbol": params['symbol'],
      "totalSum": minMoney.toString()
    };
    RobotApi.getGridParams(data).then((res) {
      if (res.code == 200) {
        setState(() {
          minMoneysData = res.data;
          calculateMoneyData = res.data;
        });
      } else {
        showToast(res.msg);
        setState(() {
          minMoneysData = {};
          calculateMoneyData = {};
        });
      }
    });
  }

  void _postGridStartup(data) {
    showLoading();
    RobotApi.postGridStartup(data).then((res) {
      dismissLoad();
      if (res.code == 200) {
        Global.eventBus.emit("createStrategy", null);
        showToast("创建成功");
        handleRefresh(() {
          Navigator.pop(context, 1);
        });
        Global.eventBus.emit("changeTabPage", 2);
      } else {
        showToast(res.msg);
      }
    });
  }

  //根据最低价和利润率生成网格参数(无限网格使用)
  void _getAutoGridParams(isAI, type) async {
    Map<String, dynamic> params = {
      "exchange": currentSymbolParams['exchange_name'].toString().toLowerCase(),
      "symbol": currentSymbolParams['symbol'].replaceAll('-', '').toLowerCase(),
    };
    //AI
    if (isAI) {
      params["isAI"] = isAI.toString();
    }
    RobotApi.getAutoGridParams(params).then((res) {
      if (res.code == 200) {
        setState(() {
          infiniteAiData = res.data;
        });
      }
    });
  }

  Widget marketTab({
    double btnW,
    String title,
    Color bgColor,
    TextStyle textStyle,
    Function onTap,
  }) {
    return GestureDetector(
      child: new Container(
        width: btnW,
        padding: EdgeInsets.fromLTRB(0, 12.0, 0, 12.0),
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(8)),
        child: Text(title, textAlign: TextAlign.center, style: textStyle),
      ),
      onTap: () => onTap(),
    );
  }

  Widget marketAddWidget() {
    if (calculateMoneyData == null || minMoney == null) {
      return Container(
          margin: EdgeInsets.only(top: 120), child: CircularLoading());
    }
    double btnW = (MediaQuery.of(context).size.width - 15 * 3) / 2;
    return Container(
      color: UIData.white_color,
      padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
      margin: EdgeInsets.only(top: 8.0),
      child: new Column(
        children: [
          new Container(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                marketTab(
                    btnW: btnW,
                    title: 'AI推荐策略',
                    bgColor: isVisible ? UIData.blue_color : UIData.bg_color,
                    textStyle: isVisible
                        ? TextStyles.RegularWhiteTextSize14
                        : TextStyles.RegularGrey2TextSize14,
                    onTap: () {
                      setState(() {
                        isVisible = true;
                      });
                    }),
                SizedBox(
                  width: 15,
                ),
                marketTab(
                    btnW: btnW,
                    title: '自定义策略',
                    bgColor: !isVisible ? UIData.blue_color : UIData.bg_color,
                    textStyle: !isVisible
                        ? TextStyles.RegularWhiteTextSize14
                        : TextStyles.RegularGrey2TextSize14,
                    onTap: () {
                      setState(() {
                        isVisible = false;
                      });
                    }),
              ],
            ),
          ),
          new Container(
            child: new Column(
              children: [
                Visibility(
                  child: policyAi(
                      dataMap: currentSymbolParams,
                      minMoney: minMoney,
                      calculateMoneyData: calculateMoneyData,
                      MarketAccountData: marketAccountData,
                      type: widget.type,
                      infiniteAiData: infiniteAiData,
                      callBack: (data) {
                        _postGridStartup(data);
                      }),
                  visible: isVisible,
                ),
                Visibility(
                  child: PolicyCustom(
                      dataMap: currentSymbolParams,
                      minMoney: minMoney,
                      marketAccountData: marketAccountData,
                      type: widget.type,
                      infiniteAiData: infiniteAiData,
                      callBack: (data) {
                        _postGridStartup(data);
                      }),
                  visible: !isVisible,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
