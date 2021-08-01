import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/componets/custom_btn.dart';
import 'package:wq_fotune/utils/toast-utils.dart';
import 'package:wq_fotune/utils/UIData.dart';

import 'package:wq_fotune/api/Mine.dart';

class Consult extends StatefulWidget {
  @override
  ConsultState createState() => ConsultState();
}

class ConsultState extends State<Consult> {
  String image = '';
  String content = '';
  String contact = '';

  void initState() {
    super.initState();
    this.loadData();
  }

  loadData() {
    MineAPI.commonContact().then((res) => {
          if (res.code != 0)
            {}
          else
            {
              setState(() {
                print(res.data);
                image = res.data["image"];
                content = res.data["content"];
                contact = res.data["contact"];
              })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildBar("客服"),
        body: Container(
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Padding(padding: new EdgeInsets.all(20.0)),
                  new Image.network(
                    image,
                    width: 120.0,
                    height: 120.0,
                  ),
                  new Padding(padding: new EdgeInsets.all(10.0)),
                  new Text(
                    content,
                    style: TextStyle(
                        fontSize: 18, color: UIData.blck_color, height: 2),
                  ),
                  new Text(
                    contact,
                    style: TextStyle(
                        fontSize: 18, color: UIData.blck_color, height: 2),
                  )
                ],
              ),
              RoundBtn(
                content: "复制微信号",
                isPositioned: true,
                onPress: () {
                  ClipboardData data = new ClipboardData(text: contact);
                  Clipboard.setData(data);
                  showToast("复制成功");
                },
              )
            ],
          ),
        ));
  }
}
