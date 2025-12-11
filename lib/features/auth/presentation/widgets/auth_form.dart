import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/core/widgets/spacing.dart';

import '../../data/auth_provider.dart';

class AuthForm extends StatefulWidget {
  final String submitLabel;
  final void Function(String email, String password, [String? username])
  onSubmit;
  final VoidCallback? onSecondaryAction;
  final String? secondaryLabel;
  final bool showTitle;
  final bool showUsername;

  const AuthForm({
    super.key,
    required this.submitLabel,
    required this.onSubmit,
    this.onSecondaryAction,
    this.secondaryLabel,
    this.showTitle = false,
    this.showUsername = false,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.showTitle)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      widget.submitLabel,
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (widget.showUsername) ...[
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      final v = value?.trim() ?? '';
                      if (!widget.showUsername) return null;
                      if (v.isEmpty) return 'Username is required';
                      if (v.length < 3) return 'Minimum 3 characters';
                      final valid = RegExp(r'^[a-zA-Z0-9_\.]+$').hasMatch(v);
                      if (!valid) return 'Only letters, digits, _ and .';
                      return null;
                    },
                  ),
                  Gap.sm,
                ],
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.alternate_email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return 'Email is required';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                Gap.sm,
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    final v = value ?? '';
                    if (v.isEmpty) return 'Password is required';
                    if (v.length < 6) return 'Minimum 6 characters';
                    return null;
                  },
                ),
                if (auth.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      auth.error!,
                      style: TextStyle(color: theme.colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Gap.md,
                FilledButton(
                  onPressed: auth.isLoading
                      ? null
                      : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final username = widget.showUsername
                                ? _usernameController.text.trim()
                                : null;
                            widget.onSubmit(
                              _emailController.text.trim(),
                              _passwordController.text,
                              username,
                            );
                          }
                        },
                  child: auth.isLoading
                      ? const CircularProgressIndicator()
                      : Text(widget.submitLabel),
                ),
                if (widget.secondaryLabel != null &&
                    widget.onSecondaryAction != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextButton(
                      onPressed: auth.isLoading
                          ? null
                          : widget.onSecondaryAction,
                      child: Text(widget.secondaryLabel!),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
