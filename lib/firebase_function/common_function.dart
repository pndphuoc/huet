

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

Widget buildDateFormat(DateTime createDate, Color color, double fontSize) {
  return Text(
    // 86400
    daysBetween(createDate, DateTime.now()) < 60
        ?
    //Nếu dưới 60 giây
    "${daysBetween(createDate, DateTime.now())} seconds ago"
        :
    // Trên 60 giây, đổi sang phút
    (daysBetween(createDate, DateTime.now()) / 60).round() < 60
        ?
    //Dưới 60 phút
    "${(daysBetween(createDate, DateTime.now()) / 60).round()} minutes ago"
        :
    //Trên 60 phút, đổi sang giờ
    (daysBetween(createDate, DateTime.now()) / (60 * 60)).round() < 24
        ?
    //Dưới 24 giờ
    "${(daysBetween(createDate, DateTime.now()) / (60 * 60)).round()} hours ago"
        :
    //Trên 24 giờ, đổi sang ngày
    (daysBetween(createDate, DateTime.now()) / (24 * 60 * 60))
        .round() <
        7
        ?
    //Dưới 7 ngày
    "${(daysBetween(createDate, DateTime.now()) / (24 * 60 * 60)).round()} days ago"
        :
    //Trên 7 ngày
    DateFormat('dd-MM-yy').format(createDate),
    style: GoogleFonts.readexPro(fontSize: fontSize, color: color),
  );
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(
      from.year, from.month, from.day, from.hour, from.minute, from.second);
  to = DateTime(to.year, to.month, to.day, to.hour, to.minute, to.second);
  return (to.difference(from).inSeconds);
}