// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:test/bootstrap/browser.dart';
import 'package:test/test.dart';
import 'package:ui/ui.dart' as ui;

import '../common/rendering.dart';
import '../common/test_initialization.dart';
import '../ui/utils.dart' show isWimp;

void main() {
  internalBootstrapBrowserTest(() => testMain);
}

void testMain() {
  setUpUnitTests(withImplicitView: true);

  test('Wimp renders paths and text across consecutive frames', () async {
    final paragraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle(fontSize: 18))
      ..addText('Impeller Web smoke test');
    final paragraph = paragraphBuilder.build()
      ..layout(const ui.ParagraphConstraints(width: 500));

    for (var frame = 0; frame < 30; frame++) {
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);
      canvas.drawColor(const ui.Color(0xFFFFFFFF), ui.BlendMode.src);
      canvas.drawParagraph(paragraph, const ui.Offset(20, 20));

      for (var row = 0; row < 8; row++) {
        final path = ui.Path();

        for (var sample = 0; sample < 160; sample++) {
          final x = sample * 4.0;
          final y = 80.0 + row * 48.0 + math.sin((sample + frame) * 0.06) * 18.0;

          if (sample == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }

        final paint = ui.Paint()
          ..color = const ui.Color(0xFF2E77D0)
          ..style = ui.PaintingStyle.stroke
          ..strokeWidth = 1.5;

        canvas.drawPath(path, paint);
      }

      final picture = recorder.endRecording();
      final sceneBuilder = ui.SceneBuilder()..addPicture(ui.Offset.zero, picture);
      await renderScene(sceneBuilder.build());
      picture.dispose();
    }

    paragraph.dispose();
  }, skip: !isWimp, timeout: const Timeout(Duration(minutes: 2)));
}
