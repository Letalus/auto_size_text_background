import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(50),
            child: AutoSizeTextWithBackground(
              'This\n string\n will be automatically resized to\n'
                  'asdf sdf sdf sdfs dfsdfs dfasdf asdf asdf asdf '
                  'This string will be automatically resized to'
                  'asdf sdf sdf sdfs dfsdfs dfasdf asdf asdf asdf '
                  'This string will be automatically resized to'
                  'asdf sdf sdf sdfs dfsdfs dfasdf asdf \nasdf asdf '
              ,
              style: TextStyle(fontSize: 50),
              maxFontSize: 40,
              minFontSize: 5,
              backgroundColor: Colors.red[300],
              textAlign: TextAlign.left,
              backgroundRadius: Radius.circular(10),
              backgroundTextPadding: EdgeInsets.all(5),
              maxLines: 14,
            ),
          ),
        ),
      ),
    );
  }
}
