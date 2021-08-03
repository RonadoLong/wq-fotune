import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/api/mine.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/componets/circular_load.dart';
import 'package:wq_fotune/model/exchange_account.dart';
import 'package:wq_fotune/page/common/CommonWidget.dart';
import 'package:wq_fotune/utils/toast-utils.dart';
import 'package:wq_fotune/utils/ui_data.dart';

class ExchangeDetails extends StatefulWidget {
  @override
  ExchangeDetailsState createState() => ExchangeDetailsState();
}

class ExchangeDetailsState extends State<ExchangeDetails> {
  ExchangeAccount _exchangeAccount;
  List<Widget> contentView;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() {
    MineAPI.getExchangeAccountList().then((res) {
      if (res.code == 0) {
        setState(() {
          _exchangeAccount = ExchangeAccount.fromJson(res.data);
        });
      } else {
        setState(() {
          _exchangeAccount = ExchangeAccount();
        });
        showToast(res.msg);
      }
    }).catchError((onError) => {showToast("网络出错")});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildBar("交易所详情"), body: buildBody());
  }

  Widget buildBody() {
    if (_exchangeAccount == null) {
      return CircularLoading();
    }
    if (_exchangeAccount.exchange_pos == null ||
        _exchangeAccount.exchange_pos.isEmpty) {
      return buildEmptyView(title: "账户没有对应的品种资金, 请入金", heightFactor: 4);
    }
    List<Widget> contentView = List();
    contentView.add(buildHeader());
    contentView.addAll(
        _exchangeAccount.exchange_pos.map((e) => buildItem(e)).toList());
    return ListView(
      children: contentView,
    );
  }

  Widget buildHeader() {
    return new Container(
      padding: EdgeInsets.all(15.0),
      child: new Text(
        "当前账户",
        style: TextStyle(
          fontSize: 18,
          color: UIData.primary_color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildItem(ExchangePo exchangePo) {
    return new Container(
      padding: EdgeInsets.fromLTRB(15.0, 15, 15.0, 15.0),
      margin: EdgeInsets.fromLTRB(6, 0, 6, 6),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: UIData.border_color,
              offset: Offset(0, 3),
              blurRadius: 10,
              spreadRadius: 1),
        ],
      ),
      child: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Text(
                "${exchangePo.type == 'spot' ? '现货' : '期货'}: ${exchangePo.symbol}",
                style: TextStyle(
                  color: UIData.blck_color,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Text(
                "余额: ${exchangePo.balance}",
                style: TextStyle(
                  color: UIData.blck_color,
                  fontSize: 14,
                  height: 3,
                ),
              ),
              new Text(
                "可用:   ${exchangePo.available}",
                style: TextStyle(
                  color: UIData.blck_color,
                  fontSize: 14,
                  height: 3,
                ),
              ),
              new Text(
                "冻结:   ${exchangePo.frozen}",
                style: TextStyle(
                  color: UIData.blck_color,
                  fontSize: 14,
                  height: 3,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
