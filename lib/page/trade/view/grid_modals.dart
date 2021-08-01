import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/common/CustomAppBar.dart';

class GridModal extends StatefulWidget {
  String id;

  GridModal({this.id});

  @override
  State<StatefulWidget> createState() => new GridModalState();
}

class GridModalState extends State<GridModal> {


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBar(""),
      body: buildBody(),
    );
  }

  Widget buildBody() {

  }


}

