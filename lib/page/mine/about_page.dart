import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/api/common.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/componets/circular_load.dart';
import 'package:wq_fotune/page/mine/secret_page.dart';
import 'package:wq_fotune/page/mine/view/about_item.dart';
import 'package:wq_fotune/utils/ui_data.dart';
import 'package:wq_fotune/utils/device_utils.dart';

class AboutdPage extends StatefulWidget {
  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutdPage> {
  List<String> cellTitle = ["用户协议", "检查更新"];
  Map data;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    var params = Device.isAndroid ? 1 : 2;
    CommonApi.getAppVersion(params).then((res) {
      if (res.code == 0) {
        setState(() {
          data = res.data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBar("关于我们"),
      body: buildBody(),
    );
  }

  buildBody() {
    if (data == null) {
      return Center(child: CircularLoading());
    }
    return Container(
      child: new Column(
        children: <Widget>[
          HeaderContainer(),
          NavCcontainer(),
        ],
      ),
    );
  }

  HeaderContainer() {
    return Center(
      child: new Column(
        children: <Widget>[
          new Container(
            margin: EdgeInsets.fromLTRB(0, 90.0, 0, 0),
            child: new Text(
              "iFortune",
              style: TextStyle(
                color: UIData.grey_color,
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          new Container(
            margin: EdgeInsets.fromLTRB(0, 10.0, 0, 30.0),
            child: new Text(
              "版本" + data['versionName'],
              style: TextStyle(
                color: Colors.blueGrey.shade500,
                fontSize: 13.0,
              ),
            ),
          ),
//           ImageWidget(
//             url:data['download_code'],
//             w:160.0,
//             h:160.0,
//             defImagePath:"assets/images/empty.png"
//           ),
//           new Image.network(data['download_code'],width: 160.0,
//             height: 160.0,),
//           new Container(
//             margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
//             child: new Text("扫描二维码，可直接下载",style: TextStyle(
//               color: Colors.blueGrey.shade500,
//               fontSize: 13.0,
//             ),),
//           )
        ],
      ),
    );
  }

  NavCcontainer() {
    List<Widget> cells = [];
    for (int i = 0; i < cellTitle.length; i++) {
      String title = cellTitle[i];
      cells.add(About(
        title: title,
        onTap: () {
          switch (i) {
            case 0:
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new SecretPage()));
              break;
            default:
              loadData();
            //更新的逻辑
          }
        },
      ));
    }
    return Container(
      child: Column(
        children: cells,
      ),
    );
  }
}
