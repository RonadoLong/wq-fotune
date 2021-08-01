import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropDownSelect extends StatelessWidget {
  final String label;
  String value;
  final List<DropdownMenuItem> items;
  final ValueChanged onChanged;
  bool isText;

  DropDownSelect({Key key, this.label, this.value, this.items, this.onChanged, this.isText = false});

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 48.0,
      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        border: new Border.all(color: Color.fromRGBO(245,245,245,1), width: 1),
        color:Color.fromRGBO(245, 245, 245, 1)
      ),
      child: Row(
        children: <Widget>[
          new Expanded(
            flex: 3,
            child: new Container(
              child: new Text(
                this.label,
                style: TextStyle(fontSize: 16.0, color: Colors.black87),
              ),
            ),
          ),
          new Expanded(
            flex: 8,
            child: Container(
              padding: EdgeInsets.only(top: 4.0),
              child: this.isText ? Text(this.value) : DropdownButton(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black26,
                ),
                style: TextStyle(fontSize: 15.0, color: Colors.black54),
                iconSize: 22.0,
                isExpanded: true,
                underline: new Container(),
                hint: Text('请选择',
                  style: TextStyle(
                      color: Colors.black26
                  ),
                ),
                items: this.items,
                onChanged: onChanged,
                value: this.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}