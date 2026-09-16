import 'dart:ui';
import 'package:adehun_mvp/controllers/wallet_data_controller.dart';
import 'package:adehun_mvp/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_text_styles.dart';
import 'skeletons.dart';

class WalletCard extends ConsumerStatefulWidget {
  final bool showActions;
  final VoidCallback? onFundWallet;
  final VoidCallback? onWithdraw;
  final VoidCallback? onHistory;
  final bool compact;
  final ValueNotifier<bool> balanceVisible;

  const WalletCard({
    super.key,
    this.showActions = true,
    this.onFundWallet,
    this.onWithdraw,
    this.onHistory,
    this.compact = false,
    required this.balanceVisible,
  });

  @override
  ConsumerState<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends ConsumerState<WalletCard> {
  @override
  Widget build(BuildContext context) {
    final walletDataProvider = ref.watch(walletDataControllerProvider);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B4BF9).withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 10),
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Mesh gradient background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/mesh-gradient.png',
                fit: BoxFit.cover,
              ),
            ),

            // Dark overlay for text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withValues(alpha: 0.35),
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.30),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Frosted decorative circle top-right
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            // Smaller decorative circle
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 1,
                  ),
                ),
              ),
            ),

            // Bottom-left decorative element
            Positioned(
              bottom: -20,
              left: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),

            // Card content
            Padding(
              padding: EdgeInsets.all(widget.compact ? 20 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Wallet label with frosted chip
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Iconsax.wallet_3,
                                  color: Colors.white.withValues(alpha: 0.9),
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Wallet Balance',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Visibility toggle
                      GestureDetector(
                        onTap: () => widget.balanceVisible.value =
                            !widget.balanceVisible.value,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15),
                                ),
                              ),
                              child: widget.balanceVisible.sync(
                                builder: (_, value, _) {
                                  return Icon(
                                    value
                                        ? Iconsax.eye_copy
                                        : Iconsax.eye_slash_copy,
                                    color: Colors.white.withValues(alpha: 0.9),
                                    size: 18,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: widget.compact ? 16 : 20),
                  // Balance amount
                  walletDataProvider.when(
                    data: (walletData) {
                      return FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: widget.balanceVisible.sync(
                          builder: (_, value, _) {
                            return Text(
                              value
                                  ? '${walletData.currencySymbol}${_formatAmount(walletData.availableBalance)}'
                                  : '${walletData.currencySymbol}\u2022\u2022\u2022\u2022\u2022\u2022',
                              style: AppTextStyles.amountLarge.copyWith(
                                color: Colors.white,
                                fontSize: widget.compact ? 30 : 34,
                                letterSpacing: 0.5,
                              ),
                            );
                          },
                        ),
                      );
                    },
                    error: (err, stk) => const Icon(Icons.error),
                    loading: () =>
                        WalletBalanceSkeleton(compact: widget.compact),
                  ),
                  if (widget.showActions == true) ...[
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        _ActionChip(
                          icon: Iconsax.add,
                          label: 'Fund',
                          onTap: widget.onFundWallet,
                        ),
                        const SizedBox(width: 10),
                        _ActionChip(
                          icon: Iconsax.arrow_up_2,
                          label: 'Withdraw',
                          onTap: widget.onWithdraw,
                        ),
                        const SizedBox(width: 10),
                        _ActionChip(
                          icon: Iconsax.clock_copy,
                          label: 'History',
                          onTap: widget.onHistory,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionChip({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
