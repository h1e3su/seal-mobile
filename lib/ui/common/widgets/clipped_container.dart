import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

/// Custom Clipper for Tactical HUD 8px Clipped Corners (Top-Right & Bottom-Left)
class ClippedCornerClipper extends CustomClipper<Path> {
  final double clipSize;

  ClippedCornerClipper({this.clipSize = 8.0});

  @override
  Path getClip(Size size) {
    final path = Path();
    // Start top-left
    path.moveTo(0, 0);
    // Move to top-right cut
    path.lineTo(size.width - clipSize, 0);
    path.lineTo(size.width, clipSize);
    // Move down to bottom-right
    path.lineTo(size.width, size.height);
    // Move to bottom-left cut
    path.lineTo(clipSize, size.height);
    path.lineTo(0, size.height - clipSize);
    // Close back to top-left
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant ClippedCornerClipper oldClipper) => oldClipper.clipSize != clipSize;
}

/// Custom Border Painter for Clipped Corners
class ClippedBorderPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final double clipSize;

  ClippedBorderPainter({
    required this.borderColor,
    this.borderWidth = 1.0,
    this.clipSize = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width - clipSize, 0);
    path.lineTo(size.width, clipSize);
    path.lineTo(size.width, size.height);
    path.lineTo(clipSize, size.height);
    path.lineTo(0, size.height - clipSize);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ClippedBorderPainter oldDelegate) {
    return oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.clipSize != clipSize;
  }
}

/// Tactical HUD Container with 8px Clipped Corners and optional border/glow
class ClippedContainer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double clipSize;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  const ClippedContainer({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.bgPanel,
    this.borderColor = AppColors.borderMuted,
    this.borderWidth = 1.0,
    this.clipSize = 8.0,
    this.padding,
    this.margin,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = ClipPath(
      clipper: ClippedCornerClipper(clipSize: clipSize),
      child: Container(
        width: width,
        height: height,
        color: backgroundColor,
        padding: padding,
        child: child,
      ),
    );

    if (borderColor != null && borderWidth > 0) {
      content = CustomPaint(
        foregroundPainter: ClippedBorderPainter(
          borderColor: borderColor!,
          borderWidth: borderWidth,
          clipSize: clipSize,
        ),
        child: content,
      );
    }

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }
}
