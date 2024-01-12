import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'dart:async';
import '../models/itemmodel.dart';
import 'repository.dart';

class NewsApiProvider implements Source {
  Client client = Client();
  Future<List<int>> fetchTopIds() async {
    final response = await client.get(
        Uri.parse('https://hacker-news.firebaseio.com/v0/topstories.json'));
    final ids = json.decode(response.body);
    return ids.cast<int>();
  }

  Future<ItemModel?> fetchItem(int id) async {
    final response = await client
        .get(Uri.parse('https://hacker-news.firebaseio.com/v0/item/$id.json'));
   
    final parsedJson = json.decode(response.body);
    return ItemModel.fromJson(parsedJson);
  }
}
