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
  test('Wimp rasterizes stroked paths into image pixels', () async {
    const width = 64;
    const height = 32;
    const background = ui.Color(0xFFFFFFFF);
    const stroke = ui.Color(0xFF0000FF);

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, const ui.Rect.fromLTWH(0, 0, width, height));
    canvas.drawColor(background, ui.BlendMode.src);

    final path = ui.Path()
      ..moveTo(8, 16)
      ..lineTo(56, 16);
    canvas.drawPath(
      path,
      ui.Paint()
        ..color = stroke
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    final picture = recorder.endRecording();
    try {
      final image = picture.toImageSync(width, height);
      try {
        final data = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
        expect(data.lengthInBytes, width * height * 4);

        ui.Color pixelAt(int x, int y) {
          final offset = (y * width + x) * 4;
          return ui.Color.fromARGB(
            data.getUint8(offset + 3),
            data.getUint8(offset),
            data.getUint8(offset + 1),
            data.getUint8(offset + 2),
          );
        }

        expect(pixelAt(2, 2), background);
        expect(pixelAt(16, 16), stroke);
        expect(pixelAt(16, 25), background);
      } finally {
        image.dispose();
      }
    } finally {
      picture.dispose();
    }
  }, skip: !isWimp);
}
