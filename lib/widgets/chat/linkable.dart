import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class Linkable extends StatelessWidget {
  final String message;
  final TextStyle linkStyle;
  final TextStyle textStyle;
  final Function(String link) onLinkTap;
  final TextAlign textAlign;
  final TextDirection textDirection;

  final String http = "http://";
  final String https = "https://";

  Linkable({
    @required this.message,
    this.linkStyle = const TextStyle(
        color: Colors.blue, decoration: TextDecoration.underline),
    this.textStyle = const TextStyle(),
    this.onLinkTap,
    this.textAlign = TextAlign.start,
    this.textDirection = TextDirection.ltr,
  });

  Widget _getText(String message) {
    return !(message.contains(http) || message.contains(https))
        ? Text(
            message,
            style: textStyle,
            textAlign: textAlign,
            textDirection: textDirection,
          )
        : _getWidgets(message);
  }

  Widget _getWidgets(String text) {
    List<TextSpan> widgets = [];
    List<Map<String, Object>> textsList = _separateString(text);
    widgets = textsList.map((text) {
      return text["isLink"]
          ? TextSpan(
              text: text["text"],
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _openLink(text["text"]);
                },
            )
          : TextSpan(
              text: text["text"],
              style: textStyle,
            );
    }).toList();
    return RichText(text: TextSpan(children: widgets));
  }

  bool contains(String text, String compareTo) {
    for (int i = 0; i < (text.length - compareTo.length); i++) {
      if (text.substring(i, i + compareTo.length) == compareTo) return true;
    }
    return false;
  }

  List<Map<String, Object>> _separateString(String text) {
    List<Map<String, Object>> result = [];
    List<String> temp = text.split(" ");
    String collect = "";
    for (int i = 0; i < temp.length; i++) {
      String element = temp[i];
      if (element.startsWith(https) || element.startsWith(http)) {
        if (collect.isNotEmpty) {
          result.add({"text": collect, "isLink": false});
          collect = "";
        }
        result.add({"text": element + " ", "isLink": true});
      } else {
        collect += element + " ";
        if (i + 1 == temp.length) {
          result.add({"text": element, "isLink": false});
        }
      }
    }
    return result;
  }

  void _openLink(String link) {
    launch(link);
  }

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
        maxWidth: MediaQuery.of(context).size.width * 2 / 3,
        child: _getText(message));
  }
}
