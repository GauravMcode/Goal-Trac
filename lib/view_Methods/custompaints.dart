import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Screens/HomePage.dart';
import 'dart:ui' as ui;

class createSchedulePaint extends CustomPainter {
  createSchedulePaint();
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = colors[0]
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
      ..shader = ui.Gradient.linear(Offset(size.height, size.width), Offset(size.height * 0.5, 0), colors1, [0.25, 0.55, 0.9], TileMode.clamp);

    Path path0 = Path();
    path0.moveTo(0, size.height * 0.0084211);
    path0.quadraticBezierTo(size.width * 0.7860385, size.height * 0.0060526, size.width * 0.9969231, size.height * 0.0052632);
    path0.lineTo(size.width * 0.8453846, size.height * 0.5000000);
    path0.lineTo(size.width * 0.9984615, size.height * 0.9894737);
    path0.lineTo(0, size.height * 0.9921053);
    path0.quadraticBezierTo(0, size.height * 0.7461842, 0, size.height * 0.0084211);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LogoCustomPainter1 extends CustomPainter {
  bool isSmall;
  LogoCustomPainter1(this.isSmall);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = colors[0]
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
      ..shader = isSmall
          ? ui.Gradient.linear(Offset(size.height, size.width), Offset(size.height * 0.5, 0), colors2, [0.25, 0.9], TileMode.clamp)
          : ui.Gradient.linear(Offset(size.height, size.width), Offset(size.height * 0.5, 0), colors1, [0.25, 0.55, 0.9], TileMode.clamp);

    Path path0 = Path();
    path0.moveTo(0, size.height * 0.1666667);
    path0.lineTo(size.width * 0.3725000, 0);
    path0.lineTo(size.width * 0.7468750, size.height * 0.1666667);
    path0.lineTo(size.width * 0.4975000, size.height * 0.3416667);
    path0.lineTo(size.width * 0.4976750, size.height * 0.6720667);
    path0.lineTo(size.width * 0.7475750, size.height * 0.8496667);
    path0.lineTo(size.width * 0.3725000, size.height);
    path0.lineTo(0, size.height * 0.8333333);
    path0.lineTo(0, size.height * 0.1683333);

    canvas.drawPath(path0, paint0);

    // TextSpan span1 = new TextSpan(style: GoogleFonts.pacifico(color: colors[2], fontWeight: FontWeight.normal, fontSize: 30), text: "Schedule\nPlanner");
    // TextPainter tp1 = new TextPainter(text: span1, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    // tp1.layout();
    // tp1.paint(canvas, new Offset(size.width * 0.02, size.width * 0.2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LogoCustomPainter2 extends CustomPainter {
  bool isSmall;
  LogoCustomPainter2(this.isSmall);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint1 = Paint()
      ..color = colors[1]
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
      ..shader = isSmall
          ? ui.Gradient.linear(Offset(size.height, size.width), Offset(size.height * 0.5, 0), colors.sublist(0, 2), [0.25, 0.9], TileMode.clamp)
          : ui.Gradient.linear(Offset(size.height, size.width), Offset(size.height * 0.5, 0), colors1, [0.25, 0.55, 0.9], TileMode.clamp);

    Path path1 = Path();
    path1.moveTo(size.width * 0.5063750, size.height * 0.3455667);
    path1.lineTo(size.width * 0.7461250, size.height * 0.1774000);
    path1.quadraticBezierTo(size.width * 0.9527500, size.height * 0.2941000, size.width * 0.9680000, size.height * 0.5013333);
    path1.quadraticBezierTo(size.width * 0.9577500, size.height * 0.7025000, size.width * 0.7505000, size.height * 0.8424000);
    path1.lineTo(size.width * 0.5094750, size.height * 0.6661000);
    path1.lineTo(size.width * 0.5063750, size.height * 0.3455667);
    path1.close();

    canvas.drawPath(path1, paint1);

    // TextSpan span2 = new TextSpan(style: GoogleFonts.pacifico(color: colors[0], fontStyle: FontStyle.italic, fontSize: 20), text: "Plan\nYour\nDay!");
    // TextPainter tp2 = new TextPainter(text: span2, textAlign: TextAlign.right, textDirection: TextDirection.ltr);
    // tp2.layout();
    // tp2.paint(canvas, new Offset(size.width * 0.65, size.width * 0.2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
