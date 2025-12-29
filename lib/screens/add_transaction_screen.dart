import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:intl/intl.dart';
import '../providers/data_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../models/category.dart' as app_category;
import '../models/account.dart';
import '../models/transaction.dart' as models;
import 'package:uuid/uuid.dart';

class AddTransactionScreen extends StatefulWidget {
  final DateTime selectedDate;

  const AddTransactionScreen({super.key, required this.selectedDate});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedType = 'expense';
  app_category.Category? _selectedCategory;
  Account? _selectedAccount;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    if (_amountController.text.isEmpty || _selectedCategory == null || _selectedAccount == null) {
      return;
    }

    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final transaction = models.Transaction(
      id: const Uuid().v4(),
      ledgerId: dataProvider.ledgers.first.id,
      amount: double.parse(_amountController.text),
      type: _selectedType,
      categoryId: _selectedCategory!.id,
      date: _selectedDate!.toIso8601String(),
      note: _noteController.text,
      accountId: _selectedAccount!.id,
      userId: authProvider.user!.id,
    );

    await dataProvider.createTransaction(transaction.toJson());
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = ShadTheme.of(context);

    final categories = dataProvider.categories.where((c) => c.type == _selectedType).toList();
    
    if (_selectedCategory == null && categories.isNotEmpty) {
      _selectedCategory = categories.first;
    }

    if (_selectedAccount == null && dataProvider.accounts.isNotEmpty) {
      _selectedAccount = dataProvider.accounts.first;
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.x, color: theme.colorScheme.foreground),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Transaction',
          style: theme.textTheme.h3,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Type Selector
              ShadCard(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: _TypeButton(
                        label: 'Expense',
                        icon: LucideIcons.trendingDown,
                        isSelected: _selectedType == 'expense',
                        onTap: () => setState(() {
                          _selectedType = 'expense';
                          _selectedCategory = null;
                        }),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _TypeButton(
                        label: 'Income',
                        icon: LucideIcons.trendingUp,
                        isSelected: _selectedType == 'income',
                        onTap: () => setState(() {
                          _selectedType = 'income';
                          _selectedCategory = null;
                        }),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Amount Input
              Text('Amount', style: theme.textTheme.p.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ShadInput(
                controller: _amountController,
                placeholder: const Text('0.00'),
                keyboardType: TextInputType.number,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8),
                  child: Text(
                    themeProvider.currency,
                    style: theme.textTheme.p.copyWith(
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Category Selector
              Text('Category', style: theme.textTheme.p.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ShadSelect<app_category.Category>(
                placeholder: const Text('Select category'),
                options: categories.map((category) {
                  return ShadOption(
                    value: category,
                    child: Row(
                      children: [
                        Icon(
                          _getIconData(category.icon),
                          size: 16,
                          color: category.getDisplayColor(),
                        ),
                        const SizedBox(width: 8),
                        Text(category.name),
                      ],
                    ),
                  );
                }).toList(),
                selectedOptionBuilder: (context, value) {
                  return Row(
                    children: [
                      Icon(
                        _getIconData(value.icon),
                        size: 16,
                        color: value.getDisplayColor(),
                      ),
                      const SizedBox(width: 8),
                      Text(value.name),
                    ],
                  );
                },
                onChanged: (value) {
                  setState(() => _selectedCategory = value);
                },
              ),

              const SizedBox(height: 20),

              // Account Selector
              Text('Account', style: theme.textTheme.p.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ShadSelect<Account>(
                placeholder: const Text('Select account'),
                options: dataProvider.accounts.map((account) {
                  return ShadOption(
                    value: account,
                    child: Text(account.name),
                  );
                }).toList(),
                selectedOptionBuilder: (context, value) => Text(value.name),
                onChanged: (value) {
                  setState(() => _selectedAccount = value);
                },
              ),

              const SizedBox(height: 20),

              // Date Picker
              Text('Date', style: theme.textTheme.p.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ShadButton.outline(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) {
                    setState(() => _selectedDate = date);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate != null
                          ? DateFormat('MMM d, yyyy').format(_selectedDate!)
                          : 'Select date',
                    ),
                    Icon(LucideIcons.calendar, size: 16),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Note Input
              Text('Note (Optional)', style: theme.textTheme.p.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ShadInput(
                controller: _noteController,
                placeholder: const Text('Add a note...'),
                maxLines: 3,
              ),

              const SizedBox(height: 32),

              // Save Button
              ShadButton(
                onPressed: _saveTransaction,
                width: double.infinity,
                child: const Text('Save Transaction'),
              ),
            ],
          ),
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

class _TypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected 
                  ? theme.colorScheme.primaryForeground 
                  : theme.colorScheme.mutedForeground,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.p.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected 
                    ? theme.colorScheme.primaryForeground 
                    : theme.colorScheme.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
