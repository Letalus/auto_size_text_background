import 'package:auto_size_text_background/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  testWidgets('Respects maxlines', (tester) async {
    await pump(
      tester: tester,
      widget: AutoSizeTextWithBackground(
        'XXXXX',
        style: TextStyle(fontSize: 27),
        maxLines: 1,
      ),
    );
    var height = tester.getSize(find.byType(RichText)).height;
    expect(height, 27);

    await pump(
      tester: tester,
      widget: SizedBox(
        width: 75,
        child: AutoSizeTextWithBackground(
          'XXX XXX',
          style: TextStyle(fontSize: 25),
          maxLines: 2,
        ),
      ),
    );
    height = tester.getSize(find.byType(RichText)).height;
    expect(height, 50);
  });

  testWidgets('Unlimited maxLines if parameter null', (tester) async {});
}
