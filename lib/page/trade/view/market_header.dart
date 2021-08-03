import 'package:flutter/material.dart';
import 'package:wq_fotune/api/robot.dart';
import 'package:wq_fotune/model/strategy.dart';
import 'package:wq_fotune/page/mine/view/del_modal_view.dart';
import 'package:wq_fotune/utils/toast-utils.dart';
import 'package:wq_fotune/utils/ui_data.dart';
import 'package:wq_fotune/componets/fInput_widget.dart';

class marketHeader extends StatelessWidget {
  final Strategy detailData;
  final Function tapRun;
  final Function refreshData;

  var _balanceController = new TextEditingController();
  var _apiController = new TextEditingController();

  marketHeader({Key key, this.detailData, this.tapRun, this.refreshData});

  @override
  Widget build(BuildContext context) {
    ShapeBorder shape = const RoundedRectangleBorder(
        side: BorderSide(color: UIData.primary_color),
        borderRadius: BorderRadius.all(Radius.circular(36)));
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "账户投资资金: ",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: UIData.blck_color),
              ),
              Padding(padding: EdgeInsets.only(right: 8)),
              Text(
                "${detailData.balance}",
                style: TextStyle(
                  fontSize: 15,
                  color: UIData.red_color,
                ),
              ),
              new Expanded(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      detailData.status == 0
                          ? "初始状态"
                          : detailData.status == 1
                              ? "运行中"
                              : "暂停",
                      style: TextStyle(color: UIData.red_color, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 6, 0, 0),
            child: Text(
              detailData.apiKey != "" ? detailData.apiKey : "还未绑定指定交易所",
              style: TextStyle(
                fontSize: 12,
                color: UIData.blck_color,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              MaterialButton(
                minWidth: 60.0,
                height: 30.0,
                color: UIData.blue_color,
                textColor: Colors.white,
                shape: shape,
                child: Text(
                  '设置资金',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                onPressed: () {
                  balanceDiaLog(context);
                },
              ),
              detailData.apiKey == ""
                  ? Container(
                      margin: EdgeInsets.only(left: 20),
                      child: MaterialButton(
                        minWidth: 60.0,
                        height: 30.0,
                        color: UIData.blue_color,
                        textColor: Colors.white,
                        shape: shape,
                        child: Text(
                          '设置API',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        onPressed: () async {
                          if (detailData.apiKey == "") {
                            var res =
                                await Navigator.pushNamed(context, '/exchange');
                            refreshData();
                            return;
                          }
                        },
                      ),
                    )
                  : Container(),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: MaterialButton(
                  minWidth: 60.0,
                  height: 30.0,
                  shape: shape,
                  color: UIData.blue_color,
                  textColor: Colors.white,
                  child: Text(
                    detailData.status == 0 ? "点击启动" : "点击暂停",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  onPressed: () {
                    tapRun();
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void balanceDiaLog(context) {
    showModelWithContentView(
        context,
        "设置初始资金",
        FInputWidget(
          hintText: "单位USDT",
          isNumber: true,
          onChanged: (String value) {
            print(value);
          },
          controller: _balanceController,
        ), (callback) {
      _setBalance(callback);
    });
  }

  void apiDiaLog(context) {
    showModelWithContentView(
        context,
        "设置api",
        FInputWidget(
          hintText: "请输入api",
          isNumber: true,
          onChanged: (String value) {
            print(value);
          },
          controller: _apiController,
        ), (callback) {
      _setApi(callback);
    });
  }

  // 设置初始资金
  _setBalance(callback) {
    var balance = _balanceController.text.trim();
    var params = {
      "strategy_id": detailData.strategyId,
      "balance": int.parse(balance)
    };
    SetBalance(params).then((res) {
      if (res.code != 0) {
        showToast(res.msg);
      } else {
        showToast('资金设置成功');
        callback();
        refreshData();
      }
    });
  }

  // 设置API
  _setApi(callback) {
    var api = _apiController.text.trim();
    var params = {"strategy_id": detailData.strategyId, "api_key": api};
    SetApi(params).then((res) {
      if (res.code != 0) {
        showToast(res.msg);
      } else {
        showToast('api设置成功');
        callback();
        refreshData();
      }
    });
  }
}
