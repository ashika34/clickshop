import 'package:click_shop/config/app_route.dart';
import 'package:click_shop/config/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class _LoginUiState {
  const _LoginUiState({this.obscurePassword = true, this.isSubmitting = false});

  final bool obscurePassword;
  final bool isSubmitting;

  _LoginUiState copyWith({bool? obscurePassword, bool? isSubmitting}) {
    return _LoginUiState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

final _loginUiProvider =
    NotifierProvider.autoDispose<_LoginUiController, _LoginUiState>(
      _LoginUiController.new,
    );

class _LoginUiController extends Notifier<_LoginUiState> {
  @override
  _LoginUiState build() => const _LoginUiState();

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void setSubmitting(bool value) {
    state = state.copyWith(isSubmitting: value);
  }
}

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final controller = ref.read(_loginUiProvider.notifier);
    controller.setSubmitting(true);
    await Future<void>.delayed(const Duration(milliseconds: 350));

    if (!mounted) return;
    controller.setSubmitting(false);
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(_loginUiProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final headerHeight = (constraints.maxHeight * 0.34).clamp(
            220.0,
            340.0,
          );
          final horizontalPadding = (constraints.maxWidth * 0.07).clamp(
            20.0,
            48.0,
          );

          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                children: [
                  _GradientHeader(height: headerHeight),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      34,
                      horizontalPadding,
                      32,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: AutofillGroup(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Welcome Back',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: const Color(0xFF202124),
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 32),
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [AutofillHints.email],
                                  decoration: _inputDecoration(
                                    label: 'Email',
                                    icon: Icons.email_outlined,
                                  ),
                                  validator: (value) {
                                    final email = value?.trim() ?? '';
                                    if (email.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!email.contains('@')) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 18),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: loginState.obscurePassword,
                                  textInputAction: TextInputAction.done,
                                  autofillHints: const [AutofillHints.password],
                                  onFieldSubmitted: (_) => _login(),
                                  decoration:
                                      _inputDecoration(
                                        label: 'Password',
                                        icon: Icons.lock_outline_rounded,
                                      ).copyWith(
                                        suffixIcon: IconButton(
                                          tooltip: loginState.obscurePassword
                                              ? 'Show password'
                                              : 'Hide password',
                                          onPressed: ref
                                              .read(_loginUiProvider.notifier)
                                              .togglePasswordVisibility,
                                          icon: Icon(
                                            loginState.obscurePassword
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                          ),
                                        ),
                                      ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 28),
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.lightGreen,
                                        AppColors.darkGreen,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: SizedBox(
                                    height: 56,
                                    child: FilledButton(
                                      onPressed: loginState.isSubmitting
                                          ? null
                                          : _login,
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        disabledBackgroundColor:
                                            Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      child: loginState.isSubmitting
                                          ? const SizedBox.square(
                                              dimension: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Text(
                                              'Login',
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: const Color(0xFFF7F9F7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE1E7E2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE1E7E2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.darkGreen, width: 1.6),
      ),
    );
  }
}

class _GradientHeader extends StatelessWidget {
  const _GradientHeader({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final logoSize = (height * 0.46).clamp(100.0, 145.0);

    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.darkGreen, AppColors.lightGreen],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.elliptical(52, 28),
          bottomRight: Radius.elliptical(52, 28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Center(
          child: Container(
            width: logoSize,
            height: logoSize,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x24000000),
                  blurRadius: 24,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              semanticLabel: 'Click Shop logo',
            ),
          ),
        ),
      ),
    );
  }
}
