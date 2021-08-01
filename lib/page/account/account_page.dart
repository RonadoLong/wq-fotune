import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wq_fotune/api/Mine.dart';
import 'package:wq_fotune/api/User.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/common/NavigatorUtils.dart';
import 'package:wq_fotune/componets/refresh.dart';
import 'package:wq_fotune/global.dart';
import 'package:wq_fotune/model/account.dart';
import 'package:wq_fotune/model/user_info.dart';
import 'package:wq_fotune/page/account/view/account_item.dart';
import 'package:wq_fotune/page/common/CommonWidget.dart';
import 'package:wq_fotune/page/trade/view/add_api.dart';
import 'package:wq_fotune/page/trade/view/manage_api.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/UIData.dart';
import 'package:wq_fotune/utils/toast-utils.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with TickerProviderStateMixin {
  @protected
  List<Account> dataList;
  UserInfo userInfo = Global.getUserInfo();
  Account currentAccount;
  EasyRefreshController _refreshController;
  AnimationController controller;
  Animation animation;
  bool isNetWorkErr = false;

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController();
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
    _listenEvent();
    loadData();
  }

  void _listenEvent() {
    Global.eventBus.on("login", (arg) {
      setState(() {
        userInfo = Global.getUserInfo();
      });
      loadData();
    });
    Global.eventBus.on("logout", (arg) {
      setState(() {
        userInfo = null;
      });
    });
  }

  loadData() {
    setState(() {
      isNetWorkErr = false;
    });
    loadExchangeApi();
  }

  loadExchangeApi() {
    if (Global.getUserInfo() == null) {
      return;
    }
    MineAPI.getExchangeApiList().then((res) {
      if (res.code == 1503) {
        setState(() {
          isNetWorkErr = true;
        });
        return;
      }
      if (res.code == 0) {
        setState(() {
          List<Account> das = [];
          (res.data as List)?.forEach((val) {
            Account acc = Account.fromJson(val);
            acc.balanceDetail?.sort((a, b) => (b.balance.compareTo(a.balance)));
            das.add(acc);
          });
          dataList = das;
          currentAccount = dataList[0];
        });
      } else {
        showToast(res.msg);
        if (dataList == null) {
          setState(() {
            dataList = [];
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBar(
        "账户资产",
        actions: [
          Container(
            margin: EdgeInsets.only(right: 5),
            child: IconButton(
                icon: Icon(Icons.sort),
                onPressed: () {
                  if (userInfo == null) {
                    gotoLoginPage(context).then((res) {
                      if (res != null || res != "") {
                        setState(() {
                          userInfo = Global.getUserInfo();
                        });
                      }
                    });
                  } else {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new ManageApiPage()))
                        .then((value) {
                      setState(() {
                        List<Account> das = [];
                        Account acc = Account.fromJson(value);
                        acc.balanceDetail
                            ?.sort((a, b) => (b.balance.compareTo(a.balance)));
                        das.add(acc);
                        dataList = das;
                        currentAccount = dataList[0];
                      });
                    });
                  }
                }),
          ),
          Container(
            margin: EdgeInsets.only(right: 15),
            child: IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () {
                  if (userInfo == null) {
                    gotoLoginPage(context).then((res) {
                      if (res != null || res != "") {
                        UserInfo user = Global.getUserInfo();
                        setState(() {
                          userInfo = user;
                        });
                      }
                    });
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => new AddApiPage(),
                      ),
                    ).then((value) {
                      print("res===========$value");
                      if (value == null) {
                        return;
                      }
                      loadData();
                    });
                  }
                }),
          )
        ],
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return CommonRefresh(
      controller: _refreshController,
      onRefresh: () {
        loadData();
      },
      sliverList: SliverList(
          delegate: SliverChildListDelegate(
        _buildContent(),
      )),
    );
  }

  _buildNotLoginView() {
    return buildEmptyAndBtnView(
      title: "您当前还没登录",
      contentLeft: "想要参与真实交易, ",
      contentRight: "现在登录吧!",
      onTap: () {
        gotoLoginPage(context);
      },
    );
  }

  _buildLoginAndNotHasAPIView() {
    return buildEmptyAndBtnView(
      title: "您当前还没API",
      contentLeft: "想要参与真实交易, ",
      contentRight: "现在添加吧!",
      onTap: () {
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => new AddApiPage()))
            .then((value) {
          print("res===========$value");
          if (value == null) {
            return;
          }
        });
      },
    );
  }

  _buildLoginAndNotHasBalanceView() {
    return buildEmptyAndBtnView(
      title: "您当前的账户余额不足",
      contentLeft: "想要参与真实交易, 赶紧入金吧",
      contentRight: "",
      heightFactor: 2,
    );
  }

  _buildNetWorkErrView() {
    return buildEmptyAndBtnView(
        title: "当前的网络出错",
        contentLeft: "下拉刷新，",
        contentRight: "点击刷新",
        onTap: () {
          _refreshController.callRefresh();
        });
  }

  List<Widget> _buildContent() {
    if (isNetWorkErr) {
      return [_buildNetWorkErrView()];
    }
    if (userInfo == null || dataList == null) {
      return [_buildNotLoginView()];
    }
    if (dataList.isEmpty) {
      return [_buildLoginAndNotHasAPIView()];
    }

    List<Widget> contents = [
      _buildHeader(),
      _harderNav(),
    ];
    if (currentAccount.balanceDetail == null ||
        currentAccount.balanceDetail.isEmpty) {
      contents.add(_buildLoginAndNotHasBalanceView());
    } else {
      currentAccount.balanceDetail.forEach((acc) {
        contents.add(AccountItems(
          data: acc,
        ));
      });
    }
    return contents;
  }

  Widget _buildHeader() {
    return Container(
      height: 86,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: EdgeInsets.fromLTRB(20, 15, 15, 0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: UIData.border_color,
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "总资产",
                style: TextStyles.RegularGrey3TextSize12,
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currentAccount?.totalUsdt == null
                        ? ""
                        : "${currentAccount?.totalUsdt}",
                    style: TextStyles.MediumTurquoiseTextSize22,
                  ),
                  Text(
                    "USD",
                    textAlign: TextAlign.end,
                    style: TextStyles.MediumTurquoiseTextSize22,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      currentAccount?.totalRmb == null
                          ? ""
                          : "≈ ${currentAccount?.totalRmb}/CNY",
                      style: TextStyles.MediumTurquoiseTextSize14,
                    ),
                  )
                ],
              )
            ],
          ),
          // RotationTransition(
          //   alignment: Alignment.center,
          //   turns: animation,
          //   child: IconButton(
          //     icon: Icon(
          //       Icons.refresh,
          //       size: 30,
          //       color: UIData.normal_line_color,
          //     ),
          //     onPressed: () {
          //       scheduleMicrotask(() {
          //         loadData();
          //       });
          //       controller.forward();
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _harderNav() {
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 10, 10, 10),
      margin: EdgeInsets.fromLTRB(5.0, 0, 5.0, 1.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: new Border(
              bottom: BorderSide(color: UIData.border_color, width: 0.5))),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Row(
              children: [
                Container(
                  width: 100,
                  child: Text(
                    "交易对",
                    style: TextStyles.RegularGrey3TextSize12,
                  ),
                ),
                Text(
                  "数量",
                  style: TextStyles.RegularGrey3TextSize12,
                ),
              ],
            ),
          ),
          Text(
            "价格",
            textAlign: TextAlign.center,
            style: TextStyles.RegularGrey3TextSize12,
          ),
        ],
      ),
    );
  }
}
