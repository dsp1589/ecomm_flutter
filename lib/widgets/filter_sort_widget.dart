import 'package:ecomm_app/utils/uihelper.dart';
import 'package:flutter/material.dart';

enum Sort {
  name,
  added,
  lowToHighTax,
}

class FilterSortWidget extends StatelessWidget {
  final Function(Sort) sort;
  final Function(String) filter;
  final Function _filterOptions;
  final Function _clearFilters;

  FilterSortWidget(
    this.sort,
    this.filter,
    this._filterOptions,
    this._clearFilters,
  );

  @override
  Widget build(BuildContext context) {
    List<String> ls = [];
    Function(List<String>) _f = (l) {
      ls.addAll(l);
    };
    _filterOptions(_f);

    return Row(
      children: [
        PopupMenuButton<Sort>(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text("By Name"),
                value: Sort.name,
              ),
              PopupMenuItem(
                child: Text("By Date Added"),
                value: Sort.added,
              ),
              PopupMenuItem(
                child: Text("Low to High Tax"),
                value: Sort.lowToHighTax,
              ),
            ];
          },
          child: Row(
            children: [
              Icon(
                Icons.sort,
                color: Colors.deepOrange,
              ),
              Text("Sort")
            ],
          ),
          onSelected: (v) {
            sort(v);
          },
        ),
        if (ls.length > 0) UIHelper.Spacer(horizontal: 16),
        if (ls.length > 0)
          PopupMenuButton<String>(
            itemBuilder: (context) {
              return ls
                  .map((e) => PopupMenuItem(
                        child: Text(e),
                        value: e,
                      ))
                  .toList();
            },
            child: Row(
              children: [
                Icon(
                  Icons.filter_list,
                  color: Colors.purple,
                ),
                Text("Filter")
              ],
            ),
            onSelected: (val) {
              filter(val);
            },
          )
      ],
      mainAxisAlignment: MainAxisAlignment.end,
    );
  }
}
