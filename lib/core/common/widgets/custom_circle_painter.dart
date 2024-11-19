import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCirclePainter extends CustomPainter {
  final String text;
  final TextStyle textStyle;
  final double dashLength;
  final double dashSpace;
  final double dashThickness;
  final Color dashColor;
  final Color thickCircleColor;
  final double dashPaddingFromText;

  CustomCirclePainter({
    required this.text,
    required this.textStyle,
    this.dashLength = 8,
    this.dashSpace = 4,
    this.dashThickness = 3,
    required this.dashColor,
    required this.thickCircleColor,
    this.dashPaddingFromText = 30,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    double textWidth = textPainter.width;
    double textHeight = textPainter.height;

    double padding = dashPaddingFromText.r;

    double radius = (textWidth + (2 * padding)) / 2;

    Offset center = Offset(size.width / 2, size.height / 2);

    Paint paint = Paint()
      ..color = dashColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = dashThickness.r;

    double circumference = 2 * pi * radius;

    drawDashedCircle(canvas, center, radius, circumference, dashLength.r,
        dashSpace.r, paint);

    double radiusNewCircle = radius + 30.r;
    double thickness = 20.r;

    Paint thickCirclePaint = Paint()
      ..color = thickCircleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;

    drawThickCircle(canvas, center, radiusNewCircle, thickCirclePaint);

    textPainter.paint(
      canvas,
      Offset(center.dx - textWidth / 2, center.dy - textHeight / 2),
    );
  }

  void drawDashedCircle(Canvas canvas, Offset center, double radius,
      double circumference, double dashLength, double dashSpace, Paint paint) {
    double startAngle = 0.0;

    while (startAngle < 2 * pi) {
      double endAngle = startAngle + dashLength / radius;
      if (endAngle > 2 * pi) endAngle = 2 * pi;

      Offset start = Offset(center.dx + radius * cos(startAngle),
          center.dy + radius * sin(startAngle));
      Offset end = Offset(center.dx + radius * cos(endAngle),
          center.dy + radius * sin(endAngle));

      canvas.drawLine(start, end, paint);

      startAngle = endAngle + dashSpace / radius;
    }
  }

  void drawThickCircle(
      Canvas canvas, Offset center, double radius, Paint paint) {
    double startAngle = pi / 2 + pi / 8;
    double sweepAngle = 315.0 * (pi / 180);

    Rect rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
