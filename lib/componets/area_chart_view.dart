// import 'package:fl_animated_linechart/chart/animated_line_chart.dart';
// import 'package:fl_animated_linechart/chart/area_line_chart.dart';
// import 'package:fl_animated_linechart/chart/line_chart.dart';
// import 'package:fl_animated_linechart/common/pair.dart';
// import 'package:flutter/material.dart';
// import 'package:wq_fotune/utils/UIData.dart';
//
// /// 曲线图
// class AreaChartView extends StatelessWidget {
//   Map<DateTime, double> data;
//
//   AreaChartView(this.data);
//
//   @override
//   Widget build(BuildContext context) {
//     LineChart chart = AreaLineChart.fromDateTimeMaps(
//       [data],
//       [Colors.red.shade900],
//       ['USDT'],
//       ///单位
//       gradients: [Pair(Colors.yellow.shade400, Colors.red.shade700)],
//     );
//     return Container(
//       height: 260,
//       child: data.keys.length > 0 ? AnimatedLineChart(
//         chart,
//         key: UniqueKey(),
//       ) :  Center(
//         child: Text("还没有成交数据", style: TextStyle(color: UIData.primary_color),),
//       ),
//     );
//   }
// }
//
// /// 使用案例
// class demo extends StatefulWidget {
//   @override
//   _demoState createState() => _demoState();
// }
//
// class _demoState extends State<demo> {
//   Map<DateTime, double> createLine() {
//     Map<DateTime, double> data = {};
//     data[DateTime.now().subtract(Duration(hours: 120))] = 83.0;
//     data[DateTime.now().subtract(Duration(hours: 110))] = 64.0;
//     data[DateTime.now().subtract(Duration(hours: 100))] = 83.0;
//     data[DateTime.now().subtract(Duration(hours: 90))] = 64.0;
//     data[DateTime.now().subtract(Duration(hours: 80))] = 83.0;
//     data[DateTime.now().subtract(Duration(hours: 70))] = 64.0;
//     data[DateTime.now().subtract(Duration(hours: 60))] = 13.0;
//     data[DateTime.now().subtract(Duration(hours: 50))] = 24.0;
//     data[DateTime.now().subtract(Duration(hours: 40))] = 13.0;
//     data[DateTime.now().subtract(Duration(hours: 30))] = 24.0;
//     data[DateTime.now().subtract(Duration(hours: 22))] = 39.0;
//     data[DateTime.now().subtract(Duration(hours: 20))] = 29.0;
//     data[DateTime.now().subtract(Duration(hours: 15))] = 27.0;
//     data[DateTime.now().subtract(Duration(hours: 12))] = 9.0;
//     data[DateTime.now().subtract(Duration(hours: 8))] = 35.0;
//     return data;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Map<DateTime, double> data = createLine();
//     return AreaChartView(data);
//   }
// }
