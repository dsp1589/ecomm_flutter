import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UIHelper {
  static Widget Spacer({double vertical, double horizontal}) {
    return Container(
      height: vertical ?? 0,
      width: horizontal ?? 0,
    );
  }
}

class EcommFormatter {
  static String formattedDate(String date) {
    final _actualFormat = new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
    final DateTime parsedDate = _actualFormat.parse(date);
    final _understandableFormat = new DateFormat("yyyy MMM dd");
    final displayableDate = _understandableFormat.format(parsedDate);
    return displayableDate;
  }

  static DateTime dateAndTime(String date) {
    final _actualFormat = new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
    final DateTime parsedDate = _actualFormat.parse(date);
    return parsedDate;
  }
}
