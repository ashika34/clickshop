class SplashModel {
  const SplashModel({this.isAnimating = false, this.isComplete = false});

  final bool isAnimating;
  final bool isComplete;

  SplashModel copyWith({bool? isAnimating, bool? isComplete}) {
    return SplashModel(
      isAnimating: isAnimating ?? this.isAnimating,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
