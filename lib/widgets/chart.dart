import 'package:flutter/material.dart';
import 'package:smart_trader/services/indicator_painter.dart';

class Chart extends StatelessWidget {
  final Orientation orientation;
  final List<IndicatorPainter> indicators;
  final candlePainter;
  final timePainter;
  final pricePainter;
  const Chart({
    Key? key,
    required this.candlePainter,
    required this.timePainter,
    required this.pricePainter,
    required this.indicators,
    required this.orientation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height =
        orientation == Orientation.landscape ? double.infinity : 300.0;
    return Container(
      height: height,
      margin: const EdgeInsets.only(left: 10, right: 25, top: 10, bottom: 10),
      child: Stack(
        children: [
          Container(
            height: height,
            width: double.infinity,
            child: timePainter,
          ),
          Container(
            height: height,
            width: double.infinity,
            child: pricePainter,
          ),
          Container(
            height: height,
            width: double.infinity,
            child: candlePainter,
          ),
          if (orientation == Orientation.landscape)
            ...indicators
                .map((e) => Container(
                      height: height,
                      width: double.infinity,
                      child: RepaintBoundary(
                          child: CustomPaint(
                        painter: e,
                      )),
                    ))
                .toList()
        ],
      ),
    );
  }
}
