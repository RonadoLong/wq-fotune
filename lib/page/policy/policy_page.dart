import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/api/mine.dart';
import 'package:wq_fotune/api/robot.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/common/NavigatorUtils.dart';
import 'package:wq_fotune/componets/refresh.dart';
import 'package:wq_fotune/global.dart';
import 'package:wq_fotune/page/policy/policy_detail.dart';
import 'package:wq_fotune/page/policy/view/policy_banner.dart';
import 'package:wq_fotune/page/policy/view/policy_item.dart';
import 'package:wq_fotune/page/trade/view/add_api.dart';
import 'package:wq_fotune/utils/toast-utils.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class PolicyPage extends StatefulWidget {
  @override
  PolicyPageState createState() => PolicyPageState();
}

class PolicyPageState extends State<PolicyPage> {
  EasyRefreshController _controller;
  List<String> banners = [
    'https://dss2.bdstatic.com/8_V1bjqh_Q23odCf/pacific/1970357596.jpg',
    'https://dss2.bdstatic.com/8_V1bjqh_Q23odCf/pacific/1926728948.png',
    'https://dss2.bdstatic.com/8_V1bjqh_Q23odCf/pacific/1970488359.jpg'
  ];
  List dataList;

  void initState() {
    super.initState();
    getStrategyTypesData();
  }

  getStrategyTypesData() {
    RobotApi.getStrategyTypes(0, 100).then((res) {
      if (res.code == 200) {
        setState(() {
          dataList = res.data['gridTypes'];
        });
      } else {
        setState(() {
          dataList = [];
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBar("策略列表"),
      body: buildBody(),
    );
  }

  buildBody() {
    return CommonRefresh(
      controller: _controller,
      sliverList: SliverList(
        delegate: SliverChildListDelegate(
          [
            // _policyBanner(),
            _policyList(),
          ],
        ),
      ),
      onRefresh: () {
        getStrategyTypesData();
        // _controller.resetLoadState();
      },
    );
  }

  Widget _policyBanner() {
    return PolicyBanner(
      banners: banners,
    );
  }

  Widget _policyList() {
    if (dataList != null) {
      List<Widget> tiles = [];
      Widget content;
      List.generate(dataList.length, (index) {
        tiles.add(PolicyItem(
          data: dataList[index],
          length: dataList.length,
          index: index,
          onPress: () async {
            if (Global.getUserInfo() == null) {
              gotoLoginPage(context).then((res) {
                if (res != null || res != "") {}
              });
            } else {
              showLoading();
              var res = await MineAPI.getExchangeApiList();
              dismissLoad();
              print("${res.code}");
              if (res.code != 0 && res.code != 1404) {
                showToast("网络出错，请重试");
                return;
              }
              if (res.data == null || res.data.length == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => AddApiPage(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => new policyAdd(
                      type: dataList[index]['type'],
                      exchangeApiList: res.data,
                    ),
                  ),
                );
              }
            }
          },
        ));
      });
      content = new Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: new Column(
          children: tiles,
        ),
      );
      return content;
    }
    return Container();
  }
}
