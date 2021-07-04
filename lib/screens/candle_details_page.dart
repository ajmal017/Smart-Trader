import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_trader/models/market.dart';
import 'package:smart_trader/services/indicator_service.dart';
import 'package:smart_trader/widgets/chart_widget.dart';

class CandleDetailsPage extends StatelessWidget {
  final Orientation orientation;
  final String marketPair;
  final String baseCurrencyCode;
  final String targetCurrencyCode;
  const CandleDetailsPage({
    Key? key,
    required this.orientation,
    required this.marketPair,
    required this.baseCurrencyCode,
    required this.targetCurrencyCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (orientation == Orientation.landscape) {
      SystemChrome.setEnabledSystemUIOverlays([]);
    } else {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff0d324d), Colors.blueGrey],
          begin: Alignment.topLeft,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: orientation == Orientation.portrait
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          targetCurrencyCode,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '/ ' + baseCurrencyCode,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 400,
                      padding: const EdgeInsets.all(10),
                      child: ChartWidget(orientation: orientation),
                    ),
                    
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: ChartWidget(orientation: orientation),
              ),
      ),
    );
  }
}
