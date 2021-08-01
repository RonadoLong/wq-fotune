import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/UIData.dart';

///上拉加载更多
Widget BuildLoadMoreView() {
  Widget bottomWidget =
      new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
    new SpinKitThreeBounce(color: Color(0xFF24292E)),
    new Container(
      width: 5.0,
    ),
  ]);
  return new Padding(
    padding: const EdgeInsets.all(5.0),
    child: new Center(
      child: bottomWidget,
    ),
  );
}

Widget buildEmptyView({String title, double heightFactor}) {
  var val = title != null ? title : "没有更多数据";
  return Center(
    heightFactor: heightFactor != null ? heightFactor : 2,
    child: Container(
      height: 160,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.cloud_off,
            size: 50,
            color: UIData.blue_color,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Text(
            val,
            style: TextStyle(fontSize: 16, color: UIData.normal_font_color),
          )
        ],
      ),
    ),
  );
//  return Container(
////
//  );
}

Widget buildEmptyAndBtnView({
  String title,
  String contentLeft,
  String contentRight,
  double heightFactor,
  Function onTap,
}) {
  return Center(
    heightFactor: heightFactor != null ? heightFactor : 3,
    child: Container(
      height: 260,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/empty@2x.png',
            width: 284.0,
            height: 165.0,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Text(
            title,
            style: TextStyles.RegularBlackTextSize14,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  contentLeft,
                  style: TextStyles.RegularBlackTextSize14,
                ),
                GestureDetector(
                  onTap: (){
                    onTap();
                  },
                  child: Text(
                    contentRight,
                    style: TextStyles.RegularBlueTextSize14,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
//  return Container(
////
//  );
}

Future<void> handleRefresh(Function todo) {
  final Completer<void> completer = Completer<void>();
  Future.delayed(Duration(seconds: 1), () {
    completer.complete();
  });
  return completer.future.then<void>((_) {
    if (todo != null) {
      todo();
    }
  });
}

Future<void> handleRefreshWithDuration(Function todo, Duration duration) {
  final Completer<void> completer = Completer<void>();
  Future.delayed(duration, () {
    completer.complete();
  });
  return completer.future.then<void>((_) {
    if (todo != null) {
      todo();
    }
  });
}

Future<void> delayedfresh(Function todo) {
  final Completer<void> completer = Completer<void>();
  Future.delayed(Duration(seconds: 6), () {
    completer.complete();
  });
  return completer.future.then<void>((_) {
    todo();
  });
}
