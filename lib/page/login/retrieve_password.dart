import 'package:flutter/material.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/componets/custom_btn.dart';
import 'package:wq_fotune/componets/fInput_widget.dart';
import 'package:wq_fotune/utils/toast-utils.dart';
import 'package:wq_fotune/api/User.dart';
import 'package:wq_fotune/utils/MD5Utils.dart';
import 'package:wq_fotune/page/login/login_page.dart';

class RetrievePasswordPage extends StatefulWidget {
  final String phone, code;
  RetrievePasswordPage(this.phone,this.code);
  @override
  State<StatefulWidget> createState() {
    return new RetrievePasswordState(phone, code);
  }
}

class RetrievePasswordState extends State<RetrievePasswordPage>{
  String phone, code;
  RetrievePasswordState(this.phone,this.code);
  var _userPassController = new TextEditingController();
  var _userAgainPassController = new TextEditingController();

  void _forgetPassword() {
    var userPass = _userPassController.text.trim();
    var userAgainPass = _userAgainPassController.text.trim();
    if (userPass.length == 0 || userPass.length == 0) {
      showToast("密码不能为空");
      return;
    }
    if (userAgainPass != userAgainPass) {
      showToast("两个密码不同");
      return;
    }
    var userPassData = StringToMd5(userPass);
    var userAgainPassData = StringToMd5(userAgainPass);
    var params = {
      "phone": this.phone,
      "validate_code": this.code,
      "password": userPassData,
      "confirm_password": userAgainPassData
    };
    ForgetPassword(params).then((res){
      if(res.code != 0){
        showToast(res.msg);
      }else{
        showToast("设置密码成功");
        Navigator.push(context, new MaterialPageRoute(
            builder: (context) =>
            new LoginPage())
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBar("设置密码"),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(left: 20.0, top: 30, right: 20.0, bottom: 0.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new FInputWidget(
                  hintText: "输入新密码",
                  obscureText: true,
                  onChanged: (String value) {
                    print(value);
                  },
                  controller: _userPassController,
                ),
                new Padding(padding: new EdgeInsets.all(10.0)),
                new FInputWidget(
                  hintText: "确认新密码",
                  obscureText: true,
                  onChanged: (String value) {
                    print(value);
                  },
                  controller: _userAgainPassController,
                ),
              ],
            ),
          ),
          RoundBtn(content: "确认并前往登录", onPress: (){
            this._forgetPassword();
          },)
        ],
      ),
    );
  }

}

