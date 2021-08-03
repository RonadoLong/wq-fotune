import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wq_fotune/utils/device_utils.dart';
import 'package:flutter/cupertino.dart';

import 'ui_data.dart';
import 'check_update.dart';

class UpdateManager {
  ///APP更新方法
  static openURL(context, data) async {
    showIOSDialog(context, data, data["apkUrl"]);
  }
}

void showIOSDialog(context, Map jsonData, url) {
  var updateText = jsonData["updateLog"].split("，");
  var updateLog = '';
  updateText.forEach((t) {
    updateLog += '\r\n\r\n $t';
  });
  double w = MediaQuery.of(context).size.width - 40;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, state) {
          return AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            insetPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            backgroundColor: Colors.transparent,
            content: Container(
              color: Colors.transparent,
              width: w,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset("assets/images/bg_update_top.png"),
                  Container(
                    width: w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(10)),
                    ),
                    padding: EdgeInsets.fromLTRB(20, 12, 20, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "请升级到最新版本, 提升您的体验",
                          style: TextStyle(
                            color: UIData.default_color,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          updateLog,
                          style: TextStyle(
                              fontSize: 14, color: UIData.default_color),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        FlatButton(
                          child: Container(
                            width: w,
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "立即升级",
                              style: TextStyle(
                                color: UIData.default_color,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          color: Colors.amber[800],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                              side: BorderSide(color: UIData.border_color)),
                          onPressed: () {
                            launch(url);
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
