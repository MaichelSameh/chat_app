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

  Linkable({
    @required this.message,
    this.linkStyle = const TextStyle(
        color: Colors.blue, decoration: TextDecoration.underline),
    this.textStyle = const TextStyle(),
    this.onLinkTap,
    this.textAlign = TextAlign.start,
    this.textDirection = TextDirection.ltr,
  });

  bool contains(String text, String compareTo) {
    for (int i = 0; i < (text.length - compareTo.length); i++) {
      if (text.substring(i, i + compareTo.length) == compareTo) return true;
    }
    return false;
  }

  Widget _getText(String message) {
    return !(contains(message, "http://") || contains(message, "https://"))
        ? Text(
            message,
            style: textStyle,
            textAlign: textAlign,
            textDirection: textDirection,
          )
        : _getWidgets(message);
  }

  Widget _getWidgets(String text) {
    List<Widget> widgets = [];
    List<Map<String, Object>> textsList = _separeteString(text);
    print(textsList);
    widgets = textsList.map((text) {
      return text["isLink"]
          ? InkWell(
              child: Text(
                text["text"],
                style: linkStyle,
                textAlign: textAlign,
                textDirection: textDirection,
              ),
              onTap: () => _openLink(text["text"]),
              onLongPress: () {
                Clipboard.setData(new ClipboardData(text: "your text"));
              },
            )
          : Text(
              text["text"],
              style: textStyle,
              textAlign: textAlign,
              textDirection: textDirection,
            );
    }).toList();
    return Row(
      children: widgets,
    );
  }

  List<Map<String, Object>> _separeteString(String text) {
    String splitIn = "http://";
    String splitIn2 = "https://";
    List<Map<String, Object>> list = [];
    int counter = 0;
    for (int i = 0;
        i < (text.length - splitIn.length) &&
            i < (text.length - splitIn2.length) &&
            text.isNotEmpty;) {
      if (text.substring(i, i + splitIn.length) == splitIn ||
          text.substring(i, i + splitIn2.length) == splitIn2) {
        //adding the text before the link
        list.add({
          "text": text.substring(counter, i),
          "isLink": false,
        });

        //deleting the selected part before the link
        text = _cutWhere(
            text,
            text.substring(i, i + splitIn2.length) == splitIn2
                ? splitIn2
                : splitIn);
        String temp;
        if (text.split(" ") == null)
          //getting the entier text because it is just the link
          temp = text;
        else {
          //getting the rest of the text if is not a link
          temp = text.split(" ")[0];
          text = _reconnectingString(text.split(" "), " ").trim();
        }
        list.add({
          //adding the link
          "text": temp,
          "isLink": true,
        });
      }
    }
    return list;
  }

  String _reconnectingString(List<String> texts, String mark) {
    String result = "";
    texts.forEach((element) {
      result += element + mark;
    });
    return result;
  }

  String _cutWhere(String text, String where) {
    String result = "";
    for (int i = 0; i < (text.length - where.length); i++) {
      if (text.substring(i, i + where.length) == where) {
        result += text.substring(0, i);
        result += text.substring(i);
      }
    }
    return result;
  }

  void _openLink(String link) {
    launch(link);
  }

  @override
  Widget build(BuildContext context) {
    return _getText(message);
  }
}
