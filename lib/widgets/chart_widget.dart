import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_trader/models/candle_data.dart';
import 'package:smart_trader/services/indicator_painter.dart';
import 'package:smart_trader/services/indicator_service.dart';
import 'package:smart_trader/services/ticker_service.dart';
import 'package:smart_trader/widgets/chart.dart';

class ChartWidget extends StatefulWidget {
  final Orientation orientation;
  const ChartWidget({
    required this.orientation,
    Key? key,
  }) : super(key: key);

  @override
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  int viewCandleCount = 0;
  int startIndex = 0;
  int endIndex = 0;
  List<CandleData> currentCandles = [];
  late IndicatorService _indicatorService;

  @override
  void initState() {
    super.initState();
    viewCandleCount = widget.orientation == Orientation.landscape ? 60 : 30;
    endIndex = viewCandleCount;
    startIndex = endIndex - viewCandleCount;
    _indicatorService = IndicatorService(offset: 20.0);
  }

  @override
  Widget build(BuildContext context) {
    final ticker = Provider.of<TickerService>(context);
    currentCandles = [];
    if (ticker.candles.isEmpty) return Container();

    if (widget.orientation == Orientation.landscape) {
      viewCandleCount = 60;
      endIndex = startIndex + viewCandleCount;
    } else {
      viewCandleCount = 30;
      endIndex = startIndex + viewCandleCount;
    }

    double globalHigh = -double.infinity;
    double globalLow = double.infinity;
    for (int i = endIndex; i >= startIndex; i--) {
      currentCandles.add(ticker.candles[i]);
      globalHigh = max(globalHigh, ticker.candles[i].high);
      globalLow = min(globalLow, ticker.candles[i].low);
    }

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        int value = details.delta.dx.toInt();
        int d = value > 1 ? 1 : -1;
        value = value.abs();
        while (value > 0) {
          if (value % 3 == 0)
            setState(() {
              endIndex += d;
              endIndex = max(viewCandleCount, endIndex);
              endIndex = min(499, endIndex);
              startIndex = endIndex - viewCandleCount;
            });
          value--;
        }
      },
      child: Chart(
          indicatorService: _indicatorService,
          orientation: widget.orientation,
          candlePainter: CustomPaint(
            painter: CandleStickPainter(
              candleData: currentCandles,
              globalHigh: globalHigh,
              globalLow: globalLow,
              offset: 20.0,
            ),
          ),
          timePainter: CustomPaint(
            painter: TimePainter(candleData: currentCandles),
          ),
          pricePainter: CustomPaint(
            painter: PricePainter(high: globalHigh, low: globalLow),
          ),
          indicators: _indicatorService.getIndicatorPainters(
              candleData: ticker.candles,
              endIndex: endIndex,
              startIndex: startIndex,
              high: globalHigh,
              low: globalLow)
          // [
          //   MovingAverageExponentialPainter(
          //     candleData: ticker.candles,
          //     globalHigh: globalHigh,
          //     globalLow: globalLow,
          //     offset: 20.0,
          //     duration: 10,
          //     startIndex: startIndex,
          //     endIndex: endIndex,
          //   ),
          // ],
          ),
    );
  }
}
