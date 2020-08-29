// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ecomm_client.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$Service extends Service {
  _$Service([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = Service;

  @override
  Future<Response<GetProductsResponse>> getProducts() {
    final $url = 'json';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<GetProductsResponse, GetProductsResponse>($request);
  }
}
