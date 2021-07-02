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
          child: Builder(
            builder:(context)=> Container(
              padding: EdgeInsets.all(20).copyWith(top: 90),
              child: Column(
                children: [
                  Expanded(
                    child: AutoSizeTextWithBackground(
                      'This\n string\n will bedfsdfs dfasdf asdf asdf asdf '
                          'This string will be automatically resized to'
                          'asdf sdf sIsdf sdfs dfsdfs dfaxsdf asd aksdjf aksjdföka jsdfökj'
                          'asdjf öaksj dfölkjsdöfk asdk fjaksödjfka jsdkfjksjd fkjs dfklajsdf'
                          'a skjdföklas dkfj laöskdfj kjsadf kjasöklfjaskdfljaö'
                          'a skldfjaök jsdfökjaks dfjökakfjakösjdf kasjf ökasjdf'
                          'a skdjföa sjdföjasdkfj aksjfdkasjdf kasöfjaksdfjöak'
                          'as dfjöaskjdf öklajsdkfasklfjka jsfkajjskdfj'
                          'asdf jasdkö fskldjf klöasjdfkölas fdj'
                          'askldfj aksljdfkaösj dfkj',
                      style: TextStyle(fontSize: 60),
                      minFontSize: 5,
                      maxFontSize: 60,
                      backgroundColor: Colors.blue[300],
                      textAlign: TextAlign.center,
                      backgroundRadius: Radius.circular(10),
                      backgroundTextPadding: EdgeInsets.all(30).copyWith(top: 0, bottom: 0),
                      backgroundExpandWidth: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
