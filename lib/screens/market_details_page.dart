import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_trader/models/market.dart';
import 'package:smart_trader/services/ticker_service.dart';

class MarketDetailsPage extends StatefulWidget {
  final Market marketData;
  final String baseCurrency;
  final String targetCurrency;
  final String pair;
  final Function updateFunction;
  const MarketDetailsPage(
      {Key? key,
      required this.marketData,
      required this.baseCurrency,
      required this.targetCurrency,
      required this.pair,
      required this.updateFunction})
      : super(key: key);

  @override
  _MarketDetailsPageState createState() => _MarketDetailsPageState();
}

class _MarketDetailsPageState extends State<MarketDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Container(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: widget.marketData.marketData.keys
                      .map(
                        (e) => GestureDetector(
                          onTap: () {
                            String newPair = widget.marketData.marketData[e]!
                                .firstWhere((element) =>
                                    widget.targetCurrency ==
                                    element.targetCurrency.shortName)
                                .pair;
                            widget.updateFunction(
                              baseCurrency: e,
                              targetCurrency: widget.targetCurrency,
                              pair: newPair,
                            );
                            Provider.of<TickerService>(context, listen: false)
                                .updateValues(marketPair: newPair);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: e == widget.baseCurrency
                                    ? Colors.white.withOpacity(0.6)
                                    : null),
                            margin: const EdgeInsets.only(right: 10),
                            child: Text(
                              e,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Flexible(
                child: ListView(
                  padding: const EdgeInsets.all(0),
                  children: widget.marketData.marketData[widget.baseCurrency]!
                      .map(
                        (e) => GestureDetector(
                          onTap: () {
                            widget.updateFunction(
                              baseCurrency: e.baseCurrency.shortName,
                              targetCurrency: e.targetCurrency.shortName,
                              pair: e.pair,
                            );

                            Provider.of<TickerService>(context, listen: false)
                                .updateValues(marketPair: e.pair);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: e.targetCurrency.shortName ==
                                      widget.targetCurrency
                                  ? Colors.white.withOpacity(0.6)
                                  : null,
                            ),
                            child: Text(
                              e.targetCurrency.shortName,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
