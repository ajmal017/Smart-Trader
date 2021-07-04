class API {
  static const String BASE = 'https://api.coindcx.com';
  static const String TICKER = BASE + '/exchange/ticker';
  static const String MARKET_DETAILS = BASE + '/exchange/v1/markets_details';
}

class PublicAPI {
  static const String BASE = 'https://public.coindcx.com';
  static const String CANDLES = BASE + '/market_data/candles';
}
