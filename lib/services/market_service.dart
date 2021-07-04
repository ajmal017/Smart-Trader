import 'dart:convert';

import 'package:smart_trader/api_endpoint.dart';
import 'package:http/http.dart' as http;
import 'package:smart_trader/models/market.dart';

class MarketService {
  static Future<Market> getDetails() async {
    try {
      String url = API.MARKET_DETAILS;
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw 'error';
      }

      List data = jsonDecode(response.body);
      Map<String, List<MarketPair>> marketData = {};

      for (Map curr in data) {
        if (curr['pair'][0] == 'I') {
          Currency baseCurrency = Currency(
              name: curr['base_currency_name'],
              shortName: curr['base_currency_short_name']);

          Currency targetCurrency = Currency(
              name: curr['target_currency_name'],
              shortName: curr['target_currency_short_name']);
          if (marketData.containsKey(baseCurrency.shortName)) {
            marketData[baseCurrency.shortName]!.add(MarketPair(
              baseCurrency: baseCurrency,
              targetCurrency: targetCurrency,
              pair: curr['pair'],
            ));
          } else {
            marketData.addAll(
              <String, List<MarketPair>>{
                baseCurrency.shortName: [
                  MarketPair(
                    baseCurrency: baseCurrency,
                    targetCurrency: targetCurrency,
                    pair: curr['pair'],
                  )
                ]
              },
            );
          }
        }
      }

      print(marketData.length);

      return Market(marketData: marketData);
    } catch (e) {
      print(e);
      return Market.empty();
    }
  }
}
