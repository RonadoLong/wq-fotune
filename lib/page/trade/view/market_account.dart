import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wq_fotune/api/Mine.dart';
import 'package:wq_fotune/api/User.dart';
import 'package:wq_fotune/common/EventBus.dart';
import 'package:wq_fotune/common/NavigatorUtils.dart';
import 'package:wq_fotune/componets/flutter_k_chart/utils/date_format_util.dart';
import 'package:wq_fotune/model/user_info.dart';
import 'package:wq_fotune/page/mine/view/exchange_modal.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/UIData.dart';
import 'package:wq_fotune/utils/toast-utils.dart';
import 'package:wq_fotune/utils/StringSharedPreferences.dart';

import '../../../global.dart';
import 'add_api.dart';

class MarketAccount extends StatefulWidget {
  final Function callBackSelectAccount;
  final UserInfo userInfo;
  final List apiList;
  final Map<String, dynamic> selectAccount;

  MarketAccount(
      {this.callBackSelectAccount,
      this.userInfo,
      this.apiList,
      this.selectAccount});

  @override
  _MarketAccountState createState() => _MarketAccountState();
}

class _MarketAccountState extends State<MarketAccount> {
  // List exchangeInfoList;
  ExchangeModel exchangeModel;

  @override
  void initState() {
    super.initState();
  }

  // 添加确认
  void onTapSure(Map params, Function callBack) {
    print(params);
    _exchangeOrderApiAdd(params, callBack);
  }

  // 添加交易所
  void _exchangeOrderApiAdd(params, callBack) {
    MineAPI.addExchangeOrderApi(params).then((res) {
      if (res.code != 0) {
        showToast(res.msg);
      } else {
        callBack();
        showToast("交易所添加成功");
        // this.loadUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(0, 8.0, 0, 8),
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: widget.userInfo == null ? _buildNotLogin() : _buildLogin(),
    );
  }

  Widget _buildNotLogin() {
    ShapeBorder shape = const RoundedRectangleBorder(
        side: BorderSide(color: UIData.blue_color),
        borderRadius: BorderRadius.all(Radius.circular(3)));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "登录即可使用量化交易",
          style: TextStyles.RegularBlackTextSize14,
        ),
        MaterialButton(
          minWidth: 80.0,
          height: 30.0,
          color: UIData.blue_color,
          textColor: UIData.white_color,
          shape: shape,
          child: new Text(
            '登录',
            style: TextStyles.RegularWhiteTextSize14,
          ),
          onPressed: () {
            gotoLoginPage(context);
          },
        )
      ],
    );
  }

  Widget _buildLogin() {
    if (widget.apiList != null && widget.apiList.length > 0) {
      return this._buildLoginAndHasAPI();
    }
    return this._buildLoginAndNotHasAPI();
  }

  Widget _buildLoginAndNotHasAPI() {
    ShapeBorder shape = const RoundedRectangleBorder(
        side: BorderSide(color: UIData.blue_color),
        borderRadius: BorderRadius.all(Radius.circular(3)));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "绑定API即可使用量化交易",
          style: TextStyles.RegularBlackTextSize14,
        ),
        MaterialButton(
          minWidth: 80.0,
          height: 30.0,
          color: UIData.blue_color,
          textColor: UIData.white_color,
          shape: shape,
          child: new Text(
            '绑定API',
            style: TextStyles.RegularWhiteTextSize14,
          ),
          onPressed: () {
            if (widget.userInfo == null) {
              gotoLoginPage(context).then((res) {
                if (res != null || res != "") {}
              });
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new AddApiPage(),
                ),
              );
            }
          },
        )
      ],
    );
  }

  Widget _buildLoginAndHasAPI() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTopLeft(),
            _buildTopRight(),
          ],
        ),
        _buildLine(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildBtmLeft(),
            Padding(
              padding: EdgeInsets.only(left: 10),
            ),
            _buildBtmRight(),
          ],
        ),
      ],
    );
  }

  Widget _buildTopLeft() {
    return Container(
      child: Row(
        children: [
          Text(
            "${widget.selectAccount["exchange_name"].toString().toUpperCase()}",
            style: TextStyle(
              color: UIData.one_color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTopRight() {
    return GestureDetector(
      onTap: () {
        _showSelectAccountModel();
      },
      child: Container(
        child: Row(
          children: [
            Text(
              "账户切换",
              style: TextStyles.RegularGrey2TextSize14,
            ),
            Padding(padding: EdgeInsets.only(left: 8)),
            Icon(
              Icons.arrow_forward_ios,
              color: UIData.two_color,
              size: 18,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLine() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
      height: 1,
      color: UIData.border_color,
    );
  }

  Widget _buildBtmLeft() {
    return Container(
      child: Text(
        "账户总资产(USD):",
        style: TextStyles.RegularBlackTextSize14,
      ),
    );
  }

  Widget _buildBtmRight() {
    return Container(
      child: Text(
        "${widget.selectAccount["total_usdt"]}",
        style: TextStyles.RegularBlackTextSize14,
      ),
    );
  }

  List<Widget> _selectedAccountView(ctx) {
    List<Widget> cs = [];
    widget.apiList.forEach((element) {
      cs.add(_selectedAccountItem(element, ctx));
    });
    return cs;
  }

  Widget _selectedAccountItem(element, ctx) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        save("exchange_name", element.toString());
        widget.callBackSelectAccount(element);
        Navigator.of(ctx).pop();
      },
      child: Container(
        height: 60,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: theme.dividerColor, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  Icon(
                    Icons.ac_unit,
                    color: UIData.primary_color,
                    size: 26,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      element["exchange_name"].toString().toUpperCase(),
                      style: TextStyle(
                        fontSize: 17,
                        color: UIData.default_color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _isShowSelectedIcon(element)
          ],
        ),
      ),
    );
  }

  _isShowSelectedIcon(element) {
    if (widget.selectAccount == null ||
        widget.selectAccount["exchange_name"] == element["exchange_name"]) {
      return Icon(
        Icons.check,
        color: UIData.primary_color,
      );
    }
    return Container();
  }

  _showSelectAccountModel() {
    double h = MediaQuery.of(context).size.height * 0.7;
    ShapeBorder shape = const RoundedRectangleBorder(
      side: BorderSide(color: Colors.white, style: BorderStyle.solid),
      borderRadius: BorderRadius.all(
        Radius.circular(36),
      ),
    );
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      shape: shape,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, state) {
          return Container(
            height: h,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(25, 25, 15, 15),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                "选择API",
                                style: TextStyle(
                                  color: UIData.default_color,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: UIData.red_color,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: Column(
                            children: _selectedAccountView(context),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
