import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _homeSliderIndexProvider =
    NotifierProvider.autoDispose<_HomeSliderController, int>(
      _HomeSliderController.new,
    );

class _HomeSliderController extends Notifier<int> {
  @override
  int build() => 0;

  void select(int index) {
    if (state != index) state = index;
  }
}

class HomeSlider extends ConsumerWidget {
  const HomeSlider({super.key});

  static const _images = [
    'assets/images/pic1.png',
    'assets/images/pic2.png',
    'assets/images/pic3.jpg',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(_homeSliderIndexProvider);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final aspectRatio = screenWidth >= 700 ? 2.25 : 1.85;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider.builder(
            itemCount: _images.length,
            itemBuilder: (context, index, realIndex) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.asset(
                    _images[index],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            options: CarouselOptions(
              viewportFraction: 1,
              height: double.infinity,
              autoPlay: true,
              enableInfiniteScroll: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 900),
              autoPlayCurve: Curves.easeInOutCubic,
              pauseAutoPlayOnTouch: true,
              scrollDirection: Axis.horizontal,
              reverse: false,
              onPageChanged: (index, reason) {
                ref.read(_homeSliderIndexProvider.notifier).select(index);
              },
            ),
          ),
          Positioned(
            bottom: 13,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_images.length, (index) {
                final selected = index == currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: selected ? 22 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
