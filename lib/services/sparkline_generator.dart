import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SparklineGenerator {
  static Future<String?> generateSparklinePng(List<int> timesMs) async {
    if (timesMs.isEmpty || kIsWeb) return null;

    final width = 200.0;
    final height = 60.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
        recorder, Rect.fromPoints(const Offset(0, 0), Offset(width, height)));

    // Define colors
    final paintLine = Paint()
      ..color = const Color(
          0xFF64FFDA) // A nice teal/cyan color (matches primary/accent vibes)
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final paintFill = Paint()..style = PaintingStyle.fill;

    // Handle single point
    if (timesMs.length == 1) {
      canvas.drawCircle(Offset(width / 2, height / 2), 4,
          paintLine..style = PaintingStyle.fill);
      return _saveCanvasToPng(recorder, width, height);
    }

    // Determine min and max to scale
    final maxMs = timesMs.reduce((a, b) => a > b ? a : b);
    final minMs = timesMs.reduce((a, b) => a < b ? a : b);

    final range = maxMs == minMs ? 1.0 : (maxMs - minMs).toDouble();
    final stepX = width / (timesMs.length - 1);

    final path = Path();
    final fillPath = Path();

    // Map the times assuming lower is better -> lower times should be HIGHER on the chart visually
    // Wait, usually faster solves (lower time) are considered a "peak" in positive charts,
    // but typically a time chart plots Y=time where lower is at bottom. Let's make it standard: lower time = lower Y.
    // However, if we want an "improvement" sparkline, maybe lower time = higher Y. Let's stick to lower time = lower Y.
    // Wait, user reads it: down is good.
    // Actually, in widgets it's usually standard: larger value = higher Y.
    // Let's do higher Y = slower time (closer to top of rect). Bottom of rect = 0/fastest.

    final paddingY = 8.0;
    final drawableHeight = height - paddingY * 2;

    for (int i = 0; i < timesMs.length; i++) {
      final x = i * stepX;
      // Normalization: (time - min) / range -> 0.0 (fastest) to 1.0 (slowest)
      // Visual Y: height - padding - (normalized * drawableHeight) -> slowest at top, fastest at bottom
      final normalized = (timesMs[i] - minMs) / range;
      final y = (height - paddingY) - (normalized * drawableHeight);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, height); // start fill from bottom
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      if (i == timesMs.length - 1) {
        fillPath.lineTo(x, height); // finish fill to bottom
        fillPath.close();
      }
    }

    // Draw gradient fill
    paintFill.shader = ui.Gradient.linear(
      const Offset(0, 0),
      Offset(0, height),
      [
        const Color(0xFF64FFDA).withOpacity(0.4),
        const Color(0xFF64FFDA).withOpacity(0.0),
      ],
    );
    canvas.drawPath(fillPath, paintFill);

    // Draw the line
    canvas.drawPath(path, paintLine);

    // Draw a dot on the last data point
    final lastX = (timesMs.length - 1) * stepX;
    final lastNormalized = (timesMs.last - minMs) / range;
    final lastY = (height - paddingY) - (lastNormalized * drawableHeight);
    canvas.drawCircle(Offset(lastX, lastY), 4, Paint()..color = Colors.white);

    return _saveCanvasToPng(recorder, width, height);
  }

  static Future<String?> _saveCanvasToPng(
      ui.PictureRecorder recorder, double width, double height) async {
    if (kIsWeb) return null;
    try {
      final picture = recorder.endRecording();
      final img = await picture.toImage(width.toInt(), height.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return null;

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/sparkline.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      return file.path;
    } catch (e) {
      debugPrint("Error generating sparkline PNG: $e");
      return null;
    }
  }
}
