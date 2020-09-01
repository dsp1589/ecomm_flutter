import 'dart:convert';
import 'dart:io';

import 'package:ecomm_app/services/response_classes/GetProductsResponse.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast.dart';
import 'package:path_provider/path_provider.dart';

class LocalDatebase {

  static LocalDatebase shared = LocalDatebase._();

  LocalDatebase._();

  String _dbPath = 'ecomm_app.db';
  DatabaseFactory _dbFactory = databaseFactoryIo;
  var _store = StoreRef.main();

  Future<bool> saveCategoriesToDB(GetProductsResponse response) async {

    String _writablePath = (await getApplicationDocumentsDirectory()).path;
    _writablePath += Platform.pathSeparator;
    _writablePath += _dbPath;
    Database db =  await _dbFactory.openDatabase(_writablePath);
    Map<String, dynamic> jsonOfResponse = response.toJson();
    var result = await _store.record('categories').put(db, jsonOfResponse);
    db.close();
    return result == jsonOfResponse;
  }

  Future<GetProductsResponse> getSavedResponse() async {
    String _writablePath = (await getApplicationDocumentsDirectory()).path;
    _writablePath += Platform.pathSeparator;
    _writablePath += _dbPath;
    Database db =  await _dbFactory.openDatabase(_writablePath);
    final result = await _store.record('categories').get(db);
    if(result != null){
      try{
        final response = GetProductsResponse.fromJson(result);
        db.close();
        return response;
      }catch( err ){
        print(err);
      }finally{
        db.close();
      }
    }
    db.close();
    return null;

  }

}