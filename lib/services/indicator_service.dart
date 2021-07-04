import 'package:smart_trader/models/candle_data.dart';
import 'package:smart_trader/services/indicators.dart';

class IndicatorService {
  List<Indicator> _indicators = [];
  List<CandleData> candleData;

  IndicatorService({required this.candleData});

  void addIndicator(String indicator) {
    if (indicator == "CandleStick") {
      _indicators.add(CandleStickIndicatorTemp(candleData: candleData));
    }
    print(_indicators.length);
  }
}
