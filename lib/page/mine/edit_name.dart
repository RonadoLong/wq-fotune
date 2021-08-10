import 'package:flutter/material.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/componets/fInput_widget.dart';
import 'package:wq_fotune/componets/custom_btn.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/api/user.dart';
import 'package:wq_fotune/utils/toast-utils.dart';

class EditNamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new EditNamerState();
  }
}

class EditNamerState extends State<EditNamePage> {
  var _userNameController = new TextEditingController();
  @override
  void _resetName() {
    var name = _userNameController.text.trim();
    if (name.length == 0) {
      showToast("昵称不能为空");
      return;
    }
    var avatar = "";
    var params = {"name": name, "avatar": avatar};
    UserApi.updateUser(params).then((res) {
      if (res.code != 0) {
        showToast(res.msg);
      } else {
        //这里改把userinfo的name字段改了
        Navigator.of(context).pop();
        showToast("昵称修改成功");
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildBar("昵称"),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Container(
                  margin: EdgeInsets.all(20),
                  child: FInputWidget(
                    hintText: "请输入昵称",
                    onChanged: (String value) {},
                    controller: _userNameController,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(left: 25),
                  child: new Text("设置后，其他人将看到你的昵称。",
                      style: TextStyles.RegularGrey2TextSize14),
                ),
                new Padding(padding: new EdgeInsets.only(top: 100.0)),
              ],
            ),
            RoundBtn(
                content: "确定修改",
                onPress: () {
                  this._resetName();
                }),
          ],
        ));
  }
}
