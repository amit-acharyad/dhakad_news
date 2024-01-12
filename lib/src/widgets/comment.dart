import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news/src/widgets/loadingcontainer.dart';
import '../models/itemmodel.dart';

class Comment extends StatelessWidget {
  final int? itemId;
  final Map<int, Future<ItemModel?>>? itemMap;
  final int? depth;
  Comment({this.itemId, this.itemMap, this.depth});
  Widget build(context) {
    return FutureBuilder(
        future: itemMap?[itemId],
        builder: (context, AsyncSnapshot<ItemModel?> snapshot) {
          if (!snapshot.hasData) {
            return LoadingContainer();
          }
          final children = <Widget>[
            ListTile(
              title: buildText(snapshot.data),
              subtitle: snapshot.data?.by == " "
                  ? Text("Ooops! This Comment was Deleted")
                  : Text("${snapshot.data?.by}"),
              contentPadding:
                  EdgeInsets.only(right: 16.0, left: (depth ?? 1) * 16.0),
            ),
            Divider(),
          ];
          snapshot.data?.kids?.forEach((kidId) {
            Comment(itemId: kidId, itemMap: itemMap, depth: (depth ?? 1) + 1);
          });

          return Column(children: children);
        });
  }

  Widget buildText(ItemModel? item) {
    final String? text = item?.text
        ?.replaceAll("&#x27;", "'")
        .replaceAll('<p>', "\n\n")
        .replaceAll('</p>', '')
        .replaceAll("&gt;", ">");
    return Text("$text");
  }
}
