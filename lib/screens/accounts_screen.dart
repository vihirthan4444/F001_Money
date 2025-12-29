import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:intl/intl.dart';
import '../providers/data_provider.dart';
import '../providers/theme_provider.dart';
import '../models/account.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = ShadTheme.of(context);
    final currencyFormatter = NumberFormat.currency(
      symbol: themeProvider.currency,
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Accounts', style: theme.textTheme.h2),
                    const SizedBox(height: 4),
                    Text(
                      'Manage your financial accounts',
                      style: theme.textTheme.muted,
                    ),
                  ],
                ),
              ),
            ),

            // Total Balance Card
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
                              LucideIcons.chartPie,
                              color: theme.colorScheme.primaryForeground,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Total Across All Accounts',
                              style: theme.textTheme.small.copyWith(
                                color: theme.colorScheme.primaryForeground
                                    .withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          currencyFormatter.format(
                            dataProvider.accounts.fold(
                              0.0,
                              (sum, account) => sum + account.balance,
                            ),
                          ),
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

            // Accounts List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              sliver: dataProvider.accounts.isEmpty
                  ? SliverToBoxAdapter(
                      child: ShadCard(
                        padding: const EdgeInsets.all(48),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                LucideIcons.wallet,
                                size: 64,
                                color: theme.colorScheme.mutedForeground,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'No accounts yet',
                                style: theme.textTheme.h4,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Create your first account to get started',
                                style: theme.textTheme.muted,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ShadButton(
                                onPressed: () {
                                  // TODO: Navigate to create account screen
                                },
                                child: const Text('Create Account'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final account = dataProvider.accounts[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ShadCard(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: _getAccountColor(
                                          account.type,
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        _getAccountIcon(account.type),
                                        color: _getAccountColor(account.type),
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            account.name,
                                            style: theme.textTheme.p.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            Account.accountTypeToString(
                                              account.type,
                                            ).toUpperCase(),
                                            style: theme.textTheme.muted
                                                .copyWith(
                                                  fontSize: 12,
                                                  letterSpacing: 0.5,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          currencyFormatter.format(
                                            account.balance,
                                          ),
                                          style: theme.textTheme.p.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }, childCount: dataProvider.accounts.length),
                    ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  IconData _getAccountIcon(AccountType type) {
    switch (type) {
      case AccountType.debit:
        return LucideIcons.landmark;
      case AccountType.cash:
        return LucideIcons.wallet;
      case AccountType.credit:
        return LucideIcons.creditCard;
      case AccountType.loan_given:
      case AccountType.loan_taken:
        return LucideIcons.piggyBank;
    }
  }

  Color _getAccountColor(AccountType type) {
    switch (type) {
      case AccountType.debit:
        return Colors.blue;
      case AccountType.cash:
        return Colors.green;
      case AccountType.credit:
        return Colors.orange;
      case AccountType.loan_given:
        return Colors.purple;
      case AccountType.loan_taken:
        return Colors.red;
    }
  }
}
