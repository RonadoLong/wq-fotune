import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wq_fotune/utils/UIData.dart';

/// 墨水瓶（`InkWell`）可用时使用的字体样式。
final TextStyle _availableStyle = TextStyle(
  fontSize: 13.0,
  color: Colors.white,
);

/// 墨水瓶（`InkWell`）不可用时使用的样式。
final TextStyle _unavailableStyle = TextStyle(
  fontSize: 13.0,
  color: Colors.white,
);

class LoginFormCode extends StatefulWidget {
  /// 倒计时的秒数，默认60秒。
  final int countdown;

  /// 用户点击时的回调函数。
  final Function onTapCallback;

  /// 是否可以获取验证码，默认为`false`。
  final bool available;

  LoginFormCode({
    this.countdown: 60,
    this.onTapCallback,
    this.available: false,
  });

  @override
  _LoginFormCodeState createState() => _LoginFormCodeState();
}

class _LoginFormCodeState extends State<LoginFormCode> {
  /// 倒计时的计时器。
  Timer _timer;

  /// 当前倒计时的秒数。
  int _seconds = 60;

  bool _isRun = false;

  /// 当前墨水瓶（`InkWell`）的字体样式。
  TextStyle inkWellStyle = _availableStyle;

  /// 当前墨水瓶（`InkWell`）的文本。
  String _verifyStr = '获取验证码';

  @override
  void initState() {
    super.initState();
    _seconds = widget.countdown;
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  /// 启动倒计时的计时器。
  void _startTimer() {
    // 计时器（`Timer`）组件的定期（`periodic`）构造函数，创建一个新的重复计时器。
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _restState();
        return;
      }
      _seconds--;
      setState(() {
        _verifyStr = '已发送$_seconds' + 's';
      });
    });
  }

  void _restState() {
    _cancelTimer();
    setState(() {
      _seconds = widget.countdown;
      inkWellStyle = _availableStyle;
      _isRun = false;
      _verifyStr = '重新发送';
    });
  }

  void _runState() {
    _startTimer();
    setState(() {
      inkWellStyle = _unavailableStyle;
      _verifyStr = '已发送$_seconds' + 's';
      _isRun = true;
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          width: 80,
          height: 48,
          alignment: Alignment.center,
          decoration: new BoxDecoration(
            color: UIData.primary_color,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(4.0),
              bottomRight: Radius.circular(4.0),
            )
          ),
          child: Text(
            '$_verifyStr',
            style: inkWellStyle,
            textAlign: TextAlign.center,
          ),
        ),
        onTap: () {
          if (_isRun) {
            return;
          }
          if (widget.available) {
            _runState();
          }
          widget.onTapCallback();
        });
  }
}
