import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/transaction.dart' as app_transaction;
import '../models/ledger.dart';
import '../models/account.dart';
import '../models/budget.dart';
import '../models/category.dart' as app_category;

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}

class ApiService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.statusCode == 204) {
        return {} as T;
      }
      final data = json.decode(response.body);
      return fromJson(data as Map<String, dynamic>);
    } else {
      final errorBody = json.decode(response.body);
      final message = errorBody['message'] ??
          errorBody['error'] ??
          'Request failed with status ${response.statusCode}';
      throw ApiException(message, response.statusCode);
    }
  }

  static Future<List<T>> _handleListResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = json.decode(response.body) as List;
      return data.map((item) => fromJson(item as Map<String, dynamic>)).toList();
    } else {
      final errorBody = json.decode(response.body);
      final message = errorBody['message'] ??
          errorBody['error'] ??
          'Request failed with status ${response.statusCode}';
      throw ApiException(message, response.statusCode);
    }
  }

  // --- AUTHENTICATION ---

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final response = await http.post(
      Uri.parse('$kBackendUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', data['token']);
      return data;
    } else {
      final errorBody = json.decode(response.body);
      throw ApiException(
        errorBody['message'] ?? 'Login failed',
        response.statusCode,
      );
    }
  }

  static Future<Map<String, dynamic>> register(
      String username, String password) async {
    final response = await http.post(
      Uri.parse('$kBackendUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', data['token']);
      return data;
    } else {
      final errorBody = json.decode(response.body);
      throw ApiException(
        errorBody['message'] ?? 'Registration failed',
        response.statusCode,
      );
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user');
  }

  // --- TRANSACTIONS ---

  static Future<List<app_transaction.Transaction>> getTransactions() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$kBackendUrl/transactions'),
      headers: headers,
    );
    return _handleListResponse(response, app_transaction.Transaction.fromJson);
  }

  static Future<app_transaction.Transaction> createTransaction(
      Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$kBackendUrl/transactions'),
      headers: headers,
      body: json.encode(data),
    );
    return _handleResponse(response, app_transaction.Transaction.fromJson);
  }

  static Future<app_transaction.Transaction> updateTransaction(
      String id, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$kBackendUrl/transactions/$id'),
      headers: headers,
      body: json.encode(data),
    );
    return _handleResponse(response, app_transaction.Transaction.fromJson);
  }

  static Future<void> deleteTransaction(String id) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$kBackendUrl/transactions/$id'),
      headers: headers,
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException('Failed to delete transaction', response.statusCode);
    }
  }

  // --- LEDGERS ---

  static Future<List<Ledger>> getLedgers() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$kBackendUrl/ledgers'),
      headers: headers,
    );
    return _handleListResponse(response, Ledger.fromJson);
  }

  static Future<Ledger> createLedger(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$kBackendUrl/ledgers'),
      headers: headers,
      body: json.encode(data),
    );
    return _handleResponse(response, Ledger.fromJson);
  }

  static Future<Ledger> updateLedger(
      String id, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$kBackendUrl/ledgers/$id'),
      headers: headers,
      body: json.encode(data),
    );
    return _handleResponse(response, Ledger.fromJson);
  }

  static Future<void> deleteLedger(String id) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$kBackendUrl/ledgers/$id'),
      headers: headers,
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException('Failed to delete ledger', response.statusCode);
    }
  }

  static Future<Ledger> shareLedger(String ledgerId, String username) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$kBackendUrl/ledgers/$ledgerId/share'),
      headers: headers,
      body: json.encode({'username': username}),
    );
    return _handleResponse(response, Ledger.fromJson);
  }

  static Future<Ledger> unshareLedger(String ledgerId, String username) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$kBackendUrl/ledgers/$ledgerId/share'),
      headers: headers,
      body: json.encode({'username': username}),
    );
    return _handleResponse(response, Ledger.fromJson);
  }

  // --- ACCOUNTS ---

  static Future<List<Account>> getAccounts() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$kBackendUrl/accounts'),
      headers: headers,
    );
    return _handleListResponse(response, Account.fromJson);
  }

  static Future<Account> createAccount(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$kBackendUrl/accounts'),
      headers: headers,
      body: json.encode(data),
    );
    return _handleResponse(response, Account.fromJson);
  }

  static Future<Account> updateAccount(
      String id, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$kBackendUrl/accounts/$id'),
      headers: headers,
      body: json.encode(data),
    );
    return _handleResponse(response, Account.fromJson);
  }

  static Future<void> deleteAccount(String id) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$kBackendUrl/accounts/$id'),
      headers: headers,
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException('Failed to delete account', response.statusCode);
    }
  }

  // --- BUDGETS ---

  static Future<List<Budget>> getBudgets() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$kBackendUrl/budgets'),
      headers: headers,
    );
    return _handleListResponse(response, Budget.fromJson);
  }

  static Future<Budget> createBudget(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$kBackendUrl/budgets'),
      headers: headers,
      body: json.encode(data),
    );
    return _handleResponse(response, Budget.fromJson);
  }

  static Future<Budget> updateBudget(
      String id, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$kBackendUrl/budgets/$id'),
      headers: headers,
      body: json.encode(data),
    );
    return _handleResponse(response, Budget.fromJson);
  }

  static Future<void> deleteBudget(String id) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$kBackendUrl/budgets/$id'),
      headers: headers,
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException('Failed to delete budget', response.statusCode);
    }
  }

  // --- CATEGORIES ---

  static Future<List<app_category.Category>> getCategories() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$kBackendUrl/categories'),
      headers: headers,
    );
    return _handleListResponse(response, app_category.Category.fromJson);
  }

  static Future<List<app_category.Category>> syncCategories(
      List<app_category.Category> categories) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$kBackendUrl/categories/sync'),
      headers: headers,
      body: json.encode({
        'categories': categories.map((c) => c.toJson()).toList(),
      }),
    );
    return _handleListResponse(response, app_category.Category.fromJson);
  }
}
