import 'package:ecomm_app/services/response_classes/GetProductsResponse.dart';
import 'package:ecomm_app/utils/uihelper.dart';
import 'package:ecomm_app/widgets/filter_sort_widget.dart';
import 'package:ecomm_app/widgets/multi_select.dart';
import 'package:ecomm_app/widgets/product.dart';
import 'package:ecomm_app/widgets/range_picker.dart';
import 'package:ecomm_app/widgets/top_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  List<Product> items;
  final List<Rankings> rankings;

  ProductList(this.items, this.rankings, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProductListState();
  }
}

class ProductListState extends State<ProductList> {
  List<Product> _filteredList;

  @override
  Widget build(BuildContext context) {
    if (widget.items.length == 0) return _showSelectCategory();
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                "Products",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: FilterSortWidget(
                  _sort, _filter, _filterOptions, _clearFilter),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        Expanded(
          child: Container(
            child: ListView.builder(
              itemBuilder: (context, at) {
                if (_filteredList != null && at < _filteredList.length) {
                  return ProductWidget(_filteredList[at], _showVariants);
                } else if (at < widget.items.length) {
                  return ProductWidget(widget.items[at], _showVariants);
                }
                var idx = _filteredList != null
                    ? _filteredList.length
                    : widget.items.length;
                var rankingsCount = at - idx;
                return TopItems(
                    widget.rankings[rankingsCount],
                    Provider.of<GetProductsResponse>(context).categories,
                    _showVariants);
              },
              itemCount: _filteredList != null
                  ? _filteredList.length
                  : widget.items.length +
                      (widget.rankings != null ? widget.rankings.length : 0),
              shrinkWrap: true,
            ),
          ),
        ),
      ],
    );
  }

  void _filterOptions(Function(List<String>) f) {
    Variant v = widget.items.first.variants.first;
    List<String> _returnable = [];
    if (v.color != null) _returnable.add("Filter by Color");
    if (v.price != null) _returnable.add("Filter by Price");
    if (v.size != null) _returnable.add("Filter by Size");
    _returnable.add("CLEAR FILTERS");
    f(_returnable);
  }

  void _sort(Sort s) {
    switch (s) {
      case Sort.name:
        widget.items.sort((item1, item2) {
          return item1.name.compareTo(item2.name);
        });
        setState(() {});
        break;
      case Sort.added:
        widget.items.sort((item1, item2) {
          DateTime dt = EcommFormatter.dateAndTime(item1.dateAdded);
          DateTime dt1 = EcommFormatter.dateAndTime(item2.dateAdded);
          return dt.isAfter(dt1) ? 1 : -1;
        });
        setState(() {});
        break;
      case Sort.lowToHighTax:
        widget.items.sort((item2, item1) {
          return (item2.tax.value as num).compareTo((item1.tax.value as num));
        });
        setState(() {});
        break;
    }
  }

  void _clearFilter() {
    _filteredList.clear();
    _filteredList = null;
    setState(() {});
  }

  void _filter(String s) {
    String val = s.replaceFirst("Filter by ", "");
    print(val);
    switch (val) {
      case "CLEAR FILTERS":
        _clearFilter();
        break;
      case "Color":
        var colors = Set<String>();
        widget.items.forEach((element) {
          element.variants.forEach((vElement) {
            colors.add(vElement.color);
          });
        });
        print(colors);
        List<String> _chosenColors = [];
        showDialog(
          context: this.context,
          builder: (context) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: MultiSelect(colors.toList(), _chosenColors),
                scrollDirection: Axis.vertical,
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context, _chosenColors);
                    },
                    child: Text("Filter"))
              ],
            );
          },
        ).then((value) {
          print(value);
          _populateFilteredList(value);
        });

        break;
      case "Price":
        var prices = List<num>();
        widget.items.forEach((element) {
          element.variants.forEach((vElement) {
            prices.add(vElement.price);
          });
        });
        prices = prices.toList();
        prices.sort((num2, num1){
          return num1.toDouble() > num2.toDouble() ? -1 : 1;
        });
        var min = prices.first;
        var max = prices.last;
        print(min);
        print(max);
        _showRangeFilter(min, max);
        break;
      case "Size":
        var sizes = Set<num>();
        widget.items.forEach((element) {
          element.variants.forEach((vElement) {
            sizes.add(vElement.size);
          });
        });
        sizes.toList().sort();
        var min = sizes.first;
        var max = sizes.last;
        print(min);
        print(max);
        break;
    }
  }



  Widget _showSelectCategory() {
    return Center(
      child: Container(child: Text("Please select category/sub category")),
    );
  }

  void _populateFilteredList(dynamic value) {
    if (_filteredList != null) _filteredList.clear();
    _filteredList = widget.items.where((element) {
      var _temp = false;
      element.variants.forEach((element1) {
        if (element1.color == null && !_temp) _temp = false;
        if ((value as List<String>).contains(element1.color)) {
          _temp = true;
        }
      });
      return _temp;
    }).toList();
    if (_filteredList != null && _filteredList.length == 0)
      _filteredList = null;
    setState(() {});
  }

  void _showRangeFilter(num start, num end){
    showBottomSheet(
      context: this.context,
      builder: (context) {
        return RangeSheet(start, end, _filterRange);
      },
    );
  }

  void _filterRange(RangeValues rv){
    List<Product> _returnableList = new List<Product>();
    if (_filteredList != null) _filteredList.clear();
    widget.items.forEach((element) {
      List<Variant> _variants =
      element.variants.where((elementV){
        if(elementV.price != null) {
          return elementV.price >= rv.start && elementV.price <= rv.end;
        } else if (elementV.size != null){
          return elementV.size >= rv.start && elementV.size <= rv.end;
        }
        return true;
      }).toList();
      if(_variants.length > 0){
        _returnableList.add(element);
        element.variants = _variants;
      }
    });
    _filteredList = _returnableList;
    if (_filteredList != null && _filteredList.length == 0)
      _filteredList = null;
    setState(() {});

  }

  void _showVariants(Size s, Product _product) {
    showBottomSheet(
      context: this.context,
      builder: (context) {
        return Container(
          height: s.height * 0.3,
          width: s.width,
          child: Column(
            children: [
              UIHelper.Spacer(vertical: 16),
              Text("Variants"),
              Expanded(
                  child: ListView.builder(
                itemBuilder: (context, at) {
                  return Container(
                    width: s.width * 0.3,
                    child: Column(
                      children: [
                        ...[
                          if (_product.variants[at].color != null)
                            Text("Color: ${_product.variants[at].color}"),
                          if (_product.variants[at].size != null)
                            Text("Size: ${_product.variants[at].size}"),
                          if (_product.variants[at].price != null)
                            Text("Price: ${_product.variants[at].price}"),
                        ]
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                    ),
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                      color: Colors.white,
                    ),
                  );
                },
                itemCount: _product.variants.length,
                scrollDirection: Axis.horizontal,
              )),
            ],
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              boxShadow: [BoxShadow(color: Colors.blue[500], blurRadius: 2)]),
        );
      },
    );
  }
}
