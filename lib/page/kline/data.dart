import 'dart:math';

import 'package:k_chart/entity/index.dart';
import 'package:k_chart/k_chart_widget.dart';
import 'package:k_chart/utils/data_util.dart';

Map<String, String> symbols = {
  "分时": "1",
  "1分": "1m",
  "5分": "5m",
  "30分": "30m",
  "1时": "1h",
  "4时": "4h",
  "8时": "8h",
  "日K": "1d",
  "周K": "1w",
  "月K": "1M"
};

Map<String, MainState> mainState = {
  "MA": MainState.MA,
  "BOLL": MainState.BOLL,
  "NONE": MainState.NONE,
};

Map<String, dynamic> seState = {
  "VOLUME": 1,
  "MACD": SecondaryState.MACD,
  "KDJ": SecondaryState.KDJ,
  "RSI": SecondaryState.RSI,
  "WR": SecondaryState.WR,
  "CCI": SecondaryState.CCI,
  "NONE": SecondaryState.NONE,
};
