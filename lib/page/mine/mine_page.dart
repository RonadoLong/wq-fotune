import 'package:flutter/material.dart';
import 'package:wq_fotune/api/user.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/common/CustomLogImage.dart';
import 'package:wq_fotune/common/EventBus.dart';
import 'package:wq_fotune/common/NavigatorUtils.dart';
import 'package:wq_fotune/componets/cell.dart';
import 'package:wq_fotune/componets/refresh.dart';
import 'package:wq_fotune/model/user_info.dart';
import 'package:wq_fotune/page/common/CommonWidget.dart';
import 'package:wq_fotune/page/mine/friend_page.dart';
import 'package:wq_fotune/page/mine/secret_page.dart';
import 'package:wq_fotune/page/mine/setting_page.dart';
import 'package:wq_fotune/page/mine/wallet_page.dart';
import 'package:wq_fotune/page/trade/view/manage_api.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/ui_data.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'about_page.dart';
import 'consumer.dart';

class MinePage extends StatefulWidget {
  @override
  MinePageState createState() => MinePageState();
}

class MinePageState extends State<MinePage> {
  UserInfo userInfo;
  EasyRefreshController _controller = EasyRefreshController();
  List<String> cellTitle = ["邀请好友", "绑定API", "隐私协议", "联系客服", "设置信息", "关于我们"];
  List<IconData> cellIcon = [
    Icons.group_add,
    Icons.api,
    Icons.ac_unit,
    Icons.assignment_ind_outlined,
    Icons.settings,
    Icons.info_outline
  ];
  var bus = EventBus();

  @override
  void initState() {
    super.initState();

    bus.on("login", (arg) {
      loadUserInfo();
    });
    bus.on("logout", (arg) {
      setState(() {
        userInfo = null;
      });
    });
    handleRefreshWithDuration(() {
      loadUserInfo();
    }, Duration(seconds: 1));
  }

  loadUserInfo() async {
    UserApi.getUserInfo().then((resp) {
      if (resp.code == 0) {
        UserInfo res = UserInfo.fromJson(resp.data);
        setState(() {
          userInfo = res;
        });
      }
    });
  }

  buildBody() {
    return CommonRefresh(
      controller: _controller,
      sliverList: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return renderRow(index);
          },
          childCount: 1,
        ),
      ),
      onRefresh: () {
        loadUserInfo();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBar("个人中心"),
      body: buildBody(),
    );
  }

  renderRow(index) {
    return Column(
      children: [
        _buildMineHeader(),
        _buildMinePayCells(),
        _buildMineCells(),
      ],
    );
  }

  Widget _buildMineHeader() {
    return GestureDetector(
      onTap: () {
        gotoSettingPage();
      },
      child: Container(
        height: 120,
        padding: EdgeInsets.fromLTRB(15, 0, 15, 25),
        margin: EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: UIData.border_color,
            blurRadius: 5,
            offset: Offset(0, 2),
          )
        ]),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Positioned(
              top: 50,
              right: 6,
              child: Icon(
                Icons.border_color,
                color: UIData.three_color,
                size: 18,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  child: buildLogImage(null),
                  onTap: () {
                    gotoSettingPage();
                  },
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(left: 15),
                  child: userInfo == null
                      ? _buildHeaderNotLogin()
                      : _buildHeaderLogin(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderNotLogin() {
    return Text(
      "登录/注册",
      style: TextStyles.MediumBlackTextSize18,
    );
  }

  Widget _buildHeaderLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userInfo.name,
          style: TextStyles.MediumBlackTextSize18,
        ),
        Padding(
          padding: EdgeInsets.only(top: 4),
        ),
        Text(
          "UID: ${userInfo.userId}",
          style: TextStyles.RegularGrey2TextSize12,
        )
      ],
    );
  }

  Widget _buildMinePayCells() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: SyCell(
        title: "钱包",
        icon: Icon(
          Icons.account_balance_wallet,
          color: UIData.primary_color.withOpacity(0.8),
        ),
        isShowLine: false,
        onTap: () {
          if (userInfo == null) {
            gotoLoginPage(context).then((res) {
              if (res != null || res != "") {
                loadUserInfo();
              }
            });
            return;
          }
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new WalletPage()),
          );

//          showToast("即将开放，更多体验");
//          return;
          tapCell(20);
        },
      ),
    );
  }

  Widget _buildMineCells() {
    List<Widget> cells = [];
    for (int i = 0; i < cellTitle.length; i++) {
      String title = cellTitle[i];
      IconData iconData = cellIcon[i];
      cells.add(Container(
        margin: EdgeInsets.fromLTRB(0, i % 2 == 0 ? 8 : 2, 0, 0),
        child: SyCell(
          title: title,
          isShowLine: false,
          icon: Icon(
            iconData,
            color: UIData.primary_color.withOpacity(0.8),
          ),
          onTap: () {
            tapCell(i);
          },
        ),
      ));
    }
    return Container(
      child: Column(
        children: cells,
      ),
    );
  }

  void gotoSettingPage() {
    if (userInfo == null) {
      gotoLoginPage(context).then((res) {
        if (res != null || res != "") {
          loadUserInfo();
        }
      });
    } else {
      Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new SettingPage()))
          .then((result) {
        if (result != null) {
          loadUserInfo();
        }
      });
    }
  }

  void tapCell(i) {
    if (userInfo == null) {
      gotoLoginPage(context).then((res) {
        if (res != null || res != "") {
          loadUserInfo();
        }
      });
      return;
    }
    switch (i) {
      case 0:
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new FriendPage(userInfo: userInfo)),
        );
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => new ManageApiPage()));
        break;
      case 2:
        return;
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new SecretPage()));
        break;
      case 3:
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new Consult()),
        );
        break;
      case 4:
        gotoSettingPage();
        break;
      case 5:
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new AboutdPage()));
        break;
      case 5:
        Navigator.of(context).pushNamed('/recharge');
        break;
      case 20:
        break;
    }
  }
}
