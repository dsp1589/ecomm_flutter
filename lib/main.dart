import 'package:chopper/chopper.dart';
import 'package:ecomm_app/bloc_app/app_bloc.dart';
import 'package:ecomm_app/services/ecomm_client.dart';
import 'package:ecomm_app/services/json_to_type_converter.dart';
import 'package:ecomm_app/services/response_classes/GetProductsResponse.dart';
import 'package:ecomm_app/utils/ecomm_constants.dart';
import 'package:ecomm_app/widgets/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final chopperClient = ChopperClient(
      baseUrl: Constants.kEndPoint,
      services: [Service.create()],
      converter: JsonToTypeConverter({
        GetProductsResponse: (jsonData) =>
            GetProductsResponse.fromJson(jsonData)
      }));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECommerce',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiProvider(
        providers: [
          Provider<ChopperClient>(
            create: (context) {
              return chopperClient;
            },
          ),
          BlocProvider(create: (context) {
            return EcommAppBloc(EcommAppStateInit());
          })
        ],
        child: MyHomePage(title: 'ECommerce App'),
      ),
    );
  }
}
