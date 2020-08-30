import 'package:ecomm_app/widgets/product_list.dart';
import 'package:flutter/material.dart';

class RangeSheet extends StatefulWidget {
  final num start;
  final num end;
  final Function(RangeValues, VariantComp) _rangePicked;
  final VariantComp _vc;
  RangeSheet(this.start, this.end, this._rangePicked, this._vc);

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
          Padding(child:RangeSlider(
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
            divisions: 20,
          ), padding: EdgeInsets.symmetric(horizontal: 20),),
          Row(
            children: [FlatButton(onPressed: () {
              widget._rangePicked(rv, widget._vc);
            }, child: Text("Done"))],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
        ],
      ),
    );
  }

}
