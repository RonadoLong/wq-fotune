import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/common/EventBus.dart';
import 'package:wq_fotune/componets/custom_btn.dart';
import 'package:wq_fotune/global.dart';
import 'package:wq_fotune/model/user_info.dart';
import 'package:wq_fotune/page/mine/view/del_modal_view.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/toast-utils.dart';
import 'package:wq_fotune/utils/ui_data.dart';
import 'package:wq_fotune/page/mine/edit_name.dart';
import 'package:wq_fotune/page/mine/edit_pwd.dart';

class SettingPage extends StatefulWidget {
  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  UserInfo userInfo = Global.getUserInfo();
  var bus = new EventBus();

  @override
  void initState() {
    super.initState();
  }

  void sureDiaLog() {
    showModelDiaLog(context, "提示", "是否确认退出登录", (callback) {
      Global.clearUserInfoCache().then((ok) {
        if (ok) {
          showToast("退出成功");
          scheduleMicrotask(() {
            bus.emit("logout");
          });
          callback();
          Navigator.of(context).pop("退出");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildBar("设置"),
        body: Container(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              new Column(
                children: <Widget>[
                  new Container(
                    height: 50,
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    decoration: BoxDecoration(
                        border: new Border(
                            bottom: BorderSide(
                                color: UIData.border_color, width: 1))),
                    child: new GestureDetector(
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            child: Text(
                              "修改用户名",
                              style: TextStyles.RegularBlackTextSize16,
                            ),
                          ),
                          Text(
                            userInfo.name,
                            style: TextStyles.MediumBlackTextSize14,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: UIData.three_color,
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new EditNamePage()),
                        );
                      },
                    ),
                  ),
                  new Container(
                    height: 50,
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    decoration: BoxDecoration(
                        border: new Border(
                            bottom: BorderSide(
                                color: UIData.border_color, width: 1))),
                    child: new GestureDetector(
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            child: Text(
                              "修改密码",
                              style: TextStyles.RegularBlackTextSize16,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: UIData.three_color,
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new EditPassWordPage()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              RoundBtn(
                content: "退出登录",
                onPress: () {
                  sureDiaLog();
                },
              )
            ],
          ),
        ));
  }
}
