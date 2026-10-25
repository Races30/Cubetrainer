import 'package:flutter/material.dart';
import '../models/oll_pll_case.dart';

class CubeTopView extends StatelessWidget {
  final OllPllCase ollPllCase;
  final double size;

  const CubeTopView({
    super.key,
    required this.ollPllCase,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CubeTopPainter(ollPllCase),
    );
  }
}

class _CubeTopPainter extends CustomPainter {
  final OllPllCase c;

  _CubeTopPainter(this.c);

  @override
  void paint(Canvas canvas, Size size) {
    final double padding = size.width * 0.12;
    final double innerSize = size.width - padding * 2;
    final double cellSize = innerSize / 3;

    final Paint borderPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    void drawSideSticker(int colorCode, Rect rect) {
      if (colorCode == 0) return; // Skip empty sides
      canvas.drawRect(rect, Paint()..color = const Color(0xFFEAB308)); // Yellow
      canvas.drawRect(rect, borderPaint);
    }

    final double thickness = padding * 0.7;

    // Draw Side Stickers (only for OLL if edgeBand is provided)
    if (c.category == 'OLL' && c.edgeBand.length >= 4) {
      // Index 0: Front, 1: Right, 2: Back, 3: Left
      // Front edge (placed at bottom of the 2D view)
      drawSideSticker(
        c.edgeBand[0],
        Rect.fromLTWH(
            padding + cellSize, padding + innerSize, cellSize, thickness),
      );
      // Right edge
      drawSideSticker(
        c.edgeBand[1],
        Rect.fromLTWH(
            padding + innerSize, padding + cellSize, thickness, cellSize),
      );
      // Back edge (placed at top of the 2D view)
      drawSideSticker(
        c.edgeBand[2],
        Rect.fromLTWH(
            padding + cellSize, padding - thickness, cellSize, thickness),
      );
      // Left edge
      drawSideSticker(
        c.edgeBand[3],
        Rect.fromLTWH(
            padding - thickness, padding + cellSize, thickness, cellSize),
      );
    }

    // Draw Top Face 3x3
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        int val = 0;
        if (c.uFaceGrid.length > row && c.uFaceGrid[row].length > col) {
          val = c.uFaceGrid[row][col];
        }

        Color color =
            val == 1 ? const Color(0xFFEAB308) : const Color(0xFF64748B);
        Rect rect = Rect.fromLTWH(
          padding + col * cellSize,
          padding + row * cellSize,
          cellSize,
          cellSize,
        );
        canvas.drawRect(rect, Paint()..color = color);
        canvas.drawRect(rect, borderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CubeTopPainter oldDelegate) {
    return oldDelegate.c.id != c.id;
  }
}
