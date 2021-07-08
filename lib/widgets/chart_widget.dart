import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    viewCandleCount = widget.orientation == Orientation.landscape ? 60 : 30;
    endIndex = viewCandleCount;
    startIndex = endIndex - viewCandleCount;
  }

  @override
  Widget build(BuildContext context) {
    final ticker = Provider.of<TickerService>(context);
    final indicatorService = Provider.of<IndicatorService>(context);
    if (ticker.candles.isEmpty) return Container();
    Provider.of<IndicatorService>(context, listen: false)
        .updateIndicatorPainters(
            candleData: ticker.candles,
            endIndex: endIndex,
            startIndex: startIndex);

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
        candleData: ticker.candles,
        orientation: widget.orientation,
        startIndex: startIndex,
        endIndex: endIndex,
        indicatorService: indicatorService,
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
