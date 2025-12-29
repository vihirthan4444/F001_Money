import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegistering = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      return;
    }

    bool success;
    if (_isRegistering) {
      success = await authProvider.register(
        _usernameController.text,
        _passwordController.text,
      );
    } else {
      success = await authProvider.login(
        _usernameController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final theme = ShadTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ShadCard(
              width: 400,
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Icon
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        LucideIcons.trendingUp,
                        size: 32,
                        color: theme.colorScheme.primaryForeground,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    _isRegistering ? 'Create Account' : 'Welcome Back',
                    style: theme.textTheme.h3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Monitor your growth with precision',
                    style: theme.textTheme.muted,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Username Input
                  ShadInput(
                    controller: _usernameController,
                    placeholder: const Text('Username'),
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: Icon(
                        LucideIcons.user,
                        size: 16,
                        color: theme.colorScheme.mutedForeground,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password Input
                  ShadInput(
                    controller: _passwordController,
                    placeholder: const Text('Password'),
                    obscureText: true,
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: Icon(
                        LucideIcons.lock,
                        size: 16,
                        color: theme.colorScheme.mutedForeground,
                      ),
                    ),
                    onSubmitted: (_) => _handleAuth(),
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  ShadButton(
                    onPressed: authProvider.isLoading ? null : _handleAuth,
                    width: double.infinity,
                    child: authProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(_isRegistering ? 'Register' : 'Login'),
                  ),
                  const SizedBox(height: 16),

                  // Toggle Auth Mode
                  Center(
                    child: ShadButton.ghost(
                      onPressed: () {
                        setState(() => _isRegistering = !_isRegistering);
                        authProvider.clearError();
                      },
                      child: Text(
                        _isRegistering
                            ? 'Already have an account? Login'
                            : 'New here? Create account',
                        style: theme.textTheme.muted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
