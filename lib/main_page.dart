import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/global.dart';

import 'package:wq_fotune/page/home/home_page.dart';
import 'package:wq_fotune/page/policy/policy_page.dart';
import 'package:wq_fotune/page/mine/mine_page.dart';
import 'package:wq_fotune/page/transaction/transaction_page.dart';
import 'package:wq_fotune/utils/ui_data.dart';

class MainPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPageWidget> {
  int _tabIndex = 0;
  var tabImages;
  var appBarTitles;
  var _pageList;

  @override
  void initState() {
    super.initState();
    initData();
    Global.eventBus.on("goMarket", (arg) {
      setState(() {
        _tabIndex = 1;
      });
    });
    Global.eventBus.on("changeTabPage", (arg) {
      setState(() {
        _tabIndex = arg;
      });
    });
  }

  initData() {
    setState(() {
      appBarTitles = ['首页', '策略', '交易', '我的'];
      tabImages = [
        [Icon(Icons.home), Icon(Icons.home, color: UIData.primary_color)],
        [Icon(Icons.cloud), Icon(Icons.cloud, color: UIData.primary_color)],
        [
          Icon(Icons.account_balance_wallet),
          Icon(Icons.account_balance_wallet, color: UIData.primary_color)
        ],
        [
          Icon(Icons.account_box),
          Icon(Icons.account_box, color: UIData.primary_color)
        ],
        [
          Icon(Icons.account_box),
          Icon(Icons.account_box, color: UIData.primary_color)
        ],
      ];
      _pageList = [
        HomePage(),
        PolicyPage(),
        // MarketPage(),
        // AccountPage(),
        TransactionPage(),
        MinePage(),
      ];
    });
  }

  /*
   * 根据选择获得对应的normal或是press的icon
   */
  Icon getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

  /*
   * 获取bottomTab的颜色和文字
   */
  Text getTabTitle(int curIndex) {
    if (curIndex == _tabIndex) {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(fontSize: 13.0, color: UIData.primary_color));
    } else {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(fontSize: 13.0, color: UIData.default_color));
    }
  }

  /*
   * 根据image路径获取图片
   */
  Image getTabImage(path) {
    return new Image.asset(path, width: 20.0, height: 18.0);
  }

  void changeTab(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_pageList != null) {
      return Container(
        child: Scaffold(
          body: IndexedStack(
            index: _tabIndex,
            children: _pageList,
          ),
          bottomNavigationBar: new BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              new BottomNavigationBarItem(
                  icon: getTabIcon(0), title: getTabTitle(0)),
              new BottomNavigationBarItem(
                  icon: getTabIcon(1), title: getTabTitle(1)),
              new BottomNavigationBarItem(
                  icon: getTabIcon(2), title: getTabTitle(2)),
              new BottomNavigationBarItem(
                  icon: getTabIcon(3), title: getTabTitle(3)),
            ],
            type: BottomNavigationBarType.fixed,
            //默认选中首页
            currentIndex: _tabIndex,
            iconSize: 20.0,
            //点击事件
            onTap: (index) {
              setState(() {
                _tabIndex = index;
              });
            },
          ),
        ),
      );
    } else {
      return null;
    }
  }
}
