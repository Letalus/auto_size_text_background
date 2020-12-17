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
              'This string will be automatically resized to'
                  'asdf sdf sdf sdfs dfsdfs dfasdf asdf asdf asdf '
                  'as dfas dfs dfa sf asd fas dd s df sdf as f'
                  ' fit in two lines. ASDfasdflsdfk jasöfdljk askdöfj aksdfj asödfkjkskföj'
              ,
              style: TextStyle(fontSize: 50),
              maxFontSize: 50,
              minFontSize: 5,
              backgroundColor: Colors.yellow[700],
              textAlign: TextAlign.center,
              backgroundBorderRadius: BorderRadius.circular(15),
              backgroundTextPadding: EdgeInsets.all(20),
              maxLines: 8,
            ),
          ),
        ),
      ),
    );
  }
}
