import 'package:ecomm_app/services/response_classes/GetProductsResponse.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class TopItems extends StatefulWidget {
  final Rankings _ranking;
  final List<Category> _category;
  final Function(Size, Product) _showVariants;

  TopItems(this._ranking, this._category, this._showVariants);

  @override
  State<StatefulWidget> createState() {
    _ranking.products.sort((pr1, pr2) {
      if (pr1.orderCount != null) {
        return pr1.orderCount.compareTo(pr2.orderCount);
      } else if (pr1.shares != null) {
        return pr1.shares.compareTo(pr2.shares);
      }
      return pr1.viewCount.compareTo(pr2.viewCount);
    });
    return _TopItemsState();
  }
}

class _TopItemsState extends State<TopItems> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
              child: Text(
                widget._ranking.ranking,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              padding: EdgeInsets.all(16)),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, at) {
                return GestureDetector(
                  child: Stack(
                    children: [
                      Padding(
                        child: Container(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                _getTitle(widget._ranking.products[at].id),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: RandomColor()
                                .randomColor(colorHue: ColorHue.blue),
                          ),
                        ),
                        padding: EdgeInsets.all(8),
                      ),
                      Positioned(
                        child: Text(
                          "${at + 1}",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        top: 16,
                        left: 16,
                      ),
                    ],
                  ),
                  onTap: () {
                    widget._showVariants(MediaQuery.of(context).size,
                        _getProduct(widget._ranking.products[at].id));
                  },
                );
              },
              itemCount: widget._ranking.products.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
            ),
            flex: 1,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      height: 180,
    );
  }

  String _getTitle(int idx) {
    Product ele;
    for (var x in widget._category) {
      ele = x.products.firstWhere((element) => element.id == idx, orElse: () {
        return null;
      });
      if (ele != null) {
        return ele.name;
      }
    }
    return "";
  }

  Product _getProduct(int idx) {
    Product ele;
    for (var x in widget._category) {
      ele = x.products.firstWhere((element) => element.id == idx, orElse: () {
        return null;
      });
      if (ele != null) {
        return ele;
      }
    }
    return null;
  }
}
