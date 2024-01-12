import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:news/src/blocs/comments_provider.dart';
import 'package:news/src/screens/news_detail.dart';
import 'screens/news_list.dart';
import 'blocs/stories_provider.dart';

class App extends StatelessWidget {
  Widget build(context) {
    return CommentsProvider(
        child: StoriesProvider(
      child: MaterialApp(
        onGenerateRoute: routes,
      ),
    ));
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(builder: (context) {
        // final storiesBloc = StoriesProvider.of(context);
        // storiesBloc.fetchTopIds();
        return AnimatedSplashScreen(
            splash: Container(
              margin: EdgeInsets.all(10.0),
              //child: Image.asset("assets/images/Agastya2.0.png"),
              child: Image.asset(
                "assets/images/Agastya2.0.png",
                alignment: Alignment.center,
              ),
            ),
            nextScreen: NewsList());
      });
    } else {
      return MaterialPageRoute(builder: (context) {
        final commentsBloc = CommentsProvider.of(context);
        final itemId = int.parse(settings.name!.replaceFirst("/", ""));
        commentsBloc.fetchItemWithComments(itemId);
        return NewsDetail(
          itemId: itemId,
        );
      });
    }
  }
}
