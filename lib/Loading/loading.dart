import 'package:flutter/material.dart';


class LoadingIndicator extends StatelessWidget {

 @override 
  Widget build(BuildContext context) {
     return  Scaffold(
       appBar: AppBar(
         title: Text("Analyzing results"),
        ),
         body:Dialog(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
            new Text("Retrieving"),
          ],
        ),
      )
     );
  }
}