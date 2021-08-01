import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle style;
  final TextOverflow overflow;
  ExpandableText({
    Key key,
    @required this.text,
    this.maxLines,
    this.style,
    this.overflow = TextOverflow.fade
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  int get maxLines => widget.maxLines;
  String get text => widget.text;
  TextStyle get style => widget.style;
  TextOverflow get overflow => widget.overflow;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      final span = TextSpan(text: text, style: style);
      final tp = TextPainter(
          text: span,
          maxLines: maxLines,
          textDirection: TextDirection.ltr
      );
      tp.layout(maxWidth: size.maxWidth);

      if (tp.didExceedMaxLines) { // 判断文字是否溢出
        return ExpandableNotifier(
          child: Column(
              children: [
                Expandable(
                  collapsed: Column(
                      children: [
                        Text(text, maxLines: maxLines, overflow: overflow, style: style),
                        ExpandableButton(
                          child: Text('打开', style: TextStyle(color: Colors.blue)),
                        )
                      ]
                  ),
                  expanded: Column(
                      children: [
                        Text(text, style: style),
                        ExpandableButton(
                          child: Text('收起', style: TextStyle(color: Colors.blue)),
                        ),
                      ]
                  ),
                )
              ]
          ),
        );
      } else {
        return Text(text, style: style);
      }
    });
  }
}