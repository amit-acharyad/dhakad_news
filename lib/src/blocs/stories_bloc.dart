import '../models/itemmodel.dart';
import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';
import 'dart:async';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel?>>>();
  final _itemsFetcher = PublishSubject<int>();
  // Stream<Map<int, Future<ItemModel?>>>? items;

  Stream<List<int>> get topIds => _topIds.stream;
  Stream<Map<int, Future<ItemModel?>>> get items => _itemsOutput.stream;
  Function(int) get fetchItem => _itemsFetcher.sink.add;
  StoriesBloc() {
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput.sink);
  }
  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  clearCache() {
    return _repository.clearCache();
  }

  _itemsTransformer() {
    return ScanStreamTransformer(
        (Map<int, Future<ItemModel?>> cache, int id, index) {
      print('##$index');
      cache[id] = _repository.fetchItem(id);
      return cache;
    }, <int, Future<ItemModel?>>{});
  }

  dispose() {
    _topIds.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}
