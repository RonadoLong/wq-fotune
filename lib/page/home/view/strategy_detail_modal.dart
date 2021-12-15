import 'package:flutter/material.dart';
import 'package:wq_fotune/componets/fInput_widget.dart';
import 'package:wq_fotune/componets/custom_btn.dart';
import 'package:wq_fotune/utils/ui_data.dart';

var _balanceController = new TextEditingController();

void showModal(context, Function onTapCreate) {
  double h = MediaQuery.of(context).size.height * 0.7;
  double w = MediaQuery.of(context).size.width;
  _balanceController.clear();
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
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 8,
                      width: 60,
                      decoration: BoxDecoration(
                        color: UIData.border_color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
                        "提示, 是否创建机器人？请保持充足的资金进行交易",
                        style: TextStyle(
                          color: UIData.red_color,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 20),
                      child: FInputWidget(
                        hintText: "设置投资金额/USDT",
                        onChanged: (String value) {
                          print(value);
                        },
                        controller: _balanceController,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 50)),
                    RoundBtn(
                      content: "确认创建",
                      isPositioned: false,
                      onPress: () {
                        var val = _balanceController.text.trim();
                        onTapCreate(val, () {
                          Navigator.of(context).pop();
                        });
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      });
    },
  );
}
