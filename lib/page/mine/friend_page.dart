import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wq_fotune/api/Mine.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/componets/circular_load.dart';
import 'package:wq_fotune/componets/custom_btn.dart';
import 'package:wq_fotune/componets/refresh.dart';
import 'package:wq_fotune/model/user_info.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/UIData.dart';
import 'package:wq_fotune/utils/toast-utils.dart';

import 'package:wq_fotune/page/mine/view/friend_share.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class FriendPage extends StatefulWidget {
  final UserInfo userInfo;

  const FriendPage({Key key, this.userInfo}) : super(key: key);

  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  Map data;
  String msg = "";
  List list = [];
  String total;
  EasyRefreshController _controller = EasyRefreshController();
  FirendShare _share = FirendShare();
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    MineAPI.getWalletTotalRebate().then((res) {
      if (res.code == 0) {
        setState(() {
          data = res.data;
          list = res.data['record'];
          total = res.data['total'].toString();
        });
      } else {
        setState(() {
          data = {};
          msg = res.msg;
          total = '0';
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBar("邀请好友"),
      body: buildBody(),
    );
  }

  buildBody() {
    Size size = MediaQuery.of(context).size;
    if (data == null) {
      return CircularLoading();
    }
    return CommonRefresh(
      controller: _controller,
      sliverList: SliverList(
        delegate: SliverChildListDelegate(
          [
            Container(
                child: Container(
              padding: EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 24.0),
              width: size.width,
              constraints: BoxConstraints(
                minHeight: size.height,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg@3x.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: new Column(
                children: [
                  new Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/card@3x.png"),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: new BorderRadius.circular(12)),
                    child: new Column(
                      children: [
                        new Container(
                          height: 132,
                          padding: EdgeInsets.only(top: 28.0),
                          child: new Column(
                            children: [
                              Text(
                                '我的邀请码',
                                style: TextStyle(
                                  color: UIData.one_color,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                  child: Text(
                                    widget.userInfo.invitationCode,
                                    style: TextStyle(
                                        color: UIData.one_color,
                                        fontSize: 48,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  onLongPress: () {
                                    ClipboardData data = new ClipboardData(
                                        text: widget.userInfo.invitationCode);
                                    Clipboard.setData(data);
                                    showToast("复制成功");
                                  }),
                            ],
                          ),
                        ),
                        new Container(
                          height: 102,
                          padding: EdgeInsets.fromLTRB(20.0, 28.0, 0, 0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "邀请规则:",
                                style: TextStyle(
                                    color: UIData.one_color,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0),
                              ),
                              new Padding(padding: EdgeInsets.only(top: 6.0)),
                              Text(
                                "一个注册 5 IFC，购买会员终身返 40% 会员费",
                                style: TextStyle(
                                    fontSize: 12.0, color: UIData.one_color),
                              ),
                              new Padding(padding: EdgeInsets.only(top: 6.0)),
                              Row(
                                children: [
                                  // Text('没有开户，请去',style: TextStyle(
                                  //     fontSize: 12,
                                  //     color: UIData.three_color
                                  // ),),
                                  // Text("交易所开户",style: TextStyle(
                                  //     color: UIData.blue_color,
                                  //     fontSize: 12
                                  // ),)
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  new Padding(padding: EdgeInsets.only(top: 24.0)),
                  new Container(
                    padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 24.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.circular(12)),
                    child: new Column(
                      children: [
                        Text(
                          '返佣总额',
                          style: TextStyle(
                              color: UIData.one_color,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500),
                        ),
                        new Padding(padding: EdgeInsets.only(top: 2.0)),
                        Text(
                          total + 'IFC',
                          style: TextStyle(
                              color: UIData.red_color,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                        ),
                        new Padding(padding: EdgeInsets.only(top: 8.0)),
                        Container(
                          child: new Column(
                            children: [
                              _header(),
                              _list(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  new Padding(padding: EdgeInsets.only(top: 24.0)),
                  RoundBtn(
                    content: '邀请好友',
                    isPositioned: false,
                    onPress: () {
                      _share.showModel(context, widget.userInfo.invitationCode);
                      _share.shareImage();
                    },
                  )
                ],
              ),
            ))
          ],
        ),
      ),
      onRefresh: () {
        getData();
      },
    );
  }

  Widget _header() {
    return Container(
      child: new Row(
        children: [
          new Expanded(
            flex: 1,
            child: Text(
              '被邀请人手机',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: UIData.three_color,
              ),
            ),
          ),
          new Expanded(
            flex: 1,
            child: Text(
              '奖励金额',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: UIData.three_color,
              ),
            ),
          ),
          new Expanded(
            flex: 1,
            child: Text(
              '邀请时间',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: UIData.three_color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _list() {
    if (list == null || list.length == 0) {
      return Container(
        padding: EdgeInsets.only(top: 20.0),
        child: Text(
          msg,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: UIData.three_color,
            fontSize: 14.0,
          ),
        ),
      );
    }

    List<Widget> tilesData = [];
    Widget contentData;
    list.forEach((item) {
      tilesData.add(new Container(
        padding: EdgeInsets.only(top: 6.0),
        child: new Row(
          children: [
            new Expanded(
              flex: 1,
              child: Text(
                TextUtil.hideNumber(item['phone'].toString()),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: UIData.one_color,
                ),
              ),
            ),
            new Expanded(
              flex: 1,
              child: Text(
                '+' + item['volume'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: UIData.red_color,
                ),
              ),
            ),
            new Expanded(
              flex: 1,
              child: Text(
                item['date'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: UIData.one_color,
                ),
              ),
            ),
          ],
        ),
      ));
    });
    contentData = new Container(
      child: Column(
        children: tilesData,
      ),
    );
    return contentData;
  }
}
