import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wq_fotune/api/Mine.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/componets/circular_load.dart';
import 'package:wq_fotune/utils/UIData.dart';
import 'package:wq_fotune/utils/toast-utils.dart';

class RechargeUsdt extends StatefulWidget{
  @override
  RechargeUsdtState createState() => RechargeUsdtState();
}

class RechargeUsdtState extends State<RechargeUsdt>{
  Map data;
  @override
  void initState(){
    super.initState();
    getData();
  }

   getData() async{
    MineAPI.usdtDepositAddr().then((res){
     if(res.code == 0){
       setState(() {
         data = res.data;
       });
       print(data);
     }

    });
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: buildBar("充值USDT"),
      body: buildBody(),
    );
  }

  buildBody(){
    ShapeBorder shape = const RoundedRectangleBorder(
        side: BorderSide(color: UIData.border_color),
        borderRadius: BorderRadius.all(Radius.circular(10)));
    if(data == null){
      return Center(child: CircularLoading());
    }

    return new Container(
      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      child: new Center(
        child: new Column(
          children: <Widget>[
            new Padding(padding: new EdgeInsets.all(20.0)),
            new Text("erc20-usdt充值地址",style: TextStyle(
                fontSize: 12.0,
                color: UIData.default_color
            ),),
            new Padding(padding: new EdgeInsets.all(6.0)),
            new Text(data['address'],style: TextStyle(
                fontSize: 16.0,
                fontWeight:FontWeight.w500
            ),),
            new Padding(padding: new EdgeInsets.all(10.0)),
            MaterialButton(
              minWidth: 80.0,
              height: 36.0,
              color: Colors.white,
              textColor: UIData.grey_color,
              shape: shape,
              child: new Text(
                '复制地址',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              onPressed: () {
                ClipboardData data =
                new ClipboardData(text: this.data['address']);
                Clipboard.setData(data);
                showToast("复制成功");
              },
            ),
            new Padding(padding: new EdgeInsets.all(10.0)),
            new Text("充值需要6个节点确认，大约需要3分钟",style: TextStyle(
                fontSize: 12.0,
                color: UIData.default_color
            ),),
          ],
        ),
      ),
    );
  }
}