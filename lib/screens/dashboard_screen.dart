import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:intl/intl.dart';
import '../providers/data_provider.dart';
import '../providers/theme_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = ShadTheme.of(context);
    final currencyFormatter = NumberFormat.currency(symbol: themeProvider.currency, decimalDigits: 0);

    // Calculate stats
    final totalIncome = dataProvider.transactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
    
    final totalExpense = dataProvider.transactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);
    
    final balance = totalIncome - totalExpense;
    
    final totalAccounts = dataProvider.accounts.length;
    final totalTransactions = dataProvider.transactions.length;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dashboard',
                      style: theme.textTheme.h2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your financial overview',
                      style: theme.textTheme.muted,
                    ),
                  ],
                ),
              ),
            ),

            // Balance Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ShadCard(
                    padding: const EdgeInsets.all(24),
                    backgroundColor: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              LucideIcons.wallet,
                              color: theme.colorScheme.primaryForeground,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Total Balance',
                              style: theme.textTheme.small.copyWith(
                                color: theme.colorScheme.primaryForeground.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          currencyFormatter.format(balance),
                          style: theme.textTheme.h1.copyWith(
                            color: theme.colorScheme.primaryForeground,
                            fontSize: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Stats Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                delegate: SliverChildListDelegate([
                  _StatCard(
                    icon: LucideIcons.trendingUp,
                    label: 'Income',
                    value: currencyFormatter.format(totalIncome),
                    color: Colors.green,
                  ),
                  _StatCard(
                    icon: LucideIcons.trendingDown,
                    label: 'Expenses',
                    value: currencyFormatter.format(totalExpense),
                    color: Colors.red,
                  ),
                  _StatCard(
                    icon: LucideIcons.creditCard,
                    label: 'Accounts',
                    value: totalAccounts.toString(),
                    color: Colors.blue,
                  ),
                  _StatCard(
                    icon: LucideIcons.receipt,
                    label: 'Transactions',
                    value: totalTransactions.toString(),
                    color: Colors.purple,
                  ),
                ]),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Recent Transactions
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Transactions',
                      style: theme.textTheme.h4,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (dataProvider.transactions.isEmpty) {
                      return ShadCard(
                        padding: const EdgeInsets.all(32),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                LucideIcons.inbox,
                                size: 48,
                                color: theme.colorScheme.mutedForeground,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No transactions yet',
                                style: theme.textTheme.muted,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final transaction = dataProvider.transactions.reversed.toList()[index];
                    final category = dataProvider.categories.firstWhere(
                      (c) => c.id == transaction.categoryId,
                      orElse: () => dataProvider.categories.first,
                    );

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ShadCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: category.getDisplayColor().withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _getIconData(category.icon),
                                size: 20,
                                color: category.getDisplayColor(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category.name,
                                    style: theme.textTheme.p.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    transaction.note.isEmpty ? 'No note' : transaction.note,
                                    style: theme.textTheme.muted.copyWith(fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${transaction.type == 'expense' ? '-' : '+'}${currencyFormatter.format(transaction.amount)}',
                              style: theme.textTheme.p.copyWith(
                                fontWeight: FontWeight.bold,
                                color: transaction.type == 'expense' 
                                    ? Colors.red 
                                    : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: dataProvider.transactions.isEmpty ? 1 : (dataProvider.transactions.length > 5 ? 5 : dataProvider.transactions.length),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'shopping_cart':
        return LucideIcons.shoppingCart;
      case 'restaurant':
        return LucideIcons.utensils;
      case 'local_gas_station':
        return LucideIcons.fuel;
      case 'home':
        return LucideIcons.house;
      case 'directions_car':
        return LucideIcons.car;
      case 'flight':
        return LucideIcons.plane;
      case 'medical_services':
        return LucideIcons.heart;
      case 'school':
        return LucideIcons.graduationCap;
      case 'movie':
        return LucideIcons.film;
      case 'attach_money':
        return LucideIcons.dollarSign;
      default:
        return LucideIcons.circle;
    }
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 18,
              color: color,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.muted.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.h4.copyWith(fontSize: 18),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
