class Currency {
  String name;
  String shortName;

  Currency({required this.name, required this.shortName});
}

class MarketPair {
  Currency baseCurrency;
  Currency targetCurrency;
  String pair;

  MarketPair({
    required this.baseCurrency,
    required this.targetCurrency,
    required this.pair,
  });
}

class Market {
  Map<String, List<MarketPair>> marketData;
  Market({required this.marketData});

  Market.empty() : this.marketData = {};
}
