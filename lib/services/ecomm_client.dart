import 'package:chopper/chopper.dart';
import 'package:ecomm_app/services/response_classes/GetProductsResponse.dart';

part "ecomm_client.chopper.dart";

@ChopperApi()
abstract class Service extends ChopperService {
  static Service create([ChopperClient client]) => _$Service(client);

  @Get(path: "/json")
  Future<Response<GetProductsResponse>> getProducts();
}

Response<T> convertResponse<T>(Response res) =>
    JsonConverter().convertResponse(res);
