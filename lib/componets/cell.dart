import 'package:flutter/material.dart';
import 'package:wq_fotune/res/styles.dart';
import 'package:wq_fotune/utils/UIData.dart';

class SyCell extends StatelessWidget {
  final Widget icon;
  final String title;
  final String endText;
  final VoidCallback onTap;
  final bool isShowLine;

  SyCell({
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
        height: 50,
        padding:
            EdgeInsets.only(left: 15.0, top: 10.0, right: 10.0, bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: isShowLine ? theme.dividerColor : Colors.white, width: 0.5))),
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
                style: TextStyles.RegularBlackTextSize16,
              ),
            ),
            Text(endText),
            onTap == null
                ? Container()
                : Icon(
                    Icons.navigate_next,
                    color: UIData.three_color,
                  )
          ],
        ),
      ),
    );
  }
}
