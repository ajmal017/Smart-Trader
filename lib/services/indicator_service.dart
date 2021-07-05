import 'dart:math';

import 'package:smart_trader/models/candle_data.dart';
import 'package:smart_trader/models/indicator_enum.dart';
import 'package:smart_trader/services/indicator_painter.dart';
import 'package:smart_trader/services/indicators.dart';

class IndicatorService {
  final double offset;
  Map<int, Indicator> _indicators = {};
  int count;

  Map<int, Indicator> get indicators => _indicators;

  IndicatorService({required this.offset}) : this.count = 0 {
    count++;
    _indicators[count] = MovingAverageExponentialIndicator(duration: 30);
  }

  void addIndicator(IndicatorType indicator, List<dynamic> args) {
    if (indicator == IndicatorType.MovingAverageExponential) {
      count++;
      _indicators[count] =
          MovingAverageExponentialIndicator(duration: args[0] as int);
    }
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

  List<IndicatorPainter> getIndicatorPainters({
    required List<CandleData> candleData,
    required int endIndex,
    required int startIndex,
    required double high,
    required double low,
  }) {
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

    List<IndicatorPainter> ret = [];

    indicatorValues.forEach((key, value) {
      IndicatorPainter? currentIndicatorPainter = this._getSpecificPainter(
          _indicators[key]!.type, value, startIndex, endIndex, high, low);
      if (currentIndicatorPainter != null) {
        ret.add(currentIndicatorPainter);
      }
    });

    return ret;
  }
}
