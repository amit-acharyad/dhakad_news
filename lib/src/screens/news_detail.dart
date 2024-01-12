import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news/src/blocs/comments_bloc.dart';
import 'package:news/src/blocs/comments_provider.dart';
import 'package:news/src/widgets/comment.dart';
import 'package:news/src/widgets/loadingcontainer.dart';
import '../models/itemmodel.dart';

class NewsDetail extends StatelessWidget {
  final int? itemId;
  NewsDetail({this.itemId});
  Widget build(context) {
    final bloc = CommentsProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("News Details",
        style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold,color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
        stream: bloc.itemWithComments,
        builder:
            (context, AsyncSnapshot<Map<int, Future<ItemModel?>>> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final itemFuture = snapshot.data?[itemId];
          return FutureBuilder(
            future: itemFuture,
            builder: (context, AsyncSnapshot<ItemModel?> itemSnapshot) {
              if (!itemSnapshot.hasData) {
                return LoadingContainer();
              }
              return buildList(itemSnapshot.data, snapshot.data);
            },
          );
        });
  }

  buildList(ItemModel? item, Map<int, Future<ItemModel?>>? itemMap) {
    final children = <Widget>[];
    children.add(buildTitle(item));
    final commentList = item?.kids?.map((kidId) {
      return Comment(itemId: kidId, itemMap: itemMap,depth:1);
    }).toList();
    if (commentList != null) {
      children.addAll(commentList.cast<Widget>());
    }
    // children.addAll(commentList);
    return ListView(children: children);
  }

  buildTitle(ItemModel? item) {
    return Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.all(20.0),
        child: Text(
          item?.title ?? "Default",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
