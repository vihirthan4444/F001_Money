# Money App - Flutter Frontend

A beautiful, cross-platform money management application built with Flutter. This app provides a comprehensive solution for tracking income, expenses, and transfers across multiple devices.

## Features

### 🎯 Core Features
- **Multi-Platform Support**: Works seamlessly on iOS, Android, Web, Windows, macOS, and Linux
- **User Authentication**: Secure login and registration system
- **Transaction Management**: Create, view, edit, and delete transactions
- **Multiple Ledgers**: Organize transactions into separate ledgers with sharing capabilities
- **Account Management**: Track multiple accounts (cash, debit, credit, loans)
- **Budget Tracking**: Set and monitor budgets by category
- **Category System**: Customizable categories for income and expenses
- **Calendar View**: Visual calendar with daily transaction summaries
- **Dashboard**: Overview of total balance, income, and expenses
- **Dark Mode**: Beautiful dark and light themes

### 💎 Design Features
- Modern, premium UI design
- Smooth animations and transitions
- Responsive layout for all screen sizes
- Material Design 3 components
- Glassmorphic effects
- Color-coded transaction types

## Architecture

The app follows a clean, scalable architecture:

```
lib/
├── models/          # Data models (User, Transaction, Ledger, etc.)
├── services/        # API service for backend communication
├── providers/       # State management with Provider pattern
├── screens/         # UI screens
├── widgets/         # Reusable UI components
├── constants/       # App constants and default data
└── main.dart        # App entry point
```

### State Management
- **Provider Pattern**: Used for global state management
- **AuthProvider**: Manages user authentication state
- **DataProvider**: Manages app data (transactions, ledgers, accounts, etc.)
- **ThemeProvider**: Manages theme settings and preferences

## Backend Integration

The app connects to a FastAPI backend hosted at:
```
https://web-production-e680c.up.railway.app
```

### API Endpoints
- Authentication: `/auth/login`, `/auth/register`
- Transactions: `/transactions` (GET, POST, PUT, DELETE)
- Ledgers: `/ledgers` (GET, POST, PUT, DELETE)
- Accounts: `/accounts` (GET, POST, PUT, DELETE)
- Budgets: `/budgets` (GET, POST, PUT, DELETE)
- Categories: `/categories` (GET, POST)

## Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio with Flutter plugins

### Installation

1. Clone the repository:
```bash
cd F001_Money
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# For mobile (Android/iOS)
flutter run

# For web
flutter run -d chrome

# For desktop
flutter run -d windows  # or macos, linux
```

### Building for Production

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release
```

## Dependencies

### Core Dependencies
- **provider**: State management
- **http**: HTTP requests
- **shared_preferences**: Local storage
- **table_calendar**: Calendar widget
- **intl**: Internationalization and date formatting
- **shimmer**: Loading animations
- **uuid**: UUID generation

## Screens

### 1. Authentication Screen
- Login and registration
- Error handling
- Beautiful gradient background

### 2. Calendar Screen
- Interactive calendar
- Daily transaction list
- Income/expense summary cards
- Add transaction FAB

### 3. Dashboard Screen
- Total balance display
- Income/expense statistics
- App statistics (transactions, ledgers, accounts)

### 4. Accounts Screen
- List of all accounts
- Account type indicators
- Quick account access

### 5. Settings Screen
- User profile
- Dark/light mode toggle
- Currency selection
- App version info
- Logout functionality

### 6. Add Transaction Screen
- Transaction type selection (Income/Expense/Transfer)
- Amount input
- Ledger, category, and account selection
- Date picker
- Notes field

## Responsive Design

The app is fully responsive and adapts to different screen sizes:
- **Mobile**: Optimized for phones (portrait and landscape)
- **Tablet**: Larger layouts with better space utilization
- **Desktop**: Multi-column layouts with sidebar navigation
- **Web**: Responsive web design with max-width constraints

## Theme Customization

Users can customize:
- **Theme Mode**: Light or Dark
- **Primary Color**: Multiple color options
- **Currency**: Various currency symbols (Rs, $, €, £, ¥, ₹)

## Data Models

### User
- id, username, isLoggedIn

### Transaction
- id, ledgerId, amount, type, categoryId, date, note, accountId, toAccountId, userId

### Ledger
- id, name, color, icon, userId, sharedWith

### Account
- id, name, type (cash, debit, credit, loan_given, loan_taken), userId

### Budget
- id, ledgerId, categoryId, amount, userId

### Category
- id, name, icon, color, type (expense, income, both)

## Future Enhancements

- [ ] Offline mode with local database
- [ ] Data export (CSV, PDF)
- [ ] Charts and analytics
- [ ] Recurring transactions
- [ ] Multi-currency support
- [ ] Biometric authentication
- [ ] Push notifications
- [ ] Transaction attachments
- [ ] Advanced filtering and search
- [ ] Budget alerts

## Contributing

This is a private project. For any issues or suggestions, please contact the development team.

## License

Proprietary - All rights reserved

## Version

Current Version: 1.0.0

## Support

For support, please contact the development team or refer to the documentation.
