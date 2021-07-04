import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_trader/screens/home_page.dart';
import 'package:smart_trader/theme/theme_data.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(SmartTrader());
}

class SmartTrader extends StatelessWidget {
  const SmartTrader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: HomePage(),
    );
  }
}
