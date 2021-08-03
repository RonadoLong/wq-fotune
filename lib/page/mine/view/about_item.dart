import 'package:flutter/material.dart';
import 'package:wq_fotune/utils/ui_data.dart';

class About extends StatelessWidget {
  final Widget icon;
  final String title;
  final String endText;
  final VoidCallback onTap;
  final bool isShowLine;

  About({
    @required this.title,
    this.icon,
    this.onTap,
    this.endText: '',
    this.isShowLine: true,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return new InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        padding: EdgeInsets.all(10.0),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            icon != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: icon,
                  )
                : Container(),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                    color: UIData.default_color),
              ),
            ),
            Text(endText),
            onTap == null
                ? Container()
                : Icon(
                    Icons.navigate_next,
                    color: theme.disabledColor,
                  )
          ],
        ),
      ),
    );
  }
}
