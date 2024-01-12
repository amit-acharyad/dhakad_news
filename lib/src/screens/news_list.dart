import 'package:flutter/material.dart';
import 'package:news/src/widgets/news_list_tile.dart';
import 'dart:async';
import '../blocs/stories_provider.dart';
import '../blocs/stories_bloc.dart';
import '../widgets/refresh.dart';

class NewsList extends StatelessWidget {
  Widget build(context) {
    final bloc = StoriesProvider.of(context);
    bloc.fetchTopIds();
    return Scaffold(
      appBar: AppBar(
        title: Text("Top Stories",
        style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold,color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
        stream: bloc.topIds,
        builder: (context, AsyncSnapshot<List<int>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Refresh(
              child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, int index) {
                    bloc.fetchItem(snapshot.data![index]);
                    return NewsListTile(itemId: snapshot.data?[index]);
                  }));
        });
  }

  // Widget buildList() {
  //   return ListView.builder(
  //       itemCount: 10,
  //       itemBuilder: ((context, index) {
  //         return Container(
  //             margin: EdgeInsets.all(20.0),
  //             height: 100,
  //             child: FutureBuilder(
  //                 future: getFuture(),
  //                 builder: ((context, snapshot) {
  //                   return snapshot.hasData ? Text("GOt data") : Text("Oops");
  //                 })));
  //       }));
  // }

  // getFuture() {
  //   return Future.delayed(Duration(seconds: 2), () => "haha");
  // }
}
