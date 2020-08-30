import 'package:flutter/material.dart';

class RangeSheet extends StatefulWidget {
  final num start;
  final num end;
  final Function(RangeValues) _rangePicked;
  RangeSheet(this.start, this.end, this._rangePicked);

  @override
  State<StatefulWidget> createState() {
    return _RangeSheetState(RangeValues(start.toDouble(), end.toDouble()));
  }
}

class _RangeSheetState extends State<RangeSheet> {

  RangeValues rv;
  _RangeSheetState(this.rv);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        children: [
          Row(
            children: [
              Text("Filter by Range"),
            ],
          ),
          RangeSlider(
            values: rv,
            onChanged: (rangevalue) {
              setState(() {
                rv = rangevalue;
              });
            },
            min: widget.start.toDouble(),
            max: widget.end.toDouble(),
            labels: RangeLabels("${rv.start.toInt()}", "${rv.end.toInt()}"),
            activeColor: Colors.blue[500],
            inactiveColor: Colors.blue[50],
            divisions: ((rv.end - rv.start) / 10).floor() >= 5 ? ((rv.end - rv.start) / 10).floor() : 5,
          ),
          Row(
            children: [FlatButton(onPressed: () {
              widget._rangePicked(rv);
            }, child: Text("Done"))],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
        ],
      ),
    );
  }

}
