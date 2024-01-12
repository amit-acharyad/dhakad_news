import 'dart:async';
import 'news_api_provider.dart';

import 'news_db_provider.dart';
import '../models/itemmodel.dart';

class Repository {
  // final apiProvider = NewsApiProvider();
  // final dbProvider = NewsDbProvider();
  List<Source> sources = <Source>[
    NewsApiProvider(),
    newsdbprovider,
  ];
  List<Cache> caches = <Cache>[
    newsdbprovider,
  ];

//not used only for formality
  Future<List<int>> fetchTopIds() {
    return sources[0].fetchTopIds();
  }

  Future<ItemModel?> fetchItem(id) async {
    ItemModel? item;
    Source? source;
    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }
    for (var cache in caches) {
      if ((cache as Source) != source) {
        cache.addItem(item);
      }
    }
    return item;
  }

  clearCache() async{
    for (var cache in caches) {
      await cache.clear();
    }
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel?> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel? item);
  Future<int> clear();
}
