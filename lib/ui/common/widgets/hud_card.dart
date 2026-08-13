import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import 'clipped_container.dart';

/// Tactical HUD Card with 8px Clipped Corners & 4px Left-Side Role Accent Bar
class HudCard extends StatelessWidget {
  final Widget child;
  final Color? accentBarColor;
  final Color backgroundColor;
  final Color borderColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const HudCard({
    super.key,
    required this.child,
    this.accentBarColor,
    this.backgroundColor = AppColors.bgPanel,
    this.borderColor = AppColors.borderMuted,
    this.padding = const EdgeInsets.all(14.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (accentBarColor != null)
          Container(
            width: 4,
            color: accentBarColor,
          ),
        Expanded(
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ],
    );

    Widget result = IntrinsicHeight(
      child: ClippedContainer(
        clipSize: 8.0,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        borderWidth: 1.0,
        child: cardContent,
      ),
    );

    if (margin != null) {
      result = Padding(padding: margin!, child: result);
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: result,
      );
    }

    return result;
  }
}
