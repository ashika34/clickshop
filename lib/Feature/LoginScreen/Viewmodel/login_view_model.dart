import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginViewModelProvider = NotifierProvider<LoginViewModel, LoginState>(
  LoginViewModel.new,
);

class LoginState {
  const LoginState({
    this.email = '',
    this.displayName = 'Shopper',
    this.obscurePassword = true,
    this.isSubmitting = false,
  });

  final String email;
  final String displayName;
  final bool obscurePassword;
  final bool isSubmitting;

  LoginState copyWith({
    String? email,
    String? displayName,
    bool? obscurePassword,
    bool? isSubmitting,
  }) {
    return LoginState(
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class LoginViewModel extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void setSubmitting(bool value) {
    state = state.copyWith(isSubmitting: value);
  }

  void setUserName(String email) {
    final trimmedEmail = email.trim();
    final userName = trimmedEmail.split('@').first.trim();
    if (userName.isEmpty) {
      state = const LoginState();
      return;
    }

    state = LoginState(
      email: trimmedEmail,
      displayName: '${userName[0].toUpperCase()}${userName.substring(1)}',
      obscurePassword: state.obscurePassword,
      isSubmitting: state.isSubmitting,
    );
  }
}
