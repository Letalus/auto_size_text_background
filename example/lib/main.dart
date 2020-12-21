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
              'This\n string\n will bedfsdfs dfasdf asdf asdf asdf '
                  'This string will be automatically resized to'
                  'asdf sdf sIsdf sdfs dfsdfs dfaxsdf asd',
              style: TextStyle(fontSize: 50),
              minFontSize: 5,
              backgroundColor: Colors.blue[300],
              textAlign: TextAlign.center,
              backgroundRadius: Radius.circular(40),
              backgroundTextPadding: EdgeInsets.all(20),
            ),
          ),
        ),
      ),
    );
  }
}
