import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/api/robot.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/componets/circular_load.dart';
import 'package:wq_fotune/componets/refresh.dart';
import 'package:wq_fotune/model/user_info.dart';
import 'package:wq_fotune/page/common/CommonWidget.dart';
import 'package:wq_fotune/page/mine/view/del_modal_view.dart';
import 'package:wq_fotune/page/mine/view/flat_modal_view.dart';
import 'package:wq_fotune/page/trade/transaction_details.dart';
import 'package:wq_fotune/page/trade/view/market_item.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/store.dart';
import 'package:wq_fotune/utils/ui_data.dart';
import 'package:wq_fotune/utils/toast-utils.dart';

import '../../global.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class TransactionPage extends StatefulWidget {
  @override
  TransactionPageState createState() => TransactionPageState();
}

class TransactionPageState extends State<TransactionPage> {
  List dataList = null;
  List list;
  UserInfo userInfo = Global.getUserInfo();
  Map dataMap;
  EasyRefreshController _controller = EasyRefreshController();
  Duration durationTime = Duration(seconds: 1);
  Timer timer;

  @override
  void initState() {
    super.initState();
    loadData();

    // 监听登录事件
    Global.eventBus.on("login", (arg) {
      setState(() {
        userInfo = Global.getUserInfo();
      });
      loadData();
    });

    // 监听退出事件
    Global.eventBus.on("logout", (arg) {
      setState(() {
        dataList = [];
        userInfo = null;
      });
    });

    Global.eventBus.on("createStrategy", (arg) {
      setState(() {
        userInfo = Global.getUserInfo();
      });
      loadData();
    });

    get('symbolObject').then((val) {
      if (val != null) {
        setState(() {
          dataMap = {'symbol': val};
        });
      }
    });
  }

  //数据处理
  handleData() {
    timer = new Timer(durationTime, () {
      var listD = [];
      final marketData = Global.marketData;
      if (list.length == 0 || list == null) {
        setState(() {
          dataList = [];
        });
        return;
      }
      list.forEach((item) {
        var map = {};
        map = item;
        var symbol = item['symbol'];
        if (symbol.contains('usdt')) {
          symbol = symbol.replaceFirst('usdt', '-usdt').toUpperCase();
        } else if (item['symbol'].contains('btc')) {
          symbol = symbol.replaceFirst('btc', '-btc').toUpperCase();
        }
        if (marketData == null) {
          map['low'] = '0';
          map['last'] = '0';
        } else {
          map['low'] = marketData[item['exchange']][item['anchorSymbol']]
                  [symbol]['low']
              .toString();
          map['last'] = marketData[item['exchange']][item['anchorSymbol']]
                  [symbol]['last']
              .toString();
        }
        listD.add(map);
      });
      setState(() {
        dataList = listD;
      });
    });
  }

  loadData() async {
    if (userInfo == null) {
      return;
    }
    getStrategyList(userInfo.userId, 0, 100).then((res) {
      if (res.code == 200) {
        setState(() {
          list = res.data['strategies'];
        });
        handleData();
      } else {
        setState(() {
          dataList = [];
        });
      }
      scheduleMicrotask(() {
        Global.eventBus.emit("refresh_market_data", userInfo);
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBar("我的策略"),
      body: buildBody(),
    );
  }

  buildBody() {
    if (dataList == null) {
      return CircularLoading();
    } else {
      return CommonRefresh(
        controller: _controller,
        sliverList: SliverList(
          delegate: SliverChildListDelegate(
            [
              _buildStrategyHeader(),
              SizedBox(
                height: 8,
              ),
              _buildStrategyItem()
            ],
          ),
        ),
        onRefresh: () {
          loadData();
        },
      );
    }
  }

  _buildLoginAndNotHasAPIView(Function onTap) {
    return buildEmptyAndBtnView(
      title: "",
      contentLeft: "您当前还没启动机器人, ",
      contentRight: "快去创建吧!",
      heightFactor: 2,
      onTap: () => onTap(),
    );
  }

  Widget _buildStrategyHeader() {
    return Container(
      color: UIData.white_color,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8),
            child: Text('进行中 (${dataList.length})',
                style: TextStyles.MediumBlueTextSize16),
          ),
          Container(
            margin: EdgeInsets.only(left: 16.0),
            width: 70.0,
            decoration: BoxDecoration(
                color: UIData.red_color,
                border: Border(
                    bottom: BorderSide(width: 2, color: UIData.blue_color))),
          )
        ],
      ),
    );
  }

  Widget _buildStrategyItem() {
    if (dataList == null || dataList.length == 0) {
      return _buildLoginAndNotHasAPIView(() {
        Global.eventBus.emit("changeTabPage", 1);
      });
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

  void isNex(item) {
    showModelDiaLogs(context, "温馨提示", "确认是否要平仓？", (isClosePosition, callBack) {
      var params = {
        "uid": userInfo.userId,
        "exchange": item['exchange'],
        "symbol": item['symbol'],
        "gsid": item['id'],
        "isClosePosition": isClosePosition
      };
      showLoading();
      postGridStop(params).then((res) {
        dismissLoad();
        if (res.code == 200) {
          showToast("删除成功");
          _controller.callRefresh();
          // this.loadData();
        } else {
          showToast(res.msg);
        }
      });
      callBack();
    });
  }
}
