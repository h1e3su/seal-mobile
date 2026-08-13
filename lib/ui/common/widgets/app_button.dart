import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import 'clipped_container.dart';

enum AppButtonVariant { primary, secondary, ghost, danger }

/// Tactical HUD Cyber Button (48px height, 8px clipped corners, press animation)
class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isEnabled;
  final double height;
  final double? width;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isEnabled = true,
    this.height = 48.0,
    this.width,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    if (widget.onPressed == null || widget.isLoading || !widget.isEnabled) {
      return AppColors.bgInput;
    }
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return AppColors.primary;
      case AppButtonVariant.secondary:
        return AppColors.bgPanel;
      case AppButtonVariant.ghost:
        return Colors.transparent;
      case AppButtonVariant.danger:
        return AppColors.statusDanger;
    }
  }

  Color _getTextColor() {
    if (widget.onPressed == null || widget.isLoading || !widget.isEnabled) {
      return AppColors.textMuted;
    }
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return AppColors.onPrimary;
      case AppButtonVariant.secondary:
        return AppColors.primary;
      case AppButtonVariant.ghost:
        return AppColors.primary;
      case AppButtonVariant.danger:
        return Colors.white;
    }
  }

  Color _getBorderColor() {
    if (widget.onPressed == null || widget.isLoading || !widget.isEnabled) {
      return AppColors.borderMuted;
    }
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return AppColors.primary;
      case AppButtonVariant.secondary:
        return AppColors.primary;
      case AppButtonVariant.ghost:
        return AppColors.borderMuted;
      case AppButtonVariant.danger:
        return AppColors.statusDanger;
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.onPressed != null && !widget.isLoading && widget.isEnabled;

    return GestureDetector(
      onTapDown: active ? (_) => _animController.forward() : null,
      onTapUp: active
          ? (_) {
              _animController.reverse();
              widget.onPressed!();
            }
          : null,
      onTapCancel: active ? () => _animController.reverse() : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: widget.width ?? double.infinity,
          height: widget.height,
          child: ClippedContainer(
            clipSize: 8.0,
            backgroundColor: _getBackgroundColor(),
            borderColor: _getBorderColor(),
            borderWidth: 1.0,
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, size: 18, color: _getTextColor()),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.label.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: _getTextColor(),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
