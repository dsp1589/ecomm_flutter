import 'package:chopper/chopper.dart';
import 'package:ecomm_app/bloc_app/app_bloc.dart';
import 'package:ecomm_app/services/ecomm_client.dart';
import 'package:ecomm_app/services/response_classes/GetProductsResponse.dart';
import 'package:ecomm_app/utils/connection_checker.dart';
import 'package:ecomm_app/utils/database_wrapper.dart';
import 'package:ecomm_app/widgets/categories.dart';
import 'package:ecomm_app/widgets/loader.dart';
import 'package:ecomm_app/widgets/product_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Product> productList = [];
  final GlobalKey<ProductListState> _productListKey =
      GlobalKey<ProductListState>();
  bool _goOfflineMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.blue[700]),
          ),
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          elevation: 0,
        ),
        body: BlocBuilder<EcommAppBloc, EcommAppState>(
          builder: (context, appState) {
            if (appState is EcommAppStateInit) {
              return FutureBuilder<bool>(
                builder: (context, data) {
                  if (data.hasData &&
                      data.connectionState == ConnectionState.done) {
                    if (data.data) {
                      BlocProvider.of<EcommAppBloc>(context)
                          .add(EcommAppEventStart());
                      return Loader();
                    } else {
                      return Loader(
                        message: "Unable to reach server",
                        retry: true,
                        retryFunction: _retryInternet,
                        offLineMode: _goOffline,
                      );
                    }
                  } else {
                    return Loader();
                  }
                },
                future: ConnectionChecker().canReachServer(),
              );
            }
            if(_goOfflineMode){
              return FutureBuilder<GetProductsResponse>(builder: (context, data){
                if(data.connectionState != ConnectionState.done){
                  return Loader();
                }
                return Provider<GetProductsResponse>(
                  create: (context) {
                    return data.data;
                  },
                  child: _getMainBody(data.data),
                );
              }, future: LocalDatebase.shared.getSavedResponse(),);
            }
            return FutureBuilder<Response<GetProductsResponse>>(
              builder: (context, data) {
                if (data.hasData ||
                    data.connectionState == ConnectionState.done) {
                  if (data.error != null) {
                    return Loader(
                      message: "Something unexpected happened",
                      retry: true,
                      retryFunction: _retryInternet,
                    );
                  } else if (data?.data?.body == null)
                    return Loader(
                      message: "Unable to process data",
                      retry: true,
                      retryFunction: _retryInternet,
                    );
                  LocalDatebase.shared.saveCategoriesToDB(data.data.body);
                  return Provider<GetProductsResponse>(
                    create: (context) {
                      return data.data.body;
                    },
                    child: _getMainBody(data.data.body),
                  );
                } else {
                  return Loader();
                }
              },
              future:Provider.of<ChopperClient>(context)
                  .getService<Service>()
                  .getProducts(),
            );
          },
        ));
  }

  Widget _getMainBody(GetProductsResponse response){
    return Column(
      children: [
        Categories(response.categories, showProducts),
        Expanded(
            child: Container(
              child: ProductList(
                productList,
                response.rankings,
                key: _productListKey,
              ),
            )),
      ],
    );
  }

  void showProducts(List<Product> _products) {
    productList.clear();
    productList.addAll(_products);
    _productListKey.currentState.widget.items = productList;
    _productListKey.currentState.setState(() {});
  }

  void _retryInternet() {
    BlocProvider.of<EcommAppBloc>(this.context).add(EcommAppEventInit());
  }

  void _goOffline() async {
    var response = await LocalDatebase.shared.getSavedResponse();
    if(response != null){
      _goOfflineMode = true;
      BlocProvider.of<EcommAppBloc>(this.context)
          .add(EcommAppEventStart());
    }
  }
}
