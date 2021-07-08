import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_trader/models/market.dart';
import 'package:smart_trader/screens/candle_details_page.dart';
import 'package:smart_trader/screens/market_details_page.dart';
import 'package:smart_trader/services/indicator_service.dart';
import 'package:smart_trader/services/market_service.dart';
import 'package:smart_trader/services/ticker_service.dart';
import 'package:smart_trader/widgets/chart_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MarketService.getDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        Market marketData = snapshot.data as Market;

        return HomePageWidget(marketData: marketData);
      },
    );
  }
}

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({
    Key? key,
    required this.marketData,
  }) : super(key: key);

  final Market marketData;

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with SingleTickerProviderStateMixin {
  String _selectedBaseCurrency = 'INR';
  String _selectedTargetCurrency = 'BTC';
  String _selectedPair = 'I-BTC_INR';
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    super.initState();
  }

  void _updateCurrency(
      {required String baseCurrency,
      required String targetCurrency,
      required String pair}) {
    setState(() {
      _selectedBaseCurrency = baseCurrency;
      _selectedTargetCurrency = targetCurrency;
      _selectedPair = pair;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => OrientationBuilder(
        builder: (context, orientation) => Scaffold(
          body: ChangeNotifierProvider(
            create: (context) => IndicatorService(offset: 20.0),
            builder: (context, child) => ChangeNotifierProvider(
              create: (context) =>
                  TickerService(marketPair: _selectedPair, timeDuration: '1m'),
              builder: (context, child) => Stack(
                children: [
                  MarketDetailsPage(
                    marketData: widget.marketData,
                    baseCurrency: _selectedBaseCurrency,
                    targetCurrency: _selectedTargetCurrency,
                    pair: _selectedPair,
                    updateFunction: _updateCurrency,
                  ),
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..setEntry(0, 3, 200.0 * _animation.value)
                      ..rotateY((pi / 6) * _animation.value),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(20.0 * _animation.value),
                      child: CandleDetailsPage(
                        orientation: orientation,
                        marketPair: _selectedPair,
                        baseCurrencyCode: _selectedBaseCurrency,
                        targetCurrencyCode: _selectedTargetCurrency,
                      ),
                    ),
                  ),
                  if (orientation == Orientation.portrait)
                    GestureDetector(
                      onHorizontalDragUpdate: (e) {
                        if (e.delta.dx < 0 && _animation.isCompleted) {
                          _animationController.reverse();
                        } else if (e.delta.dx > 0 && _animation.isDismissed) {
                          _animationController.forward();
                        }
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
