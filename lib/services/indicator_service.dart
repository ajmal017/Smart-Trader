import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:smart_trader/models/candle_data.dart';
import 'package:smart_trader/models/indicator_enum.dart';
import 'package:smart_trader/services/indicator_painter.dart';
import 'package:smart_trader/services/indicators.dart';

class IndicatorService with ChangeNotifier {
  final double offset;
  int _count;
  Map<int, Indicator> _indicators = {};
  List<IndicatorPainter> _indicatorPainters = [];

  CandleStickPainter? _candleStickPainter;
  TimePainter? _timePainter;
  PricePainter? _pricePainter;

  Map<int, Indicator> get indicators => _indicators;
  List<IndicatorPainter> get indicatorPainters => _indicatorPainters;
  CandleStickPainter? get candleStickPainter => _candleStickPainter;
  TimePainter? get timePainter => _timePainter;
  PricePainter? get pricePainter => _pricePainter;

  IndicatorService({required this.offset}) : this._count = 0 {
    _count++;
    _indicators[_count] = MovingAverageExponentialIndicator(duration: 30);
  }


  void addIndicator(IndicatorType indicator, List<dynamic> args) {
    if (indicator == IndicatorType.MovingAverageExponential) {
      _count++;
      _indicators[_count] =
          MovingAverageExponentialIndicator(duration: args[0] as int);
    }
    notifyListeners();
  }

  IndicatorPainter? _getSpecificPainter(
    IndicatorType indicatorType,
    List<double> values,
    int startIndex,
    int endIndex,
    double high,
    double low,
  ) {
    if (indicatorType == IndicatorType.MovingAverageExponential) {
      return MovingAverageExponentialPainter(
          globalHigh: high,
          globalLow: low,
          offset: this.offset,
          endIndex: endIndex,
          startIndex: startIndex,
          values: values);
    }
    return null;
  }

  void updateIndicatorPainters({
    required List<CandleData> candleData,
    required int endIndex,
    required int startIndex,
  }) {
    List<CandleData> currentCandles = [];

    double high = -double.infinity;
    double low = double.infinity;
    for (int i = endIndex; i >= startIndex; i--) {
      currentCandles.add(candleData[i]);
      high = max(high, candleData[i].high);
      low = min(low, candleData[i].low);
    }

    this._candleStickPainter = CandleStickPainter(
      candleData: currentCandles,
      globalHigh: high,
      globalLow: low,
      offset: this.offset,
    );

    Map<int, List<double>> indicatorValues = {};

    _indicators.forEach((key, value) {
      indicatorValues[key] = value.getValues(candleData);
    });

    indicatorValues.values.forEach((element) {
      for (int i = startIndex; i < endIndex; i++) {
        high = max(high, element[i]);
        low = min(low, element[i]);
      }
    });

    this._timePainter = TimePainter(candleData: currentCandles);
    this._pricePainter = PricePainter(high: high, low: low);

    List<IndicatorPainter> ret = [];

    indicatorValues.forEach((key, value) {
      IndicatorPainter? currentIndicatorPainter = this._getSpecificPainter(
          _indicators[key]!.type, value, startIndex, endIndex, high, low);
      if (currentIndicatorPainter != null) {
        ret.add(currentIndicatorPainter);
      }
    });

    this._indicatorPainters = ret;
  }
}
