import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class EcommAppEvent {}

class EcommAppEventInit extends EcommAppEvent {}

class EcommAppEventStart extends EcommAppEvent {}

abstract class EcommAppState {}

class EcommAppStateInit extends EcommAppState {}

class EcommAppStateStart extends EcommAppState {}

class EcommAppBloc extends Bloc<EcommAppEvent, EcommAppState> {
  EcommAppBloc(EcommAppState initialState) : super(initialState);

  @override
  Stream<EcommAppState> mapEventToState(EcommAppEvent event) async* {
    if (event is EcommAppEventInit) {
      yield EcommAppStateInit();
    } else {
      yield EcommAppStateStart();
    }
  }
}
