import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/api/Mine.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';
import 'package:wq_fotune/componets/circular_load.dart';
import 'package:wq_fotune/componets/refresh.dart';
import 'package:wq_fotune/page/mine/view/ifc_wallet_view.dart';
import 'package:wq_fotune/page/mine/view/usdt_wallet_view.dart';
import 'package:wq_fotune/utils/UIData.dart';
import 'package:wq_fotune/common/EventBus.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class WalletPage extends StatefulWidget {
  @override
  WalletPageState createState() => WalletPageState();
}

class WalletPageState extends State<WalletPage> {
  EasyRefreshController _controller = EasyRefreshController();
  Map usdtData;
  Map ifcData;
  var bus = EventBus();
  @override
  void initState() {
    super.initState();

    bus.on("login", (arg) {
      getData();
    });

    getData();
  }

  void getData() async {
    MineAPI.getWalletUsdt().then((res) {
      if (res.code == 0) {
        setState(() {
          usdtData = res.data;
        });
      }
    });
    MineAPI.getWalletIfc().then((res) {
      if (res.code == 0 && mounted) {
        setState(() {
          ifcData = res.data;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBar("钱包"),
      body: buildBody(),
    );
  }

  buildBody() {
    if (usdtData == null || ifcData == null) {
      return Center(child: CircularLoading());
    } else {
      return CommonRefresh(
        controller: _controller,
        sliverList: SliverList(
          delegate: SliverChildListDelegate(
            [
              IfcWalletView(data: ifcData),
              SizedBox(
                height: 20,
              ),
              UsdtWalletView(data: usdtData),
            ],
          ),
        ),
        onRefresh: () {
          getData();
        },
      );
    }
  }
}
