import 'package:flutter/material.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/componets/fInput_widget.dart';
import 'package:wq_fotune/componets/login_form_code.dart';
import 'package:wq_fotune/componets/custom_btn.dart';
import 'package:wq_fotune/utils/toast-utils.dart';
import 'package:wq_fotune/page/login/retrieve_password.dart';
import 'package:wq_fotune/api/user.dart';

class ForgetPWDPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ForgetPWDPageState();
  }
}

class _ForgetPWDPageState extends State<ForgetPWDPage> {
  var leftRightPadding = 20.0;
  var topBottomPadding = 4.0;
  var textTips = new TextStyle(fontSize: 13.0, color: Colors.black);
  var hintTips = new TextStyle(fontSize: 13.0, color: Colors.blueGrey);
  bool isCanGetCode = false;
  bool isLogin = false;

  var _userPassController = new TextEditingController();
  var _phoneController = new TextEditingController();
  var _codeController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBar("忘记密码"),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
                left: 20.0, top: 30, right: 20.0, bottom: 0.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new FInputWidget(
                  hintText: "手机号",
                  isNumber: true,
                  onChanged: (String value) {
                    print(value);
                  },
                  controller: _phoneController,
                ),
                new Padding(padding: new EdgeInsets.all(10.0)),
                Container(
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 3,
                        child: new FInputWidget(
                          hintText: "验证码",
                          isNumber: true,
                          onChanged: (String value) {
                            print(value);
                          },
                          controller: _codeController,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: LoginFormCode(
                          available: _phoneController.text.trim().length >= 11,
                          onTapCallback: () {
                            var phone = _phoneController.text.trim();
                            if (phone.length == 0 || phone.length < 11) {
                              showToast("请填写正确的手机号");
                              return;
                            }
                            var params = {"phone": phone.toString()};
                            PostCode(params).then((res) {
                              print("获取验证码 =========== $res");
                              if (res.code == 0) {
                                showToast("获取成功");
                              } else {
                                showToast(res.msg);
                              }
                            }).catchError((err) {
                              print(err);
                              showToast("获取失败，请重试");
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          RoundBtn(
              content: "下一步",
              onPress: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new RetrievePasswordPage(
                            _phoneController.text.trim(),
                            _codeController.text.trim())));
              })
        ],
      ),
    );
  }
}
