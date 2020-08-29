import 'dart:io';

import 'package:ecomm_app/utils/ecomm_constants.dart';

class ConnectionChecker {
  Future<bool> canReachServer() async {
    try {
      final result = await InternetAddress.lookup(Constants.kEndPoint);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }
}
