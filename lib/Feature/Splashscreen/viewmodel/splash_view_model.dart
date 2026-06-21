import 'dart:async';

import 'package:click_shop/Feature/Splashscreen/model/splashmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const splashAnimationDuration = Duration(milliseconds: 3500);

final splashViewModelProvider =
    NotifierProvider.autoDispose<SplashViewModel, SplashModel>(
      SplashViewModel.new,
    );

class SplashViewModel extends Notifier<SplashModel> {
  Timer? _timer;

  @override
  SplashModel build() {
    ref.onDispose(() => _timer?.cancel());
    return const SplashModel();
  }

  void startAnimation() {
    if (state.isAnimating || state.isComplete) return;

    state = state.copyWith(isAnimating: true);
    _timer = Timer(splashAnimationDuration, () {
      state = state.copyWith(isAnimating: false, isComplete: true);
    });
  }
}
