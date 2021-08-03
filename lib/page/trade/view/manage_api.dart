import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/api/mine.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/common/EventBus.dart';
import 'package:wq_fotune/componets/circular_load.dart';
import 'package:wq_fotune/componets/refresh.dart';
import 'package:wq_fotune/model/user_info.dart';
import 'package:wq_fotune/page/common/CommonWidget.dart';
import 'package:wq_fotune/page/mine/view/del_modal_view.dart';
import 'package:wq_fotune/page/mine/view/exchange_item.dart';
import 'package:wq_fotune/utils/ui_data.dart';
import 'package:wq_fotune/utils/toast-utils.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'add_api.dart';

class ManageApiPage extends StatefulWidget {
  @override
  ManageApiPageState createState() => ManageApiPageState();
}

class ManageApiPageState extends State<ManageApiPage> {
  List exchangeInfoList;
  List dataList;

  EasyRefreshController _controller = EasyRefreshController();

  UserInfo user;
  int pageNum = 0;
  int pageSize = 10;

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
        });
      }
    });
  }
  //删除交易所

  void _deleteExchange(id, callback) {
    MineAPI.delExchangeApi(id).then((res) {
      if (res.code == 0) {
        _controller.callRefresh();
        this.loadData();
        callback();
        showToast("删除交易所成功");
      } else {
        showToast(res.msg);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBar("API管理", actions: [
        GestureDetector(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 8.0, 16.0, 0),
            child: Icon(Icons.add, color: UIData.one_color),
          ),
          onTap: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new AddApiPage()))
                .then((value) {
              if (value == null) {
                return;
              }
              _controller.callRefresh();
              this.loadData();
            });
          },
        )
      ]),
      body: buildBody(),
      backgroundColor: UIData.bg_color,
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
      return buildEmptyAndBtnView(
        title: "您当前还没API",
        contentLeft: "想要参与真实交易, ",
        contentRight: "现在添加吧!",
        onTap: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new AddApiPage()))
              .then((value) {
            if (value == null) {
              return;
            }
            _controller.callRefresh();
            this.loadData();
          });
        },
      );
      // return buildEmptyView(title: "还没有绑定交易所", heightFactor: 3);
    }
    var item = dataList[index];
    return ExchangeItem(item, (index) {
      switch (index) {
        case 0:
          // Navigator.of(context).pop(item);
          break;
        case 1:
          Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new AddApiPage(id: item['id'])))
              .then((val) {
            if (val == null) {
              return;
            }
            _controller.callRefresh();
            this.loadData();
          });
          //修改
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
}
