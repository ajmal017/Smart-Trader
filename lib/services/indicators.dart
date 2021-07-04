import 'package:smart_trader/models/candle_data.dart';
import 'package:smart_trader/models/indicator_models.dart';

abstract class Indicator {
  final List<CandleData> candleData;
  Indicator({required this.candleData});
  getvalues();
}

class CandleStickIndicatorTemp extends Indicator {
  CandleStickIndicatorTemp({required List<CandleData> candleData})
      : super(candleData: candleData);

  @override
  getvalues() {
    return this
        .candleData
        .map((e) => CandleStick(
            open: e.open,
            high: e.high,
            low: e.low,
            close: e.close,
            time: e.time))
        .toList();
  }
}

class CandleStickIndicator {
  final List<CandleData> candleData;
  List<CandleStick>? _values;

  CandleStickIndicator({required this.candleData}) {
    _values = this
        .candleData
        .map((e) => CandleStick(
            open: e.open,
            high: e.high,
            low: e.low,
            close: e.close,
            time: e.time))
        .toList();
  }

  List<CandleStick>? get values => _values;
}

class MovingAverageExponentialIndicator {
  final List<CandleData> candleData;
  final int duration;
  List<double> _values = [];

  MovingAverageExponentialIndicator(
      {required this.candleData, required this.duration}) {
    double curr = 0;
    for (int i = 0; i < candleData.length; i++) {
      if (curr == 0)
        curr = candleData[i].close;
      else
        curr = (curr * (duration - 1) + candleData[i].close) / duration;
      _values.add(curr);
    }
  }

  List<double> get values => _values;
}
