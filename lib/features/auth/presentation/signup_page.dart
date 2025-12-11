import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/auth_provider.dart';
import 'widgets/auth_form.dart';
import '../../../core/theme/color_schemes.dart' as theme;
import '../../../core/widgets/spacing.dart';
import 'login_page.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

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
                Row(
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
                    horizontal: 84,
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
                  submitLabel: 'Create Account',
                  showTitle: false,
                  showUsername: true,
                  onSubmit: (email, password, [username]) =>
                      Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      ).signUpWithUsername(email, password, username ?? ''),
                  secondaryLabel: 'Already have an account? Sign In',
                  onSecondaryAction: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
