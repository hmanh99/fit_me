import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fit_me/core/theme/app_theme.dart';
void main() {
  testWidgets('measure schedule date for compact phones', (tester) async {
    final bytes = File('C:/flutter_windows_3.41.4-stable/flutter/bin/cache/artifacts/material_fonts/roboto-regular.ttf').readAsBytesSync();
    await (FontLoader('Roboto')..addFont(Future.value(ByteData.sublistView(bytes)))).load();
    final painter = TextPainter(
      text: TextSpan(text: 'Wednesday, September 30, 2026', style: AppTheme.light.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600, fontFamily: 'Roboto')),
      textDirection: TextDirection.ltr,
    )..layout();
    final fixedWidth = 48 + 32 + 24 + 12 + 24;
    print('MEASUREMENT font=${painter.text} textWidth=${painter.width} minimumScreenWidth=${painter.width + fixedWidth}; at360Overflow=${painter.width + fixedWidth - 360}');
    expect(painter.width + fixedWidth, greaterThan(360));
  });
}
