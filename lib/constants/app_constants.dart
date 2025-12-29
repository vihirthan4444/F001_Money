import '../models/category.dart' as app_category;

const String kAppVersion = '1.0.0';
const String kBackendUrl = 'https://web-production-e680c.up.railway.app';

// Default Categories
final List<app_category.Category> kDefaultCategories = [
  app_category.Category(
    id: '1',
    name: 'Food & Dining',
    icon: '🍔',
    color: '#FF6B6B',
    type: 'expense',
  ),
  app_category.Category(
    id: '2',
    name: 'Transportation',
    icon: '🚗',
    color: '#4ECDC4',
    type: 'expense',
  ),
  app_category.Category(
    id: '3',
    name: 'Shopping',
    icon: '🛍️',
    color: '#95E1D3',
    type: 'expense',
  ),
  app_category.Category(
    id: '4',
    name: 'Entertainment',
    icon: '🎬',
    color: '#F38181',
    type: 'expense',
  ),
  app_category.Category(
    id: '5',
    name: 'Bills & Utilities',
    icon: '💡',
    color: '#AA96DA',
    type: 'expense',
  ),
  app_category.Category(
    id: '6',
    name: 'Healthcare',
    icon: '🏥',
    color: '#FCBAD3',
    type: 'expense',
  ),
  app_category.Category(
    id: '7',
    name: 'Education',
    icon: '📚',
    color: '#A8D8EA',
    type: 'expense',
  ),
  app_category.Category(
    id: '8',
    name: 'Salary',
    icon: '💰',
    color: '#77DD77',
    type: 'income',
  ),
  app_category.Category(
    id: '9',
    name: 'Business',
    icon: '💼',
    color: '#84B6F4',
    type: 'income',
  ),
  app_category.Category(
    id: '10',
    name: 'Investments',
    icon: '📈',
    color: '#FDFD96',
    type: 'income',
  ),
  app_category.Category(
    id: '11',
    name: 'Other Income',
    icon: '💵',
    color: '#B19CD9',
    type: 'income',
  ),
  app_category.Category(
    id: '12',
    name: 'Transfer',
    icon: '🔄',
    color: '#C7CEEA',
    type: 'transfer',
  ),
];

// Theme Colors
const Map<String, String> kThemeColors = {
  'Green': '52 199 89',
  'Blue': '0 122 255',
  'Purple': '175 82 222',
  'Pink': '255 45 85',
  'Orange': '255 149 0',
  'Teal': '90 200 250',
};

// Currency Symbols
const List<String> kCurrencies = [
  'Rs',
  '\$',
  '€',
  '£',
  '¥',
  '₹',
];
