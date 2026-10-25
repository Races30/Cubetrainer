import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/oll_pll_case.dart';
import '../models/solve.dart';

class PuzzleGridPreview extends StatelessWidget {
  final OllPllCase ollPllCase;
  final double size;

  const PuzzleGridPreview({
    super.key,
    required this.ollPllCase,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _PuzzleGridPainter(ollPllCase),
    );
  }
}

class _PuzzleGridPainter extends CustomPainter {
  final OllPllCase c;

  _PuzzleGridPainter(this.c);

  @override
  void paint(Canvas canvas, Size size) {
    switch (c.puzzle) {
      case CubeType.twoByTwo:
        _drawNxN(canvas, size, 2);
        break;
      case CubeType.threeByThree:
        _drawNxN(canvas, size, 3);
        break;
      case CubeType.fourByFour:
      case CubeType.fiveByFive:
      case CubeType.sixBySix:
      case CubeType.sevenBySeven:
        _drawParityCross(canvas, size, c);
        break;
      case CubeType.pyraminx:
        _drawPyraminx(canvas, size);
        break;
      case CubeType.megaminx:
        _drawMegaminx(canvas, size);
        break;
    }
  }

  Color _mapValueToColor(int val) {
    if (val == 0) return const Color(0xFF64748B); // Gray
    if (val == 1) return const Color(0xFFEAB308); // Yellow
    if (val == 2) return const Color(0xFFEF4444); // Red
    if (val == 3) return const Color(0xFF3B82F6); // Blue
    if (val == 4) return const Color(0xFF22C55E); // Green
    if (val == 5) return const Color(0xFFF97316); // Orange
    if (val >= 6) return const Color(0xFFA855F7); // Purple
    return const Color(0xFF64748B);
  }

  void _drawParityCross(Canvas canvas, Size size, OllPllCase c) {
    // A stylized cross of 4 rectangles for the 4 edges. 
    // uFaceGrid has parity edges marked as 1.
    final double padding = size.width * 0.15;
    final double innerSize = size.width - padding * 2;
    final double rectWidth = innerSize * 0.3;
    final double rectLength = innerSize * 0.45;

    final Paint borderPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final center = Offset(size.width / 2, size.height / 2 - padding / 2);

    // Retrieve parity error status from the 3x3 mapping (1 = error, 0 = normal)
    // We assume the cross edges are at [0][1] (Top), [1][2] (Right), [2][1] (Bottom), [1][0] (Left)
    int topError = 0;
    int rightError = 0;
    int bottomError = 0;
    int leftError = 0;

    if (c.uFaceGrid.isNotEmpty && c.uFaceGrid.length >= 3) {
      topError = c.uFaceGrid[0][1];
      leftError = c.uFaceGrid[1][0];
      rightError = c.uFaceGrid[1][2];
      bottomError = c.uFaceGrid[2][1];
    }

    void drawEdge(Offset pivot, double width, double height, int errorVal) {
      final rect = Rect.fromCenter(center: pivot, width: width, height: height);
      final color = errorVal > 0 ? const Color(0xFFEF4444) : const Color(0xFF64748B); // Red if parity
      canvas.drawRect(rect, Paint()..color = color);
      canvas.drawRect(rect, borderPaint);
    }

    drawEdge(Offset(center.dx, center.dy - innerSize / 4), rectWidth, rectLength, topError);       // Top
    drawEdge(Offset(center.dx, center.dy + innerSize / 4), rectWidth, rectLength, bottomError);    // Bottom
    drawEdge(Offset(center.dx - innerSize / 4, center.dy), rectLength, rectWidth, leftError);      // Left
    drawEdge(Offset(center.dx + innerSize / 4, center.dy), rectLength, rectWidth, rightError);     // Right

    // Draw text label below
    final textPainter = TextPainter(
      text: TextSpan(
        text: c.category.contains('OLL') ? 'OLL Parity Phase' : 'PLL Parity Phase',
        style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    textPainter.paint(canvas, Offset(size.width / 2 - textPainter.width / 2, size.height - padding * 1.5));
  }

  void _drawNxN(Canvas canvas, Size size, int n) {
    final double padding = size.width * 0.12;
    final double innerSize = size.width - padding * 2;
    final double cellSize = innerSize / n;

    final Paint borderPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    void drawSideSticker(int colorCode, Rect rect) {
      if (colorCode == 0) return;
      canvas.drawRect(rect, Paint()..color = _mapValueToColor(colorCode));
      canvas.drawRect(rect, borderPaint);
    }

    final double thickness = padding * 0.7;

    if (c.edgeBand.isNotEmpty && c.edgeBand.length >= n * 4) {
      // General nxn edge wrap
      // But commonly we only have data for either 3x3 (12) or 2x2 (8)
    } else if (n == 3 && c.edgeBand.length >= 4) {
      // Simplified 3x3 side markers
      drawSideSticker(c.edgeBand[0], Rect.fromLTWH(padding + cellSize, padding + innerSize, cellSize, thickness));
      drawSideSticker(c.edgeBand[1], Rect.fromLTWH(padding + innerSize, padding + cellSize, thickness, cellSize));
      drawSideSticker(c.edgeBand[2], Rect.fromLTWH(padding + cellSize, padding - thickness, cellSize, thickness));
      drawSideSticker(c.edgeBand[3], Rect.fromLTWH(padding - thickness, padding + cellSize, thickness, cellSize));
    } else if (n == 2 && c.edgeBand.length >= 8) {
      // 2x2 side markers (8 blocks)
      drawSideSticker(c.edgeBand[0], Rect.fromLTWH(padding, padding + innerSize, cellSize, thickness));
      drawSideSticker(c.edgeBand[1], Rect.fromLTWH(padding + cellSize, padding + innerSize, cellSize, thickness));
      drawSideSticker(c.edgeBand[2], Rect.fromLTWH(padding + innerSize, padding + cellSize, thickness, cellSize));
      drawSideSticker(c.edgeBand[3], Rect.fromLTWH(padding + innerSize, padding, thickness, cellSize));
      drawSideSticker(c.edgeBand[4], Rect.fromLTWH(padding + cellSize, padding - thickness, cellSize, thickness));
      drawSideSticker(c.edgeBand[5], Rect.fromLTWH(padding, padding - thickness, cellSize, thickness));
      drawSideSticker(c.edgeBand[6], Rect.fromLTWH(padding - thickness, padding, thickness, cellSize));
      drawSideSticker(c.edgeBand[7], Rect.fromLTWH(padding - thickness, padding + cellSize, thickness, cellSize));
    }

    for (int row = 0; row < n; row++) {
      for (int col = 0; col < n; col++) {
        int val = _getMappedValue(row, col, n);
        Rect rect = Rect.fromLTWH(padding + col * cellSize, padding + row * cellSize, cellSize, cellSize);
        canvas.drawRect(rect, Paint()..color = _mapValueToColor(val));
        canvas.drawRect(rect, borderPaint);
      }
    }
  }

  int _getMappedValue(int row, int col, int n) {
    if (c.uFaceGrid.isEmpty) return 0;
    if (c.uFaceGrid.length == n && c.uFaceGrid[0].length == n) {
      return c.uFaceGrid[row][col];
    }
    // Reduction logic (3x3 grid for >3x3)
    if (c.uFaceGrid.length == 3) {
      if (row == 0 && col == 0) return c.uFaceGrid[0][0];
      if (row == 0 && col == n - 1) return c.uFaceGrid[0][2];
      if (row == n - 1 && col == 0) return c.uFaceGrid[2][0];
      if (row == n - 1 && col == n - 1) return c.uFaceGrid[2][2];

      if (row == 0) return c.uFaceGrid[0][1];
      if (row == n - 1) return c.uFaceGrid[2][1];
      if (col == 0) return c.uFaceGrid[1][0];
      if (col == n - 1) return c.uFaceGrid[1][2];

      return c.uFaceGrid[1][1];
    }
    return 0;
  }

  void _drawPyraminx(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Paint borderPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final double padding = w * 0.1;
    final double sideLength = w - padding * 2;
    final double height = sideLength * math.sqrt(3) / 2;

    final double startX = padding;
    final double startY = h - (h - height) / 2; // Bottom left corner

    int getFaceletValue(int row, int i) {
      if (c.uFaceGrid.isEmpty || c.uFaceGrid[0].length < 4) return 1;
      // Row 1, i 0 -> Left Edge
      if (row == 1 && i == 0) return c.uFaceGrid[0][0];
      // Row 1, i 2 -> Right Edge
      if (row == 1 && i == 2) return c.uFaceGrid[0][1];
      // Row 0, i 2 -> Bottom Center Edge
      if (row == 0 && i == 2) return c.uFaceGrid[0][2];
      // Row 1, i 1 -> Center (Down). We use it to display the Back Edge for L4E
      if (row == 1 && i == 1) return c.uFaceGrid[0][3];
      return 1; // Corners and other centers default to yellow
    }

    void drawTriangle(Offset p1, Offset p2, Offset p3, int val) {
      final path = Path()
        ..moveTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..lineTo(p3.dx, p3.dy)
        ..close();

      canvas.drawPath(path, Paint()..color = _mapValueToColor(val));
      canvas.drawPath(path, borderPaint);
    }

    final double tSide = sideLength / 3;
    final double tHeight = height / 3;

    for (int row = 0; row < 3; row++) {
      int trianglesInRow = 2 * (3 - row) - 1;
      double rowStartX = startX + (row * tSide / 2);
      double rowStartY = startY - (row * tHeight);

      for (int i = 0; i < trianglesInRow; i++) {
        bool pointUp = i % 2 == 0;
        Offset p1, p2, p3;
        double currentX = rowStartX + (i ~/ 2) * tSide;

        if (pointUp) {
          p1 = Offset(currentX, rowStartY);
          p2 = Offset(currentX + tSide, rowStartY);
          p3 = Offset(currentX + tSide / 2, rowStartY - tHeight);
        } else {
          p1 = Offset(currentX + tSide / 2, rowStartY - tHeight);
          p2 = Offset(currentX + tSide, rowStartY);
          p3 = Offset(currentX + 1.5 * tSide, rowStartY - tHeight);
        }

        drawTriangle(p1, p2, p3, getFaceletValue(row, i));
      }
    }
  }

  void _drawMegaminx(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final center = Offset(w / 2, h / 2);
    final double r1 = w * 0.18; // Inner pentagon radius
    final double r2 = w * 0.38; // Outer edge radius

    final Paint borderPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.0;

    // Center pentagon is always yellow
    final mainPath = Path();
    for (int i = 0; i < 5; i++) {
      double angle = -math.pi / 2 + (i * 2 * math.pi / 5);
      Offset p = Offset(center.dx + r1 * math.cos(angle), center.dy + r1 * math.sin(angle));
      if (i == 0) mainPath.moveTo(p.dx, p.dy);
      else mainPath.lineTo(p.dx, p.dy);
    }
    mainPath.close();
    canvas.drawPath(mainPath, Paint()..color = const Color(0xFFEAB308));
    canvas.drawPath(mainPath, borderPaint);

    // Draw 5 edges (trapezoids) and 5 corners (triangles)
    List<Offset> innerPoints = [];
    List<Offset> outerEdgePoints = [];
    List<Offset> outerCornerPoints = [];

    for (int i = 0; i < 5; i++) {
      double angle = -math.pi / 2 + (i * 2 * math.pi / 5);
      innerPoints.add(Offset(center.dx + r1 * math.cos(angle), center.dy + r1 * math.sin(angle)));
      outerEdgePoints.add(Offset(center.dx + r2 * math.cos(angle), center.dy + r2 * math.sin(angle)));
      
      // Corner points are midway angularly, further out
      double cornerAngle = angle + math.pi / 5;
      double r3 = r2 * 1.15;
      outerCornerPoints.add(Offset(center.dx + r3 * math.cos(cornerAngle), center.dy + r3 * math.sin(cornerAngle)));
    }

    int getEdgeVal(int idx) => (c.uFaceGrid.isNotEmpty && c.uFaceGrid[0].length >= 5) ? c.uFaceGrid[0][idx] : 1;
    int getCornerVal(int idx) => (c.uFaceGrid.length > 1 && c.uFaceGrid[1].length >= 5) ? c.uFaceGrid[1][idx] : 1;

    for (int i = 0; i < 5; i++) {
      int nextM = (i + 1) % 5;
      // Draw Edge (Trapezoid between innerPoints[i], innerPoints[nextM] and outerEdgePoints)
      Path edgePath = Path()
        ..moveTo(innerPoints[i].dx, innerPoints[i].dy)
        ..lineTo(innerPoints[nextM].dx, innerPoints[nextM].dy)
        ..lineTo(outerEdgePoints[nextM].dx, outerEdgePoints[nextM].dy)
        ..lineTo(outerEdgePoints[i].dx, outerEdgePoints[i].dy)
        ..close();
      
      canvas.drawPath(edgePath, Paint()..color = _mapValueToColor(getEdgeVal(i)));
      canvas.drawPath(edgePath, borderPaint);

      // Draw Corner (Triangle pointing outward between outerEdgePoints[i], outerEdgePoints[nextM], and outerCornerPoints[i])
      Path cornerPath = Path()
        ..moveTo(outerEdgePoints[i].dx, outerEdgePoints[i].dy)
        ..lineTo(outerEdgePoints[nextM].dx, outerEdgePoints[nextM].dy)
        ..lineTo(outerCornerPoints[i].dx, outerCornerPoints[i].dy)
        ..close();

      canvas.drawPath(cornerPath, Paint()..color = _mapValueToColor(getCornerVal(i)));
      canvas.drawPath(cornerPath, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PuzzleGridPainter oldDelegate) {
    return oldDelegate.c.id != c.id;
  }
}
