import 'package:dart_isolate_isolate_for_data_aggregation2/dart_isolate_isolate_for_data_aggregation2.dart';
import 'package:test/test.dart';

void main() {
  test('aggregateDataInIsolate aggregates data by key', () async {
    var data = [
      {'type': 'fruit', 'name': 'apple'},
      {'type': 'fruit', 'name': 'banana'},
      {'type': 'vegetable', 'name': 'carrot'}
    ];
    var aggregated = await aggregateDataInIsolate(data, 'type');
    expect(aggregated.keys, containsAll(['fruit', 'vegetable']));
    expect(aggregated['fruit'], hasLength(2));
    expect(aggregated['vegetable'], hasLength(1));
  });

  test('aggregateDataInIsolate handles empty list', () async {
    var aggregated = await aggregateDataInIsolate([], 'type');
    expect(aggregated, isEmpty);
  });

  test('aggregateDataInIsolate handles key not present', () async {
    var data = [
      {'type': 'fruit', 'name': 'apple'}
    ];
    var aggregated = await aggregateDataInIsolate(data, 'color');
    expect(aggregated, isEmpty);
  });
}
