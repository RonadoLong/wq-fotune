import 'package:flutter/material.dart';
import 'package:wq_fotune/page/mine/view/flat_modal_view.dart';

void showSheet(context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Stack(
        children: <Widget>[
          Container(
            height: 25,
            width: double.infinity,
            color: Colors.black54,
          ),
          Container(
            height: 200,
            width: double.infinity,
            child: Center(child: Text("showModalBottomSheet")),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
          ),
        ],
      );
    },
  );
}

