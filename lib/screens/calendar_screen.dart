import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../providers/data_provider.dart';
import '../providers/theme_provider.dart';
import '../models/transaction.dart' as models;
import 'add_transaction_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = ShadTheme.of(context);
    final currencyFormatter = NumberFormat.currency(symbol: themeProvider.currency, decimalDigits: 0);

    final selectedDayTransactions = _selectedDay != null
        ? dataProvider.transactions.where((t) {
            final transactionDate = DateTime.parse(t.date);
            return transactionDate.year == _selectedDay!.year &&
                transactionDate.month == _selectedDay!.month &&
                transactionDate.day == _selectedDay!.day;
          }).toList()
        : <models.Transaction>[];

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
                    Text(
                      'Calendar',
                      style: theme.textTheme.h2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Track your daily transactions',
                      style: theme.textTheme.muted,
                    ),
                  ],
                ),
              ),
            ),

            // Calendar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ShadCard(
                  padding: const EdgeInsets.all(16),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(
                        color: theme.colorScheme.primaryForeground,
                      ),
                      todayTextStyle: TextStyle(
                        color: theme.colorScheme.foreground,
                      ),
                      defaultTextStyle: TextStyle(
                        color: theme.colorScheme.foreground,
                      ),
                      weekendTextStyle: TextStyle(
                        color: theme.colorScheme.foreground,
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: theme.textTheme.p.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      leftChevronIcon: Icon(
                        LucideIcons.chevronLeft,
                        color: theme.colorScheme.foreground,
                      ),
                      rightChevronIcon: Icon(
                        LucideIcons.chevronRight,
                        color: theme.colorScheme.foreground,
                      ),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: theme.textTheme.muted.copyWith(fontSize: 12),
                      weekendStyle: theme.textTheme.muted.copyWith(fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Transactions Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  _selectedDay != null
                      ? 'Transactions on ${DateFormat('MMM d, yyyy').format(_selectedDay!)}'
                      : 'Select a day',
                  style: theme.textTheme.h4,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Transactions for selected day
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              sliver: selectedDayTransactions.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.inbox,
                                size: 48,
                                color: theme.colorScheme.mutedForeground,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _selectedDay != null
                                    ? 'No transactions on this day'
                                    : 'Select a day to view transactions',
                                style: theme.textTheme.muted,
                              ),
                              if (_selectedDay != null) ...[
                                const SizedBox(height: 16),
                                ShadButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddTransactionScreen(
                                          selectedDate: _selectedDay!,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Add Transaction'),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final transaction = selectedDayTransactions[index];
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
                        childCount: selectedDayTransactions.length,
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
