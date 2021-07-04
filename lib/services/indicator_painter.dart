import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import 'package:smart_trader/models/candle_data.dart';
import 'package:smart_trader/models/indicator_models.dart';
import 'package:smart_trader/models/paint_models.dart';
import 'package:smart_trader/services/indicators.dart';

class CandleStickPainter extends CustomPainter {
  final double globalHigh;
  final double globalLow;
  final double offset;
  final List<CandleData> candleData;
  CandleStickPainter({
    required this.globalHigh,
    required this.globalLow,
    required this.candleData,
    required this.offset,
  });

  List<CandleStickPaintData> _generatePaintDataList(
      List<CandleStick> indicator, Size size) {
    //finding width for each bar
    double eachWidth = min(20, size.width / (indicator.length + 2));

    //normalizing the height
    double heightUnit = size.height / (globalHigh - globalLow + 2 * offset);

    List<CandleStickPaintData> ret = [];
    for (int i = 0; i < indicator.length; i++) {
      ret.add(CandleStickPaintData(
        wickHighY: heightUnit * (indicator[i].high - globalLow + offset),
        wickLowY: heightUnit * (indicator[i].low - globalLow + offset),
        candleHighY: indicator[i].close >= indicator[i].open
            ? heightUnit * (indicator[i].close - globalLow + offset)
            : heightUnit * (indicator[i].open - globalLow + offset),
        candleLowY: indicator[i].close >= indicator[i].open
            ? heightUnit * (indicator[i].open - globalLow + offset)
            : heightUnit * (indicator[i].close - globalLow + offset),
        width: eachWidth,
        paint: indicator[i].close >= indicator[i].open
            ? (Paint()..color = Colors.green)
            : (Paint()..color = Colors.red),
        centerX: (i + 1) * eachWidth,
      ));
    }
    return ret;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double wickWidth = 1.0;

    final List<CandleStick>? indicator =
        CandleStickIndicator(candleData: this.candleData).values;
    if (indicator == null) return;
    //generate Paint Data
    List<CandleStickPaintData> paintData =
        this._generatePaintDataList(indicator, size);

    //paint Candles
    for (CandleStickPaintData currentCandle in paintData) {
      //paint wick
      canvas.drawRect(
        Rect.fromLTRB(
          currentCandle.centerX - (wickWidth / 2),
          size.height - currentCandle.wickHighY,
          currentCandle.centerX + (wickWidth / 2),
          size.height - currentCandle.wickLowY,
        ),
        currentCandle.paint,
      );

      //paint candles
      canvas.drawRect(
        Rect.fromLTRB(
          currentCandle.centerX -
              (currentCandle.width / 2 - currentCandle.width / 5),
          size.height - currentCandle.candleHighY,
          currentCandle.centerX +
              (currentCandle.width / 2 - currentCandle.width / 5),
          size.height - currentCandle.candleLowY,
        ),
        currentCandle.paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class TimePainter extends CustomPainter {
  final List<CandleData> candleData;

  double _fontSize = 8;

  TimePainter({required this.candleData});

  @override
  void paint(Canvas canvas, Size size) {
    double eachWidth = min(20, size.width / (candleData.length + 2));
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < candleData.length; i++) {
      if (i % 5 != 0) continue;
      textPainter.text = TextSpan(
          text:
              '${intl.DateFormat('hh:mm').format(DateTime.fromMicrosecondsSinceEpoch(candleData[i].time * 1000))}',
          style: TextStyle(color: Colors.white, fontSize: _fontSize));
      textPainter.layout(minWidth: 0, maxWidth: 20);
      textPainter.paint(canvas, Offset((i + 1) * eachWidth - 8, size.height));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PricePainter extends CustomPainter {
  final double high;
  final double low;
  PricePainter({required this.high, required this.low});
  @override
  void paint(Canvas canvas, Size size) {
    double _fontSize = 8;
    double pixelUnit = (high - low) / size.height;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    int curr = 20;
    while (curr < size.height) {
      textPainter.text = TextSpan(
          text: (low + curr * pixelUnit).toStringAsFixed(2),
          style: TextStyle(color: Colors.white, fontSize: _fontSize));
      textPainter.layout(minWidth: 0, maxWidth: double.infinity);
      textPainter.paint(canvas, Offset(size.width - 10, size.height - curr));
      curr += 40;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MovingAverageExponentialPainter extends CustomPainter {
  final double globalHigh;
  final double globalLow;
  final double offset;
  final List<CandleData> candleData;
  final int endIndex;
  final int startIndex;
  final int duration;

  MovingAverageExponentialPainter({
    required this.globalHigh,
    required this.globalLow,
    required this.candleData,
    required this.offset,
    required this.endIndex,
    required this.startIndex,
    required this.duration,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final List<double> totalIndicator = MovingAverageExponentialIndicator(
            candleData: candleData, duration: duration)
        .values;

    //print(totalIndicator.length);
    List<double> indicator = [];
    for (int i = endIndex; i >= startIndex; i--) {
      indicator.add(totalIndicator[i]);
    }

    //finding width for each bar
    double eachWidth = min(20, size.width / (indicator.length + 2));

    //normalizing the height
    double heightUnit = size.height / (globalHigh - globalLow + 2 * offset);

    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;
    for (int i = 1; i < indicator.length; i++) {
      canvas.drawLine(
          Offset(
              i * eachWidth,
              size.height -
                  (heightUnit * (indicator[i - 1] - globalLow + offset))),
          Offset((i + 1) * eachWidth,
              size.height - (heightUnit * (indicator[i] - globalLow + offset))),
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
