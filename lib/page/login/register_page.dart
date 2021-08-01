import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/common/load_recommned.dart';
import 'package:wq_fotune/componets/custom_btn.dart';
import 'package:wq_fotune/page/home/view/download_app.dart';
import 'package:wq_fotune/page/mine/secret_page.dart';
import 'package:wq_fotune/utils/UIData.dart';
import 'package:wq_fotune/componets/fInput_widget.dart';
import 'package:wq_fotune/utils/toast-utils.dart';
import 'package:wq_fotune/componets/login_form_code.dart';
import 'package:wq_fotune/api/User.dart';
import 'package:wq_fotune/page/login/login_page.dart';
import 'package:wq_fotune/utils/MD5Utils.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RegisterState();
  }
}

class RegisterState extends State<RegisterPage> {
  bool check = false;
  bool isPhone = false;
  bool userPass = false;
  bool confirmPassword = false;
  bool isRecommend = false;

  var _userPassController = new TextEditingController();
  var _confirmPasswordController = new TextEditingController();
  var _phoneController = new TextEditingController();
  var _validateCodeController = new TextEditingController();
  var _invitationCodeController = new TextEditingController();

  void _userRegister() {
    var phone = _phoneController.text.trim();
    var password = _userPassController.text.trim();
    var confirm_password = _confirmPasswordController.text.trim();
    var invitation_code = _invitationCodeController.text.trim();
    var validate_code = _validateCodeController.text.trim();
    var passwordData = StringToMd5(password);
    var confirm_passwordData = StringToMd5(confirm_password);
    if (phone.length < 11) {
      showToast("填写手机");
      return;
    }
    var regPassword = new RegExp('^[a-zA-Z0-9_]{6,20}\$').hasMatch(password);
    if (!regPassword) {
      showToast("6-20个字母、数字、下划线的组合");
      return;
    }
    if (password != confirm_password) {
      showToast("密码不一致");
      return;
    }
    var params = {
      "phone": phone,
      "name": "",
      "password": passwordData,
      "confirm_password": confirm_passwordData,
      "invitation_code": invitation_code,
      "validate_code": validate_code
    };
    userRegister(params).then((res) {
      if (res.code != 0) {
        showToast(res.msg);
      } else {
        showToast("注册成功，请重新登陆");
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new LoginPage(isRegister: true)));
      }
    });
  }

//  事件监听
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _userPassFocusNode = FocusNode();
  FocusNode _uconfirmpassword = FocusNode();

  @override
  void initState() {
    super.initState();

    String code = getRecommendFromRegister();
    if (code != null && code.length > 0) {
      _invitationCodeController.text = code;
      setState(() {
        isRecommend = true;
      });
    }

    code = SpUtil.getString(recommendKey);
    if (code != null && code.length > 0) {
      _invitationCodeController.text = code;
      setState(() {
        isRecommend = true;
      });
    }

    //手机号码输入框焦点
    _phoneFocusNode.addListener(() {
      if (!_phoneFocusNode.hasFocus) {
        var phone = _phoneController.text.trim();
        if (phone.length != 11) {
          setState(() {
            isPhone = true;
          });
        } else {
          setState(() {
            isPhone = false;
          });
        }
      }
      ;
    });
    //密码
    _userPassFocusNode.addListener(() {
      if (!_userPassFocusNode.hasFocus) {
        var password = _userPassController.text.trim();
        var regPassword =
            new RegExp('^[a-zA-Z0-9_]{6,20}\$').hasMatch(password);
        if (!regPassword) {
          setState(() {
            userPass = true;
          });
        } else {
          setState(() {
            userPass = false;
          });
        }
      }
    });
    //确认密码
    _uconfirmpassword.addListener(() {
      if (!_uconfirmpassword.hasFocus) {
        var password = _userPassController.text.trim();
        var confirm_password = _confirmPasswordController.text.trim();
        if (password != confirm_password) {
          setState(() {
            confirmPassword = true;
          });
        } else {
          setState(() {
            confirmPassword = false;
          });
        }
      }
    });
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: buildBar("注册"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: new Column(
            children: [
              DownloadApp(),
              new Padding(
                padding: new EdgeInsets.all(20.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(padding: new EdgeInsets.all(8.0)),
                    Visibility(
                        child: new Text(
                          "请输入有效的手机号码",
                          style: TextStyle(
                              fontSize: 12, color: UIData.red_color, height: 2),
                        ),
                        visible: this.isPhone),
                    new FInputWidget(
                      hintText: "输入手机号码",
                      isNumber: true,
                      focusNode: _phoneFocusNode,
                      onChanged: (String value) {
                        print(value);
                      },
                      controller: _phoneController,
                    ),
                    new Padding(padding: new EdgeInsets.all(10.0)),
                    Visibility(
                        child: new Text(
                          "6-20个字母、数字、下划线的组合",
                          style: TextStyle(
                              fontSize: 12, color: UIData.red_color, height: 2),
                        ),
                        visible: this.userPass),
                    new FInputWidget(
                      hintText: "6-20个字母、数字、下划线的组合",
                      obscureText: true,
                      focusNode: _userPassFocusNode,
                      onChanged: (String value) {
                        print(value);
                      },
                      controller: _userPassController,
                    ),
                    new Padding(padding: new EdgeInsets.all(10.0)),
                    Visibility(
                        child: new Text(
                          "新密码跟旧密码不一致",
                          style: TextStyle(
                              fontSize: 12, color: UIData.red_color, height: 2),
                        ),
                        visible: this.confirmPassword),
                    new FInputWidget(
                      hintText: "确认密码",
                      obscureText: true,
                      focusNode: _uconfirmpassword,
                      onChanged: (String value) {
                        print(value);
                      },
                      controller: _confirmPasswordController,
                    ),
                    new Padding(padding: new EdgeInsets.all(10.0)),
                    new FInputWidget(
                      hintText: "推荐码",
                      enabled: !isRecommend,
                      onChanged: (String value) {
                        print(value);
                      },
                      controller: _invitationCodeController,
                    ),
                    new Padding(padding: new EdgeInsets.all(10.0)),
                    new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          flex: 4,
                          child: new FInputWidget(
                            hintText: "请输入验证码",
                            isNumber: true,
                            obscureText: true,
                            onChanged: (String value) {
                              print(value);
                            },
                            controller: _validateCodeController,
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
                    new Padding(padding: new EdgeInsets.all(30.0)),
                    RoundBtn(
                      content: '同意以下协议并注册',
                      isPositioned: false,
                      onPress: () {
                        this._userRegister();
                      },
                    ),
                    new Padding(padding: new EdgeInsets.all(10.0)),
                    new Row(
                      children: <Widget>[
                        new Checkbox(
                          value: this.check,
                          activeColor: UIData.blue_color,
                          onChanged: (bool val) {
                            // val 是布尔值
                            this.setState(() {
                              this.check = !this.check;
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new SecretPage()));
                          },
                          child: new Text(
                            "《注册协议》",
                            style: TextStyle(
                                color: Color.fromRGBO(191, 191, 191, 1),
                                fontSize: 14),
                          ),
                        )
                      ],
                    ),
                    new Padding(padding: new EdgeInsets.all(10.0)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
