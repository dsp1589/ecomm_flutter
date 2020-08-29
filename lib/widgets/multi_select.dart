import 'package:flutter/material.dart';

class MultiSelect extends StatefulWidget {
  final List<String> options;
  List<String> _ref;

  MultiSelect(this.options, this._ref);

  @override
  State<StatefulWidget> createState() {
    return _MultiSelectState();
  }
}

class _MultiSelectState extends State<MultiSelect> {
  List<String> _selected = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.options
            .toList()
            .map(
              (e) => GestureDetector(
                child: Row(
                  children: [
                    _selected.contains(e)
                        ? Icon(Icons.done)
                        : Icon(Icons.circle),
                    Text(e)
                  ],
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
                onTap: () {
                  if (_selected.contains(e)) {
                    _selected.remove(e);
                    widget._ref.remove(e);
                  } else {
                    _selected.add(e);
                    widget._ref.add(e);
                  }
                  setState(() {});
                },
              ),
            )
            .toList()
      ],
    );
  }
}
