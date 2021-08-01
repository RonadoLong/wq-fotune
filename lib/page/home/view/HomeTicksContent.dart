import 'package:flutter/material.dart';
import 'package:wq_fotune/res/styles.dart';

class HomeTicksContent extends StatefulWidget {
  const HomeTicksContent({
    Key key,
    @required this.context,
    @required this.tiles,
  }) : super(key: key);

  final BuildContext context;
  final List<Widget> tiles;

  @override
  _HomeTicksContentState createState() => _HomeTicksContentState();
}

class _HomeTicksContentState extends State<HomeTicksContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('名称',style: TextStyles.RegularGrey2TextSize12,),
              Container(
                width: 88.0,
                child: Text('预计年化收益',style: TextStyles.RegularGrey2TextSize12,textAlign: TextAlign.center,),
              ),
            ],
          ),
          Column(
            children: widget.tiles,
          )
        ],
      ),
    );
  }
}
