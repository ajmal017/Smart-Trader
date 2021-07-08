import 'package:flutter/material.dart';
import 'package:smart_trader/models/candle_data.dart';
import 'package:smart_trader/services/indicator_service.dart';
import 'package:smart_trader/widgets/view_indicators.dart';

class Chart extends StatelessWidget {
  final Orientation orientation;
  final int startIndex;
  final int endIndex;
  final List<CandleData> candleData;
  final IndicatorService indicatorService;
  const Chart({
    Key? key,
    required this.startIndex,
    required this.endIndex,
    required this.orientation,
    required this.candleData,
    required this.indicatorService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height =
        orientation == Orientation.landscape ? double.infinity : 300.0;
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 25, top: 10, bottom: 10),
      child: Stack(
        children: [
          Container(
            height: height,
            width: double.infinity,
            child: CustomPaint(painter: indicatorService.timePainter),
          ),
          Container(
            height: height,
            width: double.infinity,
            child: CustomPaint(
              painter: indicatorService.pricePainter,
            ),
          ),
          Container(
            height: height,
            width: double.infinity,
            child: CustomPaint(
              painter: indicatorService.candleStickPainter,
            ),
          ),
          if (orientation == Orientation.landscape)
            ...indicatorService.indicatorPainters
                .map((e) => Container(
                      height: height,
                      width: double.infinity,
                      child: RepaintBoundary(
                          child: CustomPaint(
                        painter: e,
                      )),
                    ))
                .toList(),
          if (orientation == Orientation.landscape)
            Positioned(
              top: 20,
              left: 20,
              child: ViewIndicators(indicatorService: indicatorService),
            ),
        ],
      ),
    );
  }
}
