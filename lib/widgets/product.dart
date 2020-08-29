import 'package:ecomm_app/services/response_classes/GetProductsResponse.dart';
import 'package:ecomm_app/utils/uihelper.dart';
import 'package:flutter/material.dart';

class ProductWidget extends StatefulWidget {
  final Product _product;
  final Function(Size, Product) _showVariants;

  ProductWidget(this._product, this._showVariants);

  @override
  State<StatefulWidget> createState() {
    return _ProductWidgetState();
  }
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    widget._product.name,
                    softWrap: true,
                    textAlign: TextAlign.left,
                  ),
                  UIHelper.Spacer(vertical: 8.0),
                  Text(EcommFormatter.formattedDate(widget._product.dateAdded)),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
            if (widget._product.variants.length > 0)
              Container(
                child: Text(
                    "${widget._product.variants.length} variants available"),
                padding: EdgeInsets.only(right: 8),
              ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      onTap: () {
//        _showVariants(MediaQuery.of(context).size);
        widget._showVariants(MediaQuery.of(context).size, widget._product);
      },
    );
  }

  void _showVariants(Size s) {
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
                          if (widget._product.variants[at].color != null)
                            Text(
                                "Color: ${widget._product.variants[at].color}"),
                          if (widget._product.variants[at].size != null)
                            Text("Size: ${widget._product.variants[at].size}"),
                          if (widget._product.variants[at].price != null)
                            Text(
                                "Price: ${widget._product.variants[at].price}"),
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
                itemCount: widget._product.variants.length,
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
