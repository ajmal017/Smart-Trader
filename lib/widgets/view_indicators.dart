import 'package:flutter/material.dart';
import 'package:smart_trader/services/indicator_service.dart';

class ViewIndicators extends StatefulWidget {
  final IndicatorService _indicatorService;
  const ViewIndicators({Key? key, required IndicatorService indicatorService})
      : this._indicatorService = indicatorService,
        super(key: key);

  @override
  _ViewIndicatorsState createState() => _ViewIndicatorsState();
}

class _ViewIndicatorsState extends State<ViewIndicators> {
  bool _isOpened = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      constraints: BoxConstraints(maxHeight: 300, maxWidth: 50),
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isOpened = !_isOpened;
                });
              },
              child: Icon(_isOpened ? Icons.arrow_back : Icons.arrow_forward),
            ),
          ),
          if (_isOpened)
            Flexible(
                child: ListView(
              children: widget._indicatorService.indicators.keys
                  .map((e) => Text(e.toString()))
                  .toList(),
            )),
        ],
      ),
    );
  }
}
