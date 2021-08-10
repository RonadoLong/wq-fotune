import 'package:flutter/material.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/common/NavigatorUtils.dart';
import 'package:wq_fotune/componets/fInput_widget.dart';
import 'package:wq_fotune/utils/ui_data.dart';
import 'package:wq_fotune/utils/md5.dart';
import 'package:wq_fotune/api/user.dart';
import 'package:wq_fotune/utils/toast-utils.dart';

class EditPassWordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new EditPassWordState();
  }
}

class EditPassWordState extends State<EditPassWordPage> {
  var _passwordController = new TextEditingController();
  var _confirmPasswordController = new TextEditingController();

  void _ResetPassword() {
    var password = _passwordController.text.trim();
    var confirm_password = _confirmPasswordController.text.trim();
    if (password.length == 0 || confirm_password.length == 0) {
      showToast("密码不能为空");
      return;
    }
    if (password != confirm_password) {
      showToast("两个密码不同");
      return;
    }
    var passwordData = StringToMd5(password);
    var confirm_passwordData = StringToMd5(confirm_password);
    var params = {
      "password": passwordData,
      "confirm_password": confirm_passwordData
    };
    UserApi.resetPassword(params).then((res) {
      if (res.code != 0) {
        showToast(res.msg);
      } else {
        showToast("修改密码成功，请重新登录");
        gotoLoginPage(context, route: '/');
      }
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildBar("设置新密码"),
        body: new Container(
          child: SafeArea(
              child: SingleChildScrollView(
            child: new Padding(
              padding: new EdgeInsets.only(
                  left: 20.0, top: 20, right: 20.0, bottom: 0.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FInputWidget(
                    hintText: "输入新密码",
                    onChanged: (String value) {
                      print(value);
                    },
                    controller: _passwordController,
                  ),
                  new Padding(padding: new EdgeInsets.all(10.0)),
                  FInputWidget(
                    hintText: "确认新密码",
                    onChanged: (String value) {
                      print(value);
                    },
                    controller: _confirmPasswordController,
                  ),
                  new Padding(padding: new EdgeInsets.all(10.0)),
                  new Container(
                    width: 460.0,
                    margin: new EdgeInsets.fromLTRB(0, 20.0, 10.0, 0.0),
                    child: new Card(
                      color: UIData.primary_color,
                      elevation: 4.0,
                      child: new FlatButton(
                          onPressed: () {
                            this._ResetPassword();
                          },
                          child: new Padding(
                            padding: new EdgeInsets.all(1.0),
                            child: new Text(
                              '确认修改',
                              style: new TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ));
  }
}
