import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:wq_fotune/api/robot.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/componets/circular_load.dart';
import 'package:wq_fotune/componets/custom_btn.dart';
import 'package:wq_fotune/componets/parameters_flnput_widget.dart';
import 'package:wq_fotune/componets/refresh.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/ui_data.dart';
import 'package:wq_fotune/utils/toast-utils.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class MarketParameters extends StatefulWidget {
  String id;
  String anchorSymbol;
  bool isRun;
  MarketParameters({this.id, this.isRun, this.anchorSymbol});
  State<StatefulWidget> createState() => new MarketParametersState();
}

class MarketParametersState extends State<MarketParameters> {
  EasyRefreshController _controller;
  @override
  bool isShow = false;

  var _minPriceController = new TextEditingController();
  var _maxPriceController = new TextEditingController();
//  var _totalSumController = new TextEditingController();
//   var _gridNumController = new TextEditingController();
  Map dataMap;
  bool check = false;

  void initState() {
    _controller = EasyRefreshController();
    super.initState();
    getData();
  }

  void getData() {
    RobotApi.getStrategySimple(widget.id).then((res) {
      print(res);
      if (res.code == 200) {
        setState(() {
          dataMap = res.data;
          if (res.data['type'] == 1 && widget.isRun == true) {
            isShow = true;
          }
          _minPriceController =
              TextEditingController.fromValue(TextEditingValue(
            text: res.data['minPrice'].toString(),
          ));
          _maxPriceController =
              TextEditingController.fromValue(TextEditingValue(
            text: res.data['maxPrice'].toString(),
          ));
          // _gridNumController = TextEditingController.fromValue(TextEditingValue(
          //   text: res.data['gridNum'].toString(),
          // ));
        });
      } else {
        setState(() {
          dataMap = {};
        });
      }
    });
  }

  void _postStrategyGridUpdate() {
    var params = {
      "exchange": dataMap['exchange'],
      "symbol": dataMap['symbol'],
      "gsid": widget.id,
      "minPrice": double.parse(_minPriceController.text.trim()),
      "maxPrice": double.parse(_maxPriceController.text.trim()),
      "isClosePosition": check
    };
    RobotApi.postStrategyGridUpdate(params).then((res) {
      print(res);
      if (res.code == 200) {
        showToast('??????????????????');
        Navigator.pop(context);
      } else {
        showToast(res.msg);
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBar('????????????'),
      body: buildBody(),
      backgroundColor: UIData.white_color,
    );
  }

  Widget buildBody() {
    if (dataMap == null) {
      return Center(child: CircularLoading());
    }
    return CommonRefresh(
      controller: _controller,
      sliverList: SliverList(
        delegate: SliverChildListDelegate(
          [contentWidget()],
        ),
      ),
      onRefresh: () {
//      loadData();
        _controller.resetLoadState();
      },
    );
  }

  Widget contentWidget() {
    if (dataMap['type'] == 2) {
      return Container(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.all(4.0)),
            new Text(
              "???????????????${dataMap['totalSum']}${widget.anchorSymbol}",
              style: TextStyles.RegularBlackTextSize14,
            ),
            Padding(padding: EdgeInsets.all(4.0)),
            new Text(
              "???????????????${dataMap['averageProfitRate']}",
              style: TextStyles.RegularBlackTextSize14,
            ),
            Padding(padding: EdgeInsets.all(4.0)),
            new Text("???????????????${dataMap['minPrice']}${widget.anchorSymbol}",
                style: TextStyles.RegularBlackTextSize14),
          ],
        ),
      );
    }
    if (isShow) {
      return Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.all(4.0)),
              new Row(
                children: <Widget>[
                  new Text(
                    "???????????????" +
                        dataMap['totalSum'].toString() +
                        "${widget.anchorSymbol}",
                    style: TextStyles.RegularBlackTextSize14,
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(4.0)),
              new Row(
                children: <Widget>[
                  new Text("??????????????? " + dataMap['gridNum'].toString() + " ???",
                      style: TextStyles.RegularBlackTextSize14),
                ],
              ),
              Padding(padding: EdgeInsets.all(4.0)),
              new Row(
                children: <Widget>[
                  new Text(
                      "????????????????????? " +
                          dataMap['minPrice'].toString() +
                          "${widget.anchorSymbol}",
                      style: TextStyles.RegularBlackTextSize14),
                ],
              ),
              Padding(padding: EdgeInsets.all(4.0)),
              new Row(
                children: <Widget>[
                  new Text(
                    "????????????????????? " +
                        dataMap['maxPrice'].toString() +
                        "${widget.anchorSymbol}",
                    style: TextStyles.RegularBlackTextSize14,
                  ),
                ],
              ),
            ],
          ));
    }
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(8.0)),
          new Text(
            "???????????????${dataMap['totalSum']}${widget.anchorSymbol}",
            style: TextStyles.RegularBlackTextSize14,
          ),
          Padding(padding: EdgeInsets.all(8.0)),
          new Text(
            "???????????????${dataMap['gridNum']}???",
            style: TextStyles.RegularBlackTextSize14,
          ),

          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: UIData.border_color, width: 1))),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 1,
                    child: Container(
                        child: new Text('????????????????????????(${widget.anchorSymbol})',
                            style: TextStyles.RegularBlackTextSize14))),
                Flexible(
                    flex: 1,
                    child: new ParametersFInputWidget(
                      isNumber: true,
                      onChanged: (String value) {
                        print(value);
                      },
                      controller: _minPriceController,
                    ))
              ],
            ),
          ),
          // Padding(padding: EdgeInsets.all(8.0)),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: UIData.border_color, width: 1))),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 1,
                    child: Container(
                        child: new Text('????????????????????????(${widget.anchorSymbol})',
                            style: TextStyles.RegularBlackTextSize14))),
                Flexible(
                    flex: 1,
                    child: new ParametersFInputWidget(
                      isNumber: true,
                      onChanged: (String value) {
                        print(value);
                      },
                      controller: _maxPriceController,
                    ))
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(8.0)),
          new Row(
            children: <Widget>[
              new Text(
                "???????????????",
                style: TextStyles.RegularGrey3TextSize12,
              ),
              new Checkbox(
                value: this.check,
                activeColor: UIData.blue_color,
                onChanged: (bool val) {
                  // val ????????????
                  this.setState(() {
                    this.check = !this.check;
                  });
                },
              )
            ],
          ),
//              Padding(padding: EdgeInsets.all(2.0)),
          new Row(
            children: <Widget>[
              new Text('?????????????????????????????????????????????????????????????????????????????????',
                  style: TextStyles.MediumRedTextSize12)
            ],
          ),
          Padding(padding: EdgeInsets.fromLTRB(4.0, 30.0, 4.0, 0)),
          RoundBtn(
            content: "????????????",
            isPositioned: false,
            onPress: () {
//                  Loading.show(context);
              _postStrategyGridUpdate();
            },
          )
        ],
      ),
    );
  }
}
