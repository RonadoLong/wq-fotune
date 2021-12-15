import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wq_fotune/api/mine.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/common/NavigatorUtils.dart';
import 'package:wq_fotune/componets/circular_load.dart';
import 'package:wq_fotune/componets/loding_btn.dart';
import 'package:wq_fotune/componets/refresh.dart';
import 'package:wq_fotune/global.dart';
import 'package:wq_fotune/model/user_info.dart';
import 'package:wq_fotune/page/common/CommonWidget.dart';
import 'package:wq_fotune/page/trade/transaction_details.dart';
import 'package:wq_fotune/page/trade/view/add_api.dart';
import 'package:wq_fotune/page/trade/view/grid_modal.dart';
import 'package:wq_fotune/page/trade/view/market_account.dart';
import 'package:wq_fotune/page/trade/view/market_grid_widget.dart';
import 'package:wq_fotune/page/trade/view/market_item.dart';
import 'package:wq_fotune/page/mine/view/flat_modal_view.dart';
import 'package:wq_fotune/utils/store.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wq_fotune/utils/toast-utils.dart';
import 'package:wq_fotune/api/robot.dart';
import 'package:wq_fotune/page/mine/view/del_modal_view.dart';

class MarketPage extends StatefulWidget {
  @override
  MarketPageState createState() => MarketPageState();
}

class MarketPageState extends State<MarketPage> {
  EasyRefreshController _controller = EasyRefreshController();
  int pageNum = 0;
  int pageSize = 10;
  List dataList = [];
  List _dataList = [];
  List gridTypesList = [];
  bool isVisible = true;
  UserInfo userInfo = Global.getUserInfo();
  Map dataMap = {'symbol': "ETH-USDT"}; //用来存储计算网格总共需要资金参数
  Map calculateMoneyData;
  Map marketAccountData;
  Map balanceData;
  var minMoney;
  var minMoneysData;
  var infiniteAiData; //无线网格AI策略
  final FocusNode verifyNode = FocusNode();

  @override
  void initState() {
    super.initState();
    loadData();
    getStrategyTypesData();
    _getExchangeInfo();

    // 监听登录事件
    Global.eventBus.on("login", (arg) {
      setState(() {
        userInfo = Global.getUserInfo();
      });
      loadData();
      getStrategyTypesData();
      _getExchangeInfo();
    });

    // 监听退出事件
    Global.eventBus.on("logout", (arg) {
      setState(() {
        dataList = [];
        _dataList = [];
        userInfo = null;
        pageNum = 0;
      });
    });

    get('symbolObject').then((val) {
      if (val != null) {
        setState(() {
          dataMap = {'symbol': val};
        });
      }
    });
  }

  loadData() {
    if (userInfo == null) {
      setState(() {
        dataList = [];
      });
      return;
    }
    RobotApi.getStrategyList(userInfo.userId, 0, 100).then((res) {
      if (res.code == 200) {
        dataList = res.data['strategies'];
      } else {
        dataList = [];
      }
      scheduleMicrotask(() {
        Global.eventBus.emit("refresh_market_data", userInfo);
      });
    });
  }

  getStrategyTypesData() {
    RobotApi.getStrategyTypes(0, 100).then((res) {
      if (res.code == 200) {
        setState(() {
          gridTypesList = res.data['gridTypes'];
        });
      } else {
        setState(() {
          gridTypesList = [];
        });
      }
    });
  }

  // 获取交易所列表
  _getExchangeInfo() async {
    var res = await MineAPI.getExchangeApiList();
    if (res.code == 0) {
      setState(() {
        _dataList = res.data;
      });
    } else {
      setState(() {
        _dataList = [];
      });
    }
  }

  getMinMoneyData(params) async {
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

  getGridParamsData(params, minMoney) {
    var data = {
      "exchange": params['exchange'],
      "symbol": params['symbol'],
      "totalSum": minMoney.toString()
//      "totalSum": marketAccountData['total_usdt'].toString()
    };
    RobotApi.getGridParams(data).then((res) {
      print('计算网格需要多少资金');
      print(res);
      print('计算网格需要多少资金');
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

  void _postGridStartup(callBack, params) async {
    RobotApi.postGridStartup(params).then((res) {
      print('res$res');
      if (res.code == 200) {
        Global.eventBus.emit("createStrategy", null);
        showToast("创建成功");
        setState(() {
          balanceData = params;
        });
        _controller.callRefresh();
        this.loadData();
        callBack(null);
      } else {
        showToast(res.msg);
        callBack(res.msg);
      }
    });
  }

  //根据最低价和利润率生成网格参数(无限网格使用)
  void _getAutoGridParams(isAI, type, name) async {
    var params = {
      "exchange": dataMap['exchange'].toString().toLowerCase(),
      "symbol": dataMap['symbol'].replaceAll('-', '').toLowerCase(),
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
        showGridModalView(context, type, name);
      }
    });
  }

  void getCreat() {
    var p = {
      "exchange": dataMap['exchange'],
      "symbol": dataMap['symbol'].replaceAll('-', '').toLowerCase(),
    };
    this.getMinMoneyData(p);
  }

  buildBody() {
    if (dataList == null) {
      return CircularLoading();
    }
    // if (dataList.length == 0) {
    //   return BuildLoadMoreView();
    // }
    return CommonRefresh(
      controller: _controller,
      sliverList: SliverList(
        delegate: SliverChildListDelegate(
          [
            MarketAccount(callBackSelectAccount: (data) {
              print('data${data}');
              setState(() {
                dataMap = {
                  "symbol": dataMap['symbol'],
                  "exchange": data['exchange_name'],
                  "api_key": data['api_key'],
                };
                marketAccountData = data;
              });
              getCreat();
            }),
            Visibility(
              child: MarketGridWidgetItem(),
              visible: isVisible,
            ),
            Visibility(
              child: _buildStrategyItem(),
              visible: !isVisible,
            )
          ],
        ),
      ),
      onRefresh: () {
        loadData();
        _getExchangeInfo();
      },
    );
  }

  _buildLoginAndNotHasAPIView() {
    return buildEmptyAndBtnView(
      title: "您当前还没启动机器人",
      contentLeft: "",
//      contentLeft: "想要参与真实交易,",
//      contentRight: "快去创建吧!",
      contentRight: "",
      heightFactor: 2,
      onTap: () {},
    );
  }

  Widget MarketGridWidgetItem() {
    List<Widget> tilesData = [];
    Widget contentData;
    gridTypesList.forEach((item) {
      tilesData.add(new Container(
        child: GestureDetector(
          onTap: () async {
            if (userInfo == null) {
              gotoLoginPage(context).then((res) {
                if (res != null || res != "") {
                  loadData();
                }
              });
            } else {
              // if(minMoneysData == null){
              //   showToast('可用资金不足');
              //   return;
              // }
              showLoading();
              var res = await MineAPI.getExchangeApiList();
              dismissLoad();
              if (res.data == null || res.data.length == 0) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new AddApiPage()));
              } else {
                if (item['type'] == 2) {
                  _getAutoGridParams(true, item['type'], item['name']);
                } else {
                  showGridModalView(context, item['type'], item['name']);
                }
              }
            }
          },
          child: MarketGridWidget(data: item),
        ),
      ));
    });
    contentData = new Column(
      children: tilesData,
    );
    return contentData;
  }

  Widget _buildStrategyItem() {
    if (dataList == null || dataList.length == 0) {
      return _buildLoginAndNotHasAPIView();
    }
    List<Widget> tiles = [];
    Widget content;
    dataList.forEach((item) {
      tiles.add(MarketItem(
        item: item,
        recommend: userInfo.invitationCode,
        press: (item) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return TransactionDetails(
              id: item["id"],
            );
          }));
        },
        onTapStop: (item) {
          print("val: $item");
          showModelDiaLog(context, "温馨提示", "停止后机器人将会被删除，是否继续?", (callBack) {
            callBack();
            isNex(item);
          });
        },
      ));
    });
    content = new Column(
      children: tiles,
    );
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildBar("量化交易"),
        body: buildBody(),
        resizeToAvoidBottomInset: false);
  }

  Widget showGridModalView(contexts, type, name) {
    showGridModal(
        context,
        this.calculateMoneyData,
        this.marketAccountData,
        this.dataMap,
        true,
        minMoney,
        minMoneysData,
        type,
        name,
        infiniteAiData, (balance, callBack) {
      Loading.show(context);
      var anchorSymbolIndex = dataMap['symbol'].indexOf('-');
      var anchorSymbol = dataMap['symbol'].substring(anchorSymbolIndex + 1);
      var params = {
        "minPrice": balance['minPrice'],
        "maxPrice": balance['maxPrice'],
        "totalSum": balance['totalSum'],
        "gridNum": balance['gridNum'],
        "uid": userInfo.userId,
        "exchange": dataMap['exchange'],
        "symbol": dataMap['symbol'].replaceAll('-', '').toLowerCase(),
        "anchorSymbol": balance['anchorSymbol'].toLowerCase(),
        "apiKey": dataMap['api_key'],
        "type": balance['type']
      };
      this._postGridStartup(callBack, params);
    });
  }

  void isNex(item) {
    showModelDiaLogs(context, "温馨提示", "确认是否要平仓？", (isClosePosition, callBack) {
      var params = {
        "uid": userInfo.userId,
        "exchange": item['exchange'],
        "symbol": item['symbol'],
        "gsid": item['id'],
        "isClosePosition": isClosePosition
      };
      RobotApi.postGridStop(params).then((res) {
        if (res.code == 200) {
          showToast(res.msg);
          _controller.callRefresh();
          this.loadData();
        } else {
          showToast(res.msg);
        }
      });
      callBack();
    });
  }
}
