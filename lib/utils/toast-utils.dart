import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

showLoading() {
  EasyLoading.show(
      indicator: Container(
    width: 70,
    height: 70,
    child: Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
      ),
    ),
  ));
}

dismissLoad({animation = true}) {
  EasyLoading.dismiss(animation: animation);
}

showToast(msg) {
  EasyLoading.showInfo(msg, duration: Duration(seconds: 1));
}
