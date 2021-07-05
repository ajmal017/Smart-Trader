import 'package:smart_trader/models/candle_data.dart';
import 'package:smart_trader/models/indicator_enum.dart';
import 'package:smart_trader/models/indicator_models.dart';

abstract class Indicator {
  final IndicatorType type;

  Indicator({required this.type});

  List<double> getValues(List<CandleData> candleData);
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

class MovingAverageExponentialIndicator extends Indicator {
  final int duration;

  MovingAverageExponentialIndicator({required this.duration})
      : super(type: IndicatorType.MovingAverageExponential);

  @override
  List<double> getValues(List<CandleData> candleData) {
    List<double> arr = [];
    double curr = 0;
    for (int i = 0; i < candleData.length; i++) {
      if (curr == 0)
        curr = candleData[i].close;
      else
        curr = (curr * (duration - 1) + candleData[i].close) / duration;
      arr.add(curr);
    }
    return arr;
  }
}
