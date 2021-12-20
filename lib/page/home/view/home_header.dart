import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/api/exchange.dart';
import 'package:wq_fotune/model/user_info.dart';
import 'package:wq_fotune/common/EventBus.dart';
import 'package:wq_fotune/page/account/account_page.dart';
import 'package:wq_fotune/page/common/CommonWidget.dart';
import 'package:wq_fotune/api/user.dart';
import 'package:wq_fotune/common/NavigatorUtils.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/ui_data.dart';

class HomeHeader extends StatefulWidget {
  Map assets;
  HomeHeader({this.assets});

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  UserInfo userInfo;
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


  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
              decoration: BoxDecoration(
                color: UIData.primary_color.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: userInfo == null
                  ? noLogin()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('总资产', style: TextStyles.RegularWhiteTextSize14),
                        SizedBox(height: 10),
                        Text(widget.assets != null ? widget.assets['asserts'] : "",
                          style: TextStyles.HeavyWhiteTextSize22,
                        ),
                        SizedBox(height: 10),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "收益",
                              style: TextStyles.RegularWhiteTextSize14,
                            ),
                            Text(widget.assets == null
                                      ? ""
                                      : "+ " + widget.assets['profit'],
                              style: TextStyles.RegularWhiteTextSize14,
                            ),
                            Text(widget.assets == null
                                      ? ""
                                      : "+ " + widget.assets['profit_percent'],
                              style: TextStyles.RegularWhiteTextSize14,
                            ),
                          ],
                        )
                      ],
                    ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (widget.assets != null) {
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new AccountPage()),
          );
        }
      },
    );
  }

  Widget noLogin() {
    ShapeBorder shape = const RoundedRectangleBorder(
        side: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(4)));
    return new Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 2.0)),
        Text(
          '登陆后查看总资产',
          style: TextStyles.RegularWhiteTextSize14,
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              minWidth: 80.0,
              height: 36.0,
              textColor: Colors.white,
              shape: shape,
              child: new Text(
                '登录',
                style: TextStyles.RegularWhiteTextSize14,
              ),
              onPressed: () {
                gotoLoginPage(context).then((res) {
                  if (res != null || res != "") {
                    loadUserInfo();
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
