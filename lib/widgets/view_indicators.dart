import 'package:flutter/material.dart';
import 'package:smart_trader/services/indicator_service.dart';
import 'package:smart_trader/widgets/add_indicator_widget.dart';

class ViewIndicators extends StatefulWidget {
  final IndicatorService _indicatorService;
  const ViewIndicators({Key? key, required IndicatorService indicatorService})
      : this._indicatorService = indicatorService,
        super(key: key);

  @override
  _ViewIndicatorsState createState() => _ViewIndicatorsState();
}

class _ViewIndicatorsState extends State<ViewIndicators>
    with SingleTickerProviderStateMixin {
  bool _isOpened = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20)),
      child: AnimatedSize(
        vsync: this,
        duration: Duration(milliseconds: 200),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isOpened = !_isOpened;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(_isOpened ? Icons.arrow_back : Icons.arrow_forward),
                    if (_isOpened) Text('Indicators'),
                  ],
                ),
              ),
              if (_isOpened)
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 200, maxWidth: 120),
                  child: ListView(
                    shrinkWrap: true,
                    children: widget._indicatorService.indicators.values
                        .map(
                          (e) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.name),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.close),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              if (_isOpened)
                SizedBox(
                  height: 5,
                ),
              if (_isOpened)
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => getAddIndicatorWidget(),
                    );
                  },
                  child: Text(
                    'Add Indicator',
                    style: TextStyle(fontSize: 10),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
