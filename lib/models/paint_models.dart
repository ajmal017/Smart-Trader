import 'package:flutter/material.dart';

class CandleStickPaintData {
  final double wickHighY;
  final double wickLowY;
  final double candleHighY;
  final double candleLowY;
  final double width;
  final double centerX;
  final Paint paint;

  CandleStickPaintData({
    required this.wickHighY,
    required this.wickLowY,
    required this.candleHighY,
    required this.candleLowY,
    required this.width,
    required this.paint,
    required this.centerX,
  });
}
