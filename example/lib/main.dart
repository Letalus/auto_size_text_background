import 'package:auto_size_text_background/auto_size_text.dart';
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
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(50),
              child: AutoSizeTextWithBackground(
                'This\n string\n will bedfsdfs dfasdf asdf asdf asdf '
                    'This string will be automatically resized to'
                    'asdf sdf sIsdf sdfs dfsdfs dfaxsdf asd',
                style: TextStyle(fontSize: 45),
                minFontSize: 5,
                maxFontSize: 80,
                backgroundColor: Colors.blue[300],
                textAlign: TextAlign.left,
                backgroundRadius: Radius.circular(10),
                backgroundTextPadding: EdgeInsets.all(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
