import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/common/EventBus.dart';
import 'package:wq_fotune/componets/circular_load.dart';
import 'package:wq_fotune/componets/custom_btn.dart';
import 'package:wq_fotune/componets/refresh.dart';
import 'package:wq_fotune/model/user_info.dart';
import 'package:wq_fotune/page/mine/view/del_modal_view.dart';
import 'package:wq_fotune/page/mine/view/exchange_item.dart';
import 'package:wq_fotune/page/mine/view/exchange_modal.dart';
import 'package:wq_fotune/utils/toast-utils.dart';
import 'package:wq_fotune/utils/UIData.dart';
import 'package:wq_fotune/page/mine/exchange_api_details.dart';
import 'package:wq_fotune/api/Mine.dart';
import 'package:wq_fotune/page/common/CommonWidget.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class ExchangeM extends StatefulWidget {
  @override
  ExchangeMState createState() => ExchangeMState();
}

class ExchangeMState extends State<ExchangeM> {
  String title = "交易所管理";
  List dataList;
  List exchangeInfoList;

  EasyRefreshController _controller = EasyRefreshController();

  UserInfo user;
  int pageNum = 0;
  int pageSize = 10;

  ExchangeModel exchangeModel; // 添加交易所弹框管理

  @protected
  var bus = new EventBus();

  @override
  void initState() {
    super.initState();
    loadData();
    _getExchangeInfo();
  }

  loadData() async {
    MineAPI.getExchangeApiList().then((res) {
      if (res.code == 0) {
        setState(() {
          dataList = res.data;
        });
      } else {
        setState(() {
          dataList = [];
        });
      }
    });
  }

  // 获取交易所列表
  _getExchangeInfo() async {
    MineAPI.getExchangeInfo().then((res) {
      if (res.code == 0) {
        setState(() {
          exchangeInfoList = res.data;
          exchangeModel = ExchangeModel(
            ctx: context,
            dItems: exchangeInfoList,
            onSure: onTapSure,
          );
        });
      }
    });
  }

  // 添加确认
  void onTapSure(Map params, Function callBack) {
    print(params);
    if (params.containsKey('api_id')) {
      _exchangeOrderExchangeApiUpdate(params, callBack);
    } else {
      _exchangeOrderApiAdd(params, callBack);
    }
  }

  // 更新交易所
  void _exchangeOrderExchangeApiUpdate(params, callBack) {
    MineAPI.updateExchangeOrderExchangeApi(params).then((res) {
      if (res.code != 0) {
        showToast(res.msg);
      } else {
        callBack();
        showToast("交易所修改成功");
        this.loadData();
      }
    });
  }

  // 添加交易所
  void _exchangeOrderApiAdd(params, callBack) {
    MineAPI.addExchangeOrderApi(params).then((res) {
      if (res.code != 0) {
        showToast(res.msg);
      } else {
        callBack();
        showToast("交易所添加成功");
        this.loadData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('交易所管理'),
        centerTitle: true,
        backgroundColor: UIData.blue_color,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_box,
              size: 22,
            ),
            onPressed: () {
              if (exchangeModel != null) {
                exchangeModel.showExchangeAddOrUpdateDiaLog();
              }
            },
          ),
        ],
      ),
      body: Center(
          child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          buildBody(),
          RoundBtn(
            content: "添加交易所",
            isPositioned: true,
            onPress: () {
              if (exchangeModel != null) {
                exchangeModel.showExchangeAddOrUpdateDiaLog();
              }
            },
          )
        ],
      )),
    );
  }

  buildBody() {
    if (dataList == null) {
      return CircularLoading();
    }
    return CommonRefresh(
      controller: _controller,
      sliverList: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => buildContent(context, index),
          childCount: dataList.length == 0 ? 1 : dataList.length,
        ),
      ),
      onRefresh: () async {
        loadData();
        _controller.resetLoadState();
      },
    );
  }

  buildContent(BuildContext context, index) {
    if (dataList.length == 0) {
      return buildEmptyView(title: "还没有绑定交易所", heightFactor: 3);
    }
    var item = dataList[index];
    return ExchangeItem(item, (index) {
      switch (index) {
        case 0:
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new ExchangeDetails()),
          );
          break;
        case 1:
          //修改
          exchangeModel.showExchangeAddOrUpdateDiaLog(item: item);
          break;
        case 2:
          // 删除
          showModelDiaLog(context, "提示", "是否确定删除", (callback) {
            _deleteExchange(item["id"], callback);
          });
          break;
      }
    });
  }

  void _deleteExchange(id, callback) {
    MineAPI.delExchangeApi(id).then((res) {
      if (res.code != 0) {
        showToast(res.msg);
      } else {
        showToast("删除交易所成功");
        this.loadData();
        callback();
      }
    });
  }
}
