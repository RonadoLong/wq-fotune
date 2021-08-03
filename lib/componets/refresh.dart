import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:wq_fotune/utils/ui_data.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';

class CommonRefresh extends StatefulWidget {
  final Function onRefresh, loadMore;
  final controller;
  final SliverList sliverList;
  CommonRefresh(
      {this.controller, this.sliverList, this.onRefresh, this.loadMore});

  @override
  _CommonRefreshState createState() => _CommonRefreshState();
}

class _CommonRefreshState extends State<CommonRefresh> {
  @override
  Widget build(BuildContext context) {
    return widget.loadMore != null
        ? EasyRefresh.custom(
            enableControlFinishRefresh: false,
            enableControlFinishLoad: true,
            controller: widget.controller,
            header: BallPulseHeader(
              color: UIData.default_color.withOpacity(0.5),
            ),
            footer: BezierBounceFooter(
              backgroundColor: Colors.white60,
              color: UIData.default_color.withOpacity(0.5),
            ),
            onRefresh: () async {
              await Future.delayed(Duration(milliseconds: 300), () {
                widget.onRefresh();
              });
            },
            onLoad: () async {
              if (widget.loadMore != null) {
                await Future.delayed(Duration(milliseconds: 300), () {
                  widget.loadMore();
                });
              }
            },
            slivers: <Widget>[widget.sliverList],
          )
        : EasyRefresh.custom(
            enableControlFinishRefresh: false,
            enableControlFinishLoad: true,
            controller: widget.controller,
            header: BallPulseHeader(
              backgroundColor: Colors.white60,
              color: UIData.default_color.withOpacity(0.5),
            ),
            onRefresh: () async {
              await Future.delayed(Duration(milliseconds: 300), () {
                widget.onRefresh();
              });
            },
            slivers: <Widget>[
              widget.sliverList,
            ],
          );
  }
}
