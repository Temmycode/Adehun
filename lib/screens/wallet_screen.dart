import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/mock_data.dart';
import '../widgets/wallet_card.dart';
import '../widgets/transaction_tile.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Text('Wallet', style: AppTextStyles.h1),
              ),
            ),

            // Wallet card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: WalletCard(
                  onFundWallet: () => context.push('/fund-wallet'),
                ),
              ),
            ),

            // Transaction history header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 4),
                child: Text('Transaction History', style: AppTextStyles.h3),
              ),
            ),

            // Transaction list
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Column(
                      children: [
                        TransactionTile(
                          transaction: MockData.transactions[index],
                        ),
                        if (index < MockData.transactions.length - 1)
                          const Divider(height: 1),
                      ],
                    );
                  },
                  childCount: MockData.transactions.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
