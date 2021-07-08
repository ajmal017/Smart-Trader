import 'package:flutter/material.dart';
import 'package:smart_trader/models/indicator_enum.dart';
import 'package:smart_trader/services/indicators.dart';

Dialog getAddIndicatorWidget() {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: AddIndicatorWidget(),
  );
}

class AddIndicatorWidget extends StatefulWidget {
  const AddIndicatorWidget({Key? key}) : super(key: key);

  @override
  _AddIndicatorWidgetState createState() => _AddIndicatorWidgetState();
}

class _AddIndicatorWidgetState extends State<AddIndicatorWidget> {
  late List<IndicatorType> _allIndicators;

  String searchText = "";
  List<IndicatorType> currentIndicators = [];

  @override
  void initState() {
    _allIndicators = IndicatorType.values;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (searchText == "")
      currentIndicators = [];
    else
      currentIndicators = _allIndicators
          .where((element) => element
              .toString()
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();

    return Container(
      height: 300,
      width: 300,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            textAlign: TextAlign.center,
          ),
          Flexible(
            child: ListView(
              children: currentIndicators
                  .map((e) => Text(e.toString().split('.').last))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
