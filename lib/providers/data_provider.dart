import 'package:flutter/foundation.dart';
import '../models/transaction.dart' as app_transaction;
import '../models/ledger.dart';
import '../models/account.dart';
import '../models/budget.dart';
import '../models/category.dart' as app_category;
import '../services/api_service.dart';
import '../constants/app_constants.dart';

class DataProvider with ChangeNotifier {
  List<app_transaction.Transaction> _transactions = [];
  List<Ledger> _ledgers = [];
  List<Account> _accounts = [];
  List<Budget> _budgets = [];
  List<app_category.Category> _categories = [];
  
  bool _isLoading = false;
  String? _error;

  List<app_transaction.Transaction> get transactions => _transactions;
  List<Ledger> get ledgers => _ledgers;
  List<Account> get accounts => _accounts;
  List<Budget> get budgets => _budgets;
  List<app_category.Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAllData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        ApiService.getTransactions(),
        ApiService.getLedgers(),
        ApiService.getAccounts(),
        ApiService.getBudgets(),
        ApiService.getCategories(),
      ]);

      _transactions = results[0] as List<app_transaction.Transaction>;
      _ledgers = results[1] as List<Ledger>;
      _accounts = results[2] as List<Account>;
      _budgets = results[3] as List<Budget>;
      _categories = results[4] as List<app_category.Category>;
      
      if (_categories.isEmpty) {
        _categories = kDefaultCategories;
      }

      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- TRANSACTIONS ---

  Future<bool> createTransaction(Map<String, dynamic> data) async {
    try {
      final newTransaction = await ApiService.createTransaction(data);
      _transactions.insert(0, newTransaction);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTransaction(String id, Map<String, dynamic> data) async {
    try {
      final updated = await ApiService.updateTransaction(id, data);
      final index = _transactions.indexWhere((t) => t.id == id);
      if (index != -1) {
        _transactions[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTransaction(String id) async {
    try {
      await ApiService.deleteTransaction(id);
      _transactions.removeWhere((t) => t.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // --- LEDGERS ---

  Future<bool> createLedger(Map<String, dynamic> data) async {
    try {
      final newLedger = await ApiService.createLedger(data);
      _ledgers.add(newLedger);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateLedger(String id, Map<String, dynamic> data) async {
    try {
      final updated = await ApiService.updateLedger(id, data);
      final index = _ledgers.indexWhere((l) => l.id == id);
      if (index != -1) {
        _ledgers[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteLedger(String id) async {
    try {
      await ApiService.deleteLedger(id);
      _ledgers.removeWhere((l) => l.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> shareLedger(String ledgerId, String username) async {
    try {
      final updated = await ApiService.shareLedger(ledgerId, username);
      final index = _ledgers.indexWhere((l) => l.id == ledgerId);
      if (index != -1) {
        _ledgers[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> unshareLedger(String ledgerId, String username) async {
    try {
      final updated = await ApiService.unshareLedger(ledgerId, username);
      final index = _ledgers.indexWhere((l) => l.id == ledgerId);
      if (index != -1) {
        _ledgers[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // --- ACCOUNTS ---

  Future<bool> createAccount(Map<String, dynamic> data) async {
    try {
      final newAccount = await ApiService.createAccount(data);
      _accounts.add(newAccount);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateAccount(String id, Map<String, dynamic> data) async {
    try {
      final updated = await ApiService.updateAccount(id, data);
      final index = _accounts.indexWhere((a) => a.id == id);
      if (index != -1) {
        _accounts[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteAccount(String id) async {
    try {
      await ApiService.deleteAccount(id);
      _accounts.removeWhere((a) => a.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // --- BUDGETS ---

  Future<bool> createBudget(Map<String, dynamic> data) async {
    try {
      final newBudget = await ApiService.createBudget(data);
      _budgets.add(newBudget);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateBudget(String id, Map<String, dynamic> data) async {
    try {
      final updated = await ApiService.updateBudget(id, data);
      final index = _budgets.indexWhere((b) => b.id == id);
      if (index != -1) {
        _budgets[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteBudget(String id) async {
    try {
      await ApiService.deleteBudget(id);
      _budgets.removeWhere((b) => b.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // --- CATEGORIES ---

  Future<bool> syncCategories(List<app_category.Category> categories) async {
    try {
      final synced = await ApiService.syncCategories(categories);
      _categories = synced;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
