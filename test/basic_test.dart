import 'package:auto_size_text_background/auto_size_text.dart';
import 'package:auto_size_text_background/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  testWidgets('Only Text', (tester) async {
    await pump(
      tester: tester,
      widget: AutoSizeTextWithBackground('Some Text'),
    );
  });

  testWidgets('Only text (rich)', (tester) async {
    await pump(
      tester: tester,
      widget: AutoSizeTextWithBackground.rich(TextSpan(text: 'Some Text')),
    );
  });

  testWidgets('Uses style fontSize', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 34,
      widget: AutoSizeTextWithBackground(
        'Some Text',
        style: TextStyle(fontSize: 34),
      ),
    );
  });

  testWidgets('Uses style fontSize (rich)', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 35,
      widget: AutoSizeTextWithBackground.rich(
        TextSpan(text: 'Some Text'),
        style: TextStyle(fontSize: 35),
      ),
    );
  });

  testWidgets('Respects inherit style', (tester) async {
    final defaultStyle = TextStyle(
      fontSize: 20,
      color: Colors.yellow,
    );
    final text = await pumpAndGetText(
      tester: tester,
      widget: DefaultTextStyle(
        style: defaultStyle,
        textAlign: TextAlign.right,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        maxLines: 17,
        child: AutoSizeTextWithBackground(
          'AutoSizeText Test',
        ),
      ),
    );
    expect(text.style, defaultStyle);

    final richText = getRichText(tester);
    expect(richText.textAlign, TextAlign.right);
    expect(richText.softWrap, false);
    expect(richText.overflow, TextOverflow.ellipsis);
    expect(richText.maxLines, 17);
  });

  testWidgets('Applies scale even if initial fontSize fits (#25)',
      (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 60,
      widget: AutoSizeTextWithBackground(
        'Some Text',
        style: TextStyle(fontSize: 15),
        textScaleFactor: 4,
      ),
    );
  });

  testWidgets('Uses textKey', (tester) async {
    final textKey = GlobalKey();
    final text = await pumpAndGetText(
      tester: tester,
      widget: AutoSizeTextWithBackground(
        'A text with key',
        textKey: textKey,
      ),
    );
    expect(text.key, textKey);
  });
}
