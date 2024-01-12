import 'dart:async';
import 'package:flutter/material.dart';
import '../resources/repository.dart';
import '../models/itemmodel.dart';
import 'package:rxdart/rxdart.dart';

class CommentsBloc {
  final _commentFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel?>>>();
  final _repository = Repository();
  CommentsBloc() {
    _commentFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput.sink);
  }
  //streams
  Stream<Map<int, Future<ItemModel?>>> get itemWithComments =>
      _commentsOutput.stream;

  //sinks
  Function(int) get fetchItemWithComments => _commentFetcher.sink.add;
_commentsTransformer() {
  return ScanStreamTransformer<int, Map<int, Future<ItemModel?>>>(
    (Map<int, Future<ItemModel?>> cache, int id, int index) {
      print(index);
      cache[id] = _repository.fetchItem(id);
      cache[id]?.then(
        (ItemModel? item) {
          item?.kids?.forEach((kidId) => fetchItemWithComments(kidId));
        },
      );
      return Map<int, Future<ItemModel?>>.from(cache); // Ensure the correct type here
    },
    <int, Future<ItemModel?>>{},
  );
}



  dispose() {
    _commentFetcher.close();
    _commentsOutput.close();
  }
}
