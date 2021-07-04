import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:smart_trader/api_endpoint.dart';
import 'package:smart_trader/models/candle_data.dart';

class TickerServiceData {
  String marketPair;
  String timeDuration;
  TickerServiceData({
    required this.marketPair,
    required this.timeDuration,
  });
}

class TickerService with ChangeNotifier {
  List<CandleData> candles = [];
  String marketPair;
  String timeDuration;
  SendPort? _sendPort;

  Isolate? _isolate;

  TickerService({required this.marketPair, required this.timeDuration}) {
    _startTicker();
  }

  void updateValues({String? marketPair, String? timeDuration}) {
    _stopTicker();
    if (marketPair != null) {
      this.marketPair = marketPair;
    }
    if (timeDuration != null) {
      this.timeDuration = timeDuration;
    }
    _startTicker();
  }

  void _handleMessage(dynamic message) {
    if (message is SendPort) {
      _sendPort = message;
      _sendPort!.send(TickerServiceData(
          marketPair: this.marketPair, timeDuration: this.timeDuration));
      return;
    }
    this.candles = message;
    notifyListeners();
  }

  static void _isolateEntry(dynamic message) {
    final receivePort = ReceivePort();
    SendPort? sendPort;

    receivePort.listen((dynamic message) async {
      assert(message is TickerServiceData);
      TickerServiceData tickerServiceData = message as TickerServiceData;
      String currentMarketData = tickerServiceData.marketPair;
      String currentTimeDuration = tickerServiceData.timeDuration;
      while (true) {
        try {
          print(currentMarketData);
          String url = PublicAPI.CANDLES +
              '?pair=$currentMarketData&interval=$currentTimeDuration';

          http.Response response = await http.get(Uri.parse(url));

          if (response.statusCode != 200) {
            throw 'ticker error';
          }

          List data = jsonDecode(response.body);
          List<CandleData> currentCandles =
              data.map((e) => CandleData.fromJson(e)).toList();

          sendPort!.send(currentCandles);
        } catch (e) {
          print(e);
        }
        sleep(Duration(seconds: 2));
      }
    });

    if (message is SendPort) {
      sendPort = message;
      sendPort.send(receivePort.sendPort);
    }
  }

  void _startTicker() async {
    final receivePort = ReceivePort();
    receivePort.listen(_handleMessage);

    _isolate = await Isolate.spawn(_isolateEntry, receivePort.sendPort);
  }

  void _stopTicker() {
    if (this._isolate != null) this._isolate!.kill();
    this._isolate = null;
  }

  @override
  void dispose() {
    super.dispose();
    if (this._isolate != null) this._isolate!.kill();
  }
}
