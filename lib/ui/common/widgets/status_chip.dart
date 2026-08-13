import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

enum StatusChipVariant { success, warning, danger, info, role }

/// Tactical HUD Badge/Chip with low-opacity fill, border, icon, and uppercase text
class StatusChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final StatusChipVariant variant;
  final Color? customColor;
  final double fontSize;

  const StatusChip({
    super.key,
    required this.label,
    this.icon,
    this.variant = StatusChipVariant.info,
    this.customColor,
    this.fontSize = 11.0,
  });

  Color _getColor() {
    if (customColor != null) return customColor!;
    switch (variant) {
      case StatusChipVariant.success:
        return AppColors.statusSuccess;
      case StatusChipVariant.warning:
        return AppColors.statusWarning;
      case StatusChipVariant.danger:
        return AppColors.statusDanger;
      case StatusChipVariant.info:
        return AppColors.primary;
      case StatusChipVariant.role:
        return AppColors.accentTeam;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 2, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
