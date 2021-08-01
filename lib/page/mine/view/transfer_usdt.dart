import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/componets/custom_btn.dart';
import 'package:wq_fotune/componets/fInput_widget.dart';
import 'package:wq_fotune/componets/loding_btn.dart';
import 'package:wq_fotune/componets/wallet_flnput_widget.dart';
import 'package:wq_fotune/utils/UIData.dart';
import 'package:wq_fotune/api/Mine.dart';
import 'package:wq_fotune/componets/circular_load.dart';
import 'package:wq_fotune/utils/toast-utils.dart';

class TransferUsdt extends StatefulWidget{
  @override
  TransferUsdtState createState() => TransferUsdtState();
}

class TransferUsdtState extends State<TransferUsdt>{
  @override
  var _phoneController  = new TextEditingController();
  Map data;
  String volume = "";
  bool isIfc = true;
  bool isBtn = true;

  void initState(){
    super.initState();
    _phoneController.clear();
    postData(isIfc);
  }

  postData(isIfc) async{
    var params;
    if(isIfc){
      params = {
        "from":"IFC",
        "to":"USDT"
      };
    }else{
      params = {
        "to":"IFC",
        "from":"USDT"
      };
    }

    MineAPI.postWalletConvertCoinTips(params).then((res){
      if(res.code == 0){
        setState(() {
          data = res.data;
        });
      }else{
        setState(() {
          data = null;
        });
      }

    });
  }

  changeConvertCoin(isIfc,val) async{
    var params;
    if(isIfc){
      params = {
        "from":"IFC",
        "to":"USDT",
        "volume":val
      };
    }else{
      params = {
        "to":"IFC",
        "from":"USDT",
        "volume":val
      };
    }
    MineAPI.postWalletConvertCoin(params).then((res){
      if(res.code == 0){
        setState(() {
          volume = res.data['volume'].toString();
        });
      }else{
        setState(() {
          volume = "";
        });
      }
    });
  }

  _postWalletTransfer(isIfc){
    var params;
    var msg;
    if(!isBtn){
      showToast("操作过于频繁，请稍后再试");
      return;
    }
    if(isIfc){
      params = {
        "fromCoin":"IFC",
        "toCoin":"USDT",
        "fromCoinAmount":_phoneController.text.trim()
      };
      msg= "IFC参数不能为空";
    }else{
      params = {
        "toCoin":"IFC",
        "fromCoin":"USDT",
        "fromCoinAmount":_phoneController.text.trim()
      };
      msg= "USDT参数不能为空";
    }
    if(_phoneController.text.trim() == null || _phoneController.text.trim() == ""){
      showToast(msg);
      return;
    }
    showLoading();
    setState(() {
        isBtn = false;
    });
    MineAPI.postWalletTransfer(params).then((res){
      setState(() {
        isBtn = true;
      });
      if(res.code == 0){
        dismissLoad();
        Navigator.pop(context);
        showToast("划转成功");
      }else{
        dismissLoad();
        showToast(res.msg);
      }
     
    });

  }


  Widget build(BuildContext context){
    return Scaffold(
      appBar: buildBar("划转"),
      body: buildBody(),
    );
  }

  buildBody(){
    if(data == null){
      return Center(child: CircularLoading());
    }

    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: <Widget>[
        new Column(
          children: <Widget>[
            new Padding(padding: new EdgeInsets.only(top:8.0)),
            new Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child:new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 3,
                    child: new Text(isIfc ? "   IFC" : "   USDT" ,style: TextStyle(
                        color: Color.fromRGBO(51,51,51,1),
                        fontSize: 14.0
                    ),),
                  ),
                  Flexible(
                    flex: 1,
                    child: new WalletFInputWidget(
                      hintText: isIfc ? "输入IFC" : "输入USDT",
                      isNumber: true,
                      onChanged: (String value) {
                        changeConvertCoin(isIfc,value);
                      },
                      controller: _phoneController,
                    ),
                  ),
                ],
              ),
            ),
            new Padding(padding: new EdgeInsets.only(top:8.0)),
            new Row(
              children: <Widget>[
                new Text("   " + data['describe'],style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12.0
                ),),
              ],
            ),
            new Padding(padding: new EdgeInsets.all(10.0)),
            GestureDetector(
              child:  new Row(
                mainAxisAlignment:MainAxisAlignment.end,
                children: <Widget>[
                  Icon(Icons.cached,color:Color(0xFF333333),),
                  Text('互换     ',style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 14.0
                  ),)
                ],
              ),
              onTap: () {
                setState(() {
                  isIfc = !isIfc;
                  volume = "";
                });
                _phoneController.clear();
                postData(isIfc);

              },
            ),
            new Padding(padding: new EdgeInsets.all(10.0)),
            new Container(
              padding: EdgeInsets.fromLTRB(0,15.0,0,15.0),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child:new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 3,
                    child: new Text(isIfc ? "   可兑换USDT" : "   可兑换IFC",style: TextStyle(
                        color: Color.fromRGBO(51,51,51,1),
                        fontSize: 14.0
                    ),),
                  ),
                  Flexible(
                      flex: 1,
                      child:new Text(volume + "      ")
                  ),
                ],
              ),
            ),
          ],
        ),
        RoundBtn(
          content: "划转",
          onPress: () {
            _postWalletTransfer(isIfc);
          },
        )
      ],
    );
  }
}