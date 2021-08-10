import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/api/robot.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/componets/circular_load.dart';
import 'package:wq_fotune/componets/refresh.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/ui_data.dart';
import 'package:wq_fotune/utils/toast-utils.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class MarketChoiceTrade extends StatefulWidget {
  final String exchangeName;

  const MarketChoiceTrade({Key key, this.exchangeName}) : super(key: key);
  @override
  MarketChoiceTradeState createState() => MarketChoiceTradeState();
}

class MarketChoiceTradeState extends State<MarketChoiceTrade> {
  EasyRefreshController _controller = EasyRefreshController();
  List dataList;
  List selecteList = [];
  List mapData = []; //头部数据
  Map list = {}; //用来保存所有的数据
  Map dataMap; //用于保存选中数据
  Color _bgColor = Colors.white;
  int selectedIndex = -1;
  String searchVal = "";
  bool isCancel = false;
  int act = 0;
  int storAct = 1;
  TextEditingController _searchController = TextEditingController();
  FocusNode focusNodePassword = new FocusNode();
  FocusScopeNode focusScopeNode;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    getData(widget.exchangeName);
  }

  void getData(val) async {
    RobotApi.getSymbols(val).then((res) {
      print("getSymbols ----> $res");
      if (res.code == 0) {
        var data = res.data.keys.toList();
        setState(() {
          mapData = data;
          list = res.data;
          dataList = res.data[data[0]];
          selecteList = res.data[data[0]];
        });
        sort(storAct);
      } else {
        setState(() {
          mapData = [];
          list = {};
          dataList = [];
          selecteList = [];
        });
      }
    });
  }

  void goPre() {
    Navigator.of(context).pop(dataMap);
  }

  void sort(type) {
    if (type == 1) {
      //市值最高
      setState(() {
        dataList.sort((left, right) => double.parse(right['price'])
            .compareTo(double.parse(left['price'])));
      });
    } else {
      //涨跌幅最高
      var data = [];
      var highData = [];
      var lowData = [];
      var lowData1 = [];
      dataList.forEach((element) {
        var item = element;
        var change =
            element['change'].substring(0, element['change'].length - 1);
        item['change'] = change;
        if (element['change'].contains("-")) {
          lowData.add(item);
        } else {
          highData.add(item);
        }
      });
      highData.sort((left, right) => right['change'].compareTo(left['change']));
      lowData.forEach((element) {
        var item = element;
        var lowChange =
            element['change'].substring(1, element['change'].length);
        item['change'] = lowChange;
        lowData1.add(item);
      });
      lowData1.sort((left, right) => left['change'].compareTo(right['change']));
      highData.forEach((element) {
        var item = element;
        element['change'] = element['change'] + '%';
        data.add(item);
      });
      lowData1.forEach((element) {
        var item = element;
        element['change'] = '-' + element['change'] + '%';
        data.add(item);
      });
      setState(() {
        dataList = data;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBar('交易对', actions: [
        GestureDetector(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20.0, 20.0, 0),
            child: new Text(
              '确定',
              style: TextStyles.RegularBlackTextSize15,
            ),
          ),
          onTap: () {
            if (dataMap == null) {
              showToast("请选择交易对");
              return;
            }
            goPre();
          },
        )

        // IconButton(
        //   padding: EdgeInsets.only(right: 10),
        //   icon: Icon(
        //     Icons.check,
        //     size: 22,
        //   ),
        //   onPressed: () {

        //   },
        // ),
      ]),
      body: buildBody(),
      backgroundColor: Colors.white,
    );
  }

  buildBody() {
    if (dataList == null) {
      return CircularLoading();
    }
    return CommonRefresh(
      controller: _controller,
      sliverList: SliverList(
        delegate: SliverChildBuilderDelegate(
          buildItem,
          childCount: dataList.length + 2,
        ),
      ),
      onRefresh: () {
        loadData();
        _controller.resetLoadState();
      },
    );
  }

  Widget buildItem(context, index) {
    if (index == 0) {
      return _searchCurrency();
    }
    if (index == 1) {
      return _harderNav();
    }
    var dataIdx = index - 2;
//    print(dataIdx);
    return buildTradeItems(
      dataIdx,
      dataList[dataIdx],
    );
  }

  Widget _searchCurrency() {
    return Container(
      padding: new EdgeInsets.all(6.0),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.only(top: 6.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: UIData.border_color),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 50.0,
                            height: 20.0,
                            child:
                                Icon(Icons.search, color: UIData.three_color),
                          ),
                        ),
                        Expanded(
                            child: TextField(
                          controller: _searchController,
                          cursorColor: UIData.blue_color,
                          style: TextStyle(fontSize: 14.0),
                          onChanged: (value) {
                            //数据处理
                            List list = new List();
                            selecteList.forEach((element) {
                              var index = element['symbol'].indexOf('-');
                              var data = element['symbol'].substring(0, index);
                              if (data.contains(value.toUpperCase())) {
                                list.add(element);
                              }
                            });
                            setState(() {
                              searchVal = value;
                              dataList = list;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: '搜索币种',
                            border: InputBorder.none,
                            fillColor: UIData.blue_color,
                            hintStyle: TextStyle(fontSize: 14.0),
                          ),
                        )),
                        Offstage(
                          offstage: searchVal.isEmpty ? true : false,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                searchVal = '';
                                _searchController.clear();
                                dataList = selecteList;
                              });
                            },
                            child: Container(
                              width: 45,
                              height: 45,
                              child: Icon(Icons.cancel,
                                  color: Colors.grey, size: 17),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Offstage(
                offstage: searchVal.isEmpty ? true : false,
                child: GestureDetector(
                    onTap: () {
                      focusNodePassword.unfocus();
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        searchVal = '';
                      });
                    },
                    child: Center(
                      child: new Text(
                        "  取消  ",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: UIData.three_color),
                      ),
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _harderNav() {
    return Container(
      child: new Column(
        children: [
          new Container(
            padding: EdgeInsets.fromLTRB(2.0, 6.0, 2.0, 6.0),
            margin: EdgeInsets.fromLTRB(14.0, 10, 14.0, 10),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: _titleWidget(),
                ),
                Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        child: new Text('市值',
                            style: storAct == 1
                                ? TextStyles.RegularBlackTextSize14
                                : TextStyles.RegularGrey3TextSize14),
                        onTap: () {
                          setState(() {
                            storAct = 1;
                          });
                          sort(1);
                        },
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                        child: Text(
                          '|',
                          style: TextStyles.RegularGrey3TextSize14,
                        ),
                      ),
                      GestureDetector(
                        child: new Text('涨跌幅',
                            style: storAct != 1
                                ? TextStyles.RegularBlackTextSize14
                                : TextStyles.RegularGrey3TextSize14),
                        onTap: () {
                          setState(() {
                            storAct = 2;
                          });
                          sort(2);
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          new Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.fromLTRB(5.0, 0, 5.0, 1.0),
            // decoration: BoxDecoration(
            //     color: Colors.white,
            //     border: new Border(
            //         bottom: BorderSide(color: UIData.border_color, width: 0.5))),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child:
                        Text("交易对", style: TextStyles.RegularGrey3TextSize12)),
                Expanded(
                  child: Text(
                    "最新价",
                    style: TextStyles.RegularGrey3TextSize12,
                  ),
                ),
                Container(
                  width: 75.0,
                  height: 30,
                  child: Text(
                    "涨幅榜",
                    textAlign: TextAlign.left,
                    style: TextStyles.RegularGrey3TextSize12,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _titleWidget() {
    List<Widget> tiles = [];
    Widget content;
    List.generate(mapData.length, (index) {
      tiles.add(GestureDetector(
        child: new Container(
          padding: EdgeInsets.fromLTRB(0, 6.0, 0, 6.0),
          decoration: BoxDecoration(
              border: new Border(
                  bottom: BorderSide(
                      color: index == act ? UIData.blue_color : Colors.white,
                      width: 2))),
          margin: EdgeInsets.only(right: 24.0),
          child: new Text(mapData[index],
              style: index == act
                  ? TextStyles.MediumGrey3TextSize15
                  : TextStyles.MediumBlackTextSize15),
        ),
        onTap: () {
          setState(() {
            dataList = list[mapData[index]];
            act = index;
          });
        },
      ));
    });
    // mapData.forEach((element) {
    //
    // });
    content = new Row(children: tiles);
    return content;
  }

  Widget buildTradeItems(int index, Map data) {
    var indexData = data['symbol'].indexOf("-");
    var left = data['symbol'].substring(0, indexData);
    var right = data['symbol'].substring(indexData + 1);
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.fromLTRB(10.0, 18, 10, 18),
        margin: EdgeInsets.fromLTRB(5.0, 0, 5.0, 1.0),
        decoration: BoxDecoration(
          color: selectedIndex == index ? UIData.border_color : Colors.white,
          border: new Border(
            bottom: BorderSide(color: UIData.border_color, width: 0.5),
          ),
        ),
        child: new Column(
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: new Row(
                    children: <Widget>[
                      new Text(
                        left,
                        style: TextStyles.MediumBlackTextSize16,
                      ),
                      new Text(
                        " / ",
                        style: TextStyles.RegularGrey3TextSize12,
                      ),
                      new Text(
                        right,
                        style: TextStyles.RegularGrey3TextSize12,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      '${data['price']}',
                      textAlign: TextAlign.left,
                      style: TextStyles.MediumBlackTextSize16,
                    ),
                  ),
                ),
                AnimatedContainer(
                  width: 75.0,
                  height: 30,
                  decoration: BoxDecoration(
                    color: data['change'].contains("-")
                        ? UIData.red_color
                        : UIData.turquoise_color,
                    borderRadius: BorderRadius.circular(4), //圆角
                  ),
                  duration: Duration(milliseconds: 300),
                  alignment: Alignment.center,
                  child: Text(
                    data['change'],
                    textAlign: TextAlign.center,
                    style: TextStyles.MediumWhiteTextSize13,
                  ),
                )
              ],
            )
          ],
        ),
      ),
      onTap: () {
        setState(() {
          dataMap = data;
          selectedIndex = index;
        });
      },
    );
  }
}
