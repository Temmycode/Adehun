import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';

class TransactionTile extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = transaction['type'] as String;
    final amount = transaction['amount'] as double;
    final description = transaction['description'] as String;
    final date = transaction['date'] as String;
    final isPositive = amount > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _getIconBgColor(type, colors),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIcon(type),
              color: _getIconColor(type, colors),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: AppTextStyles.labelLarge.copyWith(color: colors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${isPositive ? '+' : ''}\u20A6${_formatAmount(amount.abs())}',
            style: AppTextStyles.labelLarge.copyWith(
              color: isPositive ? AppColors.success : colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'DEPOSIT':
        return Iconsax.arrow_down_2;
      case 'ESCROW_LOCK':
        return Iconsax.lock_copy;
      case 'RECEIVED':
        return Iconsax.arrow_down_2;
      default:
        return Iconsax.arrow_swap_horizontal_copy;
    }
  }

  Color _getIconColor(String type, AppColorScheme colors) {
    switch (type) {
      case 'DEPOSIT':
        return AppColors.success;
      case 'ESCROW_LOCK':
        return AppColors.primary;
      case 'RECEIVED':
        return AppColors.success;
      default:
        return colors.textSecondary;
    }
  }

  Color _getIconBgColor(String type, AppColorScheme colors) {
    switch (type) {
      case 'DEPOSIT':
        return colors.successLight;
      case 'ESCROW_LOCK':
        return colors.primarySurface;
      case 'RECEIVED':
        return colors.successLight;
      default:
        return colors.surfaceVariant;
    }
  }

  String _formatAmount(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final whole = parts[0];
    final decimal = parts[1];
    final buffer = StringBuffer();
    for (var i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(whole[i]);
    }
    return '${buffer.toString()}.$decimal';
  }
}
