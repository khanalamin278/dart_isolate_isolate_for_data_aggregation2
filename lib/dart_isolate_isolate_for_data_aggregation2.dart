/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

export 'src/dart_isolate_isolate_for_data_aggregation2_base.dart';

import 'dart:async';
import 'dart:isolate';

/*
Practice Question 3: Isolate for Data Aggregation
Task:
Implement a function aggregateDataInIsolate that takes a 
list of maps (e.g., representing records or data points) and a key. 
It should aggregate the data based on the key in a separate isolate 
and return a Future<Map<dynamic, List<Map>>> where each key is 
mapped to a list of records having that key value.
 */

Future<Map<dynamic, List<Map>>> aggregateDataInIsolate(
    List<Map> data, dynamic key) async {
  Completer<Map<dynamic, List<Map>>> completer =
      Completer<Map<dynamic, List<Map>>>();

  ReceivePort receivePort = ReceivePort();

  Isolate isolate = await Isolate.spawn(aggregateIsolate,
      {'data': data, 'key': key, 'sendPort': receivePort.sendPort});

  if (!data.any((element) => element.containsKey(key))) {
    return {};
  }

  receivePort.listen((message) {
    completer.complete(message);
    receivePort.close();
  });

  isolate.addOnExitListener(receivePort.sendPort);

  return completer.future;
}

void aggregateIsolate(Map<String, dynamic> input) {
  List<Map> data = input['data'];
  dynamic key = input['key'];
  SendPort sendPort = input['sendPort'];

  Map<dynamic, List<Map>> ans = {};

  for (var indev in data) {
    dynamic keyValue = indev[key];

    if (!ans.containsKey(keyValue)) {
      ans[keyValue] = [];
    }

    ans[keyValue]?.add(indev);
  }

  sendPort.send(ans);
}
