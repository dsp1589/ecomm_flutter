import 'package:ecomm_app/services/response_classes/GetProductsResponse.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  final List<Category> items;
  final Function(List<Product>) listProducts;

  Categories(this.items, this.listProducts, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    List<Category> _elements = getRoots();
    return _CategoriesState(_elements.length == 0 ? items : _elements);
  }

  List<Category> getRoots() {
    List<Category> _nodes = items.fold(items, (previousValue, element) {
      if (element.products.length > 0) {
        previousValue.forEach((elementFe) {
          if (elementFe.childCategories.contains(element.id)) {
            if (elementFe.childCats == null) {
              elementFe.childCats = [];
            }
            element.parentCats = elementFe;
            elementFe.childCats.add(element);
          }
        });
      } else if (element.childCategories.length > 0) {
        if (element.childCats == null) {
          element.childCats = [];
          element.childCats.addAll(items.where(
              (element1) => element.childCategories.contains(element1.id)));
        } else if (element.childCats.length == 0) {
          element.childCats.addAll(items.where(
              (element1) => element.childCategories.contains(element1.id)));
        }
      }
      return previousValue;
    });
    var returnable =
        _nodes.where((element) => element.parentCats == null).toList();
    return returnable;
  }
}

class _CategoriesState extends State<Categories> {
  final List<Category> _subs;

  _CategoriesState(this._subs);

  Category _subsub;
  int selectedIdx;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: SingleChildScrollView(
            child: Row(
              children: _subs.map((e) {
                return FlatButton(
                    onPressed: () {
                      if (e.childCategories.length == 0) {
                        widget.listProducts(e.products);
                      } else {
                        widget.listProducts([]);
                        setState(() {
                          selectedIdx = e.id;
                        });
                      }
                    },
                    child: Text(e.name));
              }).toList(),
            ),
            scrollDirection: Axis.horizontal,
          ),
          height: 60,
        ),
        if (selectedIdx != null &&
            (_subsub = _subs.firstWhere(
                    (element) =>
                        element.id == selectedIdx &&
                        element.childCategories.length > 0,
                    orElse: () => null)) !=
                null)
          new Categories(
            _subsub.childCats,
            widget.listProducts,
            key: UniqueKey(),
          ),
      ],
    );
  }
}
