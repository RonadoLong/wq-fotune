import 'dart:async';

import 'package:flutter/material.dart';

import 'package:wq_fotune/api/user.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/common/CustomLogImage.dart';
import 'package:wq_fotune/componets/fInput_widget.dart';
import 'package:wq_fotune/componets/custom_btn.dart';
import 'package:wq_fotune/global.dart';
import 'package:wq_fotune/model/user_info.dart';
import 'package:wq_fotune/utils/md5.dart';
import 'package:wq_fotune/utils/toast-utils.dart';
import 'package:wq_fotune/utils/ui_data.dart';

import '../../main_page.dart';
import 'forget_pwd_page.dart';

class LoginPage extends StatefulWidget {
  bool isRegister;
  LoginPage({this.isRegister});
  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  var leftRightPadding = 20.0;
  var topBottomPadding = 4.0;
  var textTips = new TextStyle(fontSize: 16.0, color: Colors.black);
  var hintTips = new TextStyle(fontSize: 15.0, color: Colors.black26);
  var _userPassController = new TextEditingController();
  var _userNameController = new TextEditingController();

  void _login() {
    var phone = _userNameController.text.trim();
    var password = _userPassController.text.trim();
    if (phone.length < 11 || password.length == 0) {
      showToast("填写手机或者密码");
      return;
    }
    var pwd = StringToMd5(password);
    var params = {
      "phone": phone,
      "password": pwd,
    };
    Login(params).then((res) {
      if (res.code != 0) {
        showToast(res.msg);
        return;
      }

      Global.saveUserInfo(UserInfo.fromJson(res.data)).then((_) {
        showToast("登录成功");
        scheduleMicrotask(() {
          Global.eventBus.emit("login", "");
        });
        dynamic obj = ModalRoute.of(context).settings.arguments;
        if (obj != null) {
          String name = obj["route"];
          Navigator.popUntil(context, ModalRoute.withName(name));
        } else {
          if (widget.isRegister == null) {
            Navigator.of(context).pop('exit log');
          } else {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new MainPageWidget()));
          }
        }
      });
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildBar("登录"),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: new Padding(
                padding: new EdgeInsets.only(
                    left: 30.0, top: 70.0, right: 30.0, bottom: 0.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    buildLogImage(null, height: 80, width: 80),
                    new Padding(padding: new EdgeInsets.all(10.0)),
                    new FInputWidget(
                      hintText: "输入手机号",
                      isNumber: true,
                      onChanged: (String value) {
                        print(value);
                      },
                      controller: _userNameController,
                    ),
                    new Padding(padding: new EdgeInsets.all(10.0)),
                    new FInputWidget(
                      hintText: "输入密码",
                      obscureText: true,
                      onChanged: (String value) {
                        print(value);
                      },
                      controller: _userPassController,
                    ),
                    new Container(
                      padding: EdgeInsets.only(top: 10.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          new ForgetPWDPage()));
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Text(
                                "忘记密码?",
                                textAlign: TextAlign.left,
                                style: TextStyle(color: UIData.blck_color),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 8),
                              child: Text(
                                "注册新账号",
                                textAlign: TextAlign.left,
                                style: TextStyle(color: UIData.primary_color),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Padding(padding: new EdgeInsets.all(50.0)),
                    RoundBtn(
                      content: '登录',
                      isPositioned: false,
                      onPress: () {
                        this._login();
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
