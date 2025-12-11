import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/auth_provider.dart';
import 'widgets/auth_form.dart';
import 'signup_page.dart';
import '../../../core/theme/color_schemes.dart' as theme;
import '../../../core/widgets/spacing.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.auto_awesome, size: 28),
                    Gap.wsm,
                    Text(
                      'My Block',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: LinearGradient(
                        colors: [
                          theme.SolarizedSummerColors.summerSea,
                          theme.SolarizedSummerColors.summerSun,
                        ],
                      ),
                    ),
                  ),
                ),
                Gap.md,
                AuthForm(
                  submitLabel: 'Sign In',
                  onSubmit: (email, password, [username]) =>
                      Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      ).signIn(email, password),
                  secondaryLabel: "Don't have an account? Sign Up",
                  onSecondaryAction: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SignupPage()),
                    );
                  },
                ),
                Gap.sm,
                TextButton(
                  onPressed: () async {
                    final emailController = TextEditingController();
                    await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Reset Password'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Gap.sm,
                            TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                hintText: 'Email',
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: const Text('Send'),
                            onPressed: () async {
                              await Provider.of<AuthProvider>(
                                context,
                                listen: false,
                              ).resetPassword(emailController.text.trim());
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
