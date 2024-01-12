import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  Widget build(context) {
    return Column(
      children: [
        ListTile(
          title: buildContainer(),
          subtitle: buildContainer(),
        ),
        Divider(height: 10.0, color: Colors.grey)
      ],
    );
  }

  Widget buildContainer() {
    return Container(
      margin:EdgeInsets.only(top:5.0,bottom:5.0),
      color:Colors.grey,
      height: 20.0,
      width: 150.0,
    );
  }
}
