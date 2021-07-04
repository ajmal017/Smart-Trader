class CandleData {
  double open;
  double high;
  double low;
  double close;
  double? volume;
  int time;

  CandleData({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.time,
    this.volume,
  });

  CandleData.fromJson(Map<String, dynamic> data)
      : this.open = data['open'] * 1.0,
        this.high = data['high'] * 1.0,
        this.close = data['close'] * 1.0,
        this.low = data['low'] * 1.0,
        this.time = data['time'],
        this.volume = data['volume'] * 1.0;
}
