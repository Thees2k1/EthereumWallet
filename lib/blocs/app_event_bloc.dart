import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../providers/bloc_provider.dart';

// 1 lisner tong de lang nge va dieu phoi cai app
// pushlish event (1 noi): Event Name & data (optional)
// lisner event (1 hoac n noi)

enum EventName {
  changeSelectedWallet,
}

class BlocEvent {
  final EventName _eventName;
  final dynamic _value;

  const BlocEvent(this._eventName, [this._value]);

  EventName get name => _eventName;

  dynamic get value => _value;
}

class AppEventBloc extends BlocBase {
  // Singleton
  static final _instance = AppEventBloc._internal();

  factory AppEventBloc() => _instance;

  AppEventBloc._internal();

  final _eventController = PublishSubject<BlocEvent>();
  // ban event
  Function(BlocEvent) get emitEvent => _eventController.sink.add;

  StreamSubscription<BlocEvent> listenEvent({
    required EventName eventName,
    required Function(BlocEvent) handler,
  }) {
    return _eventController.stream
        .where((evt) => evt.name == eventName)
        .listen(handler);
  }

  StreamSubscription<BlocEvent> listenManyEvents({
    required List<EventName> listEventName,
    required Function(BlocEvent) handler,
  }) {
    return _eventController.stream
        .where((evt) => listEventName.contains(evt.name))
        .listen(handler);
  }

  @override
  void dispose() {
    _eventController.close();
  }
}
