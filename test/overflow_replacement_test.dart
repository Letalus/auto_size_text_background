import 'package:auto_size_text_background/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  testWidgets('Overflow replacement visible on overflow', (tester) async {
    final text = await pumpAndGetText(
      tester: tester,
      widget: SizedBox(
        width: 100,
        height: 20,
        child: AutoSizeTextWithBackground(
          'XXXXXX',
          overflowReplacement: Text('OVERFLOW!'),
          minFontSize: 20,
        ),
      ),
    );
    expect(text.data, 'OVERFLOW!');
  });

  testWidgets('Overflow replacement not visible without overflow',
      (tester) async {
    final text = await pumpAndGetText(
      tester: tester,
      widget: SizedBox(
        width: 100,
        height: 20,
        child: AutoSizeTextWithBackground(
          'XXXXX',
          style: TextStyle(fontSize: 20),
          overflowReplacement: Text('OVERFLOW!'),
        ),
      ),
    );
    expect(text.data, 'XXXXX');
  });
}
