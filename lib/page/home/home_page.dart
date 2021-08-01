import 'package:flutter/material.dart';
import 'package:wq_fotune/api/Mine.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/componets/circular_load.dart';
import 'package:wq_fotune/componets/home_coursel.dart';
import 'package:wq_fotune/componets/refresh.dart';
import 'package:wq_fotune/global.dart';
import 'package:wq_fotune/page/home/view/HomeTicksContent.dart';
import 'package:wq_fotune/page/home/view/download_app.dart';
import 'package:wq_fotune/page/home/view/home_ticker_header.dart';
import 'package:wq_fotune/page/home/view/home_ticks_item.dart';
import 'package:wq_fotune/page/home/view/home_property.dart';
import 'package:wq_fotune/utils/toast-utils.dart';
import 'package:wq_fotune/api/Home.dart';
import 'package:wq_fotune/page/common/CommonWidget.dart';
import 'package:wq_fotune/model/user_info.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  EasyRefreshController _controller;

  List banners;
  List dataList;
  List exchangeApiList;
  int pageNum = 1;
  int pageSize = 10;
  UserInfo userInfo = Global.getUserInfo();

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    loadData();
    Global.eventBus.on("login", (arg) {
      setState(() {
        userInfo = Global.getUserInfo();
      });
      loadData();
    });
    Global.eventBus.on("logout", (arg) {
      setState(() {
        userInfo = null;
        exchangeApiList = null;
      });
    });
    Global.eventBus.on("refresh", (arg) {
      loadData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _loadCarousels() async {
    commonCarousels().then((res) {
      if (res.code == 0) {
        setState(() {
          banners = res.data;
        });
      } else {
        showToast(res.msg);
      }
    });
  }

  loadData() async {
    if (userInfo != null) {
      MineAPI.getExchangeApiList().then((res) {
        if (res.code == 0) {
          setState(() {
            exchangeApiList = res.data;
          });
        }
      });
    }
    _loadCarousels();
    _getExchangeSymbolRank();
  }

  _getExchangeSymbolRank() async {
    getExchangeSymbolRank().then((res) {
      if (res.code == 0) {
        setState(() {
          dataList = res.data;
        });
      }
    });
  }

  Widget _buildProperty() {
    if (userInfo == null) {
      return Container(
        child: null,
      );
    }
    return HomeProperty(
      dataList: exchangeApiList == null ? [] : exchangeApiList,
    );
  }

  Widget _builddownloadAPP() {
    return DownloadApp();
  }

  Widget _buildBanner() {
    if (banners == null || banners.length == 0) {
      return Container();
    }
    return HomeBanner(
      banners: banners,
      press: (index) {},
    );
  }

  loadMore() async {
    getStrategies(pageNum + 1, pageSize).then((res) {
      if (res.code == 0) {
        if (this.mounted) {
          setState(() {
            dataList.addAll(res.data);
            pageNum += 1;
          });
        }
      }
      if (res.code == 1404) {
        showToast("没有更多数据");
      }
    });
  }

  buildBody() {
    if (dataList == null ||
        dataList.length == 0 ||
        banners == null ||
        banners.length == 0) {
      return CircularLoading();
    }
    if (dataList.length == 0) {
      return _buildNetWorkErrView();
    }
    return CommonRefresh(
      controller: _controller,
      sliverList: SliverList(
        delegate: SliverChildListDelegate(
          [
            _builddownloadAPP(),
            _buildBanner(),
            _buildProperty(),
            HomeTickerHeader(),
            _buildTickers(),
          ],
        ),
      ),
      onRefresh: () {
        loadData();
        _controller.resetLoadState();
      },
    );
  }

  _buildNetWorkErrView() {
    return buildEmptyAndBtnView(
      title: "当前的网络出错",
      contentLeft: "下拉刷新，",
      contentRight: "点击刷新",
      onTap: () {
        _getExchangeSymbolRank();
        _loadCarousels();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBar("iFortune"),
      body: buildBody(),
    );
  }

  Widget _buildTickers() {
    List<Widget> tiles = [];
    List.generate(dataList.length, (index) {
      tiles.add(HomeTicksItem(
        data: dataList[index],
        length: dataList.length,
        index: index,
      ));
    });
    return HomeTicksContent(context: context, tiles: tiles);
  }
}
