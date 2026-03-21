import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/roast_result.dart';
import '../../main.dart';

class RoastCardStack extends StatefulWidget {
  final List<RoastLine> roastLines;

  const RoastCardStack({super.key, required this.roastLines});

  @override
  State<RoastCardStack> createState() => _RoastCardStackState();
}

class _RoastCardStackState extends State<RoastCardStack> {
  final CardSwiperController _swiperController = CardSwiperController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.roastLines.isEmpty) {
      return const Center(child: Text('No roasts generated'));
    }

    return Column(
      children: [
        Text(
          '${_currentIndex + 1} / ${widget.roastLines.length} roasts',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: CardSwiper(
            controller: _swiperController,
            cardsCount: widget.roastLines.length,
            numberOfCardsDisplayed:
                widget.roastLines.length < 3 ? widget.roastLines.length : 3,
            onSwipe: (prevIndex, currentIndex, direction) {
              setState(() {
                _currentIndex = currentIndex ?? _currentIndex;
              });
              if (direction == CardSwiperDirection.right) {
                final provider = RoastProviderScope.read(context);
                provider.saveRoastLine(widget.roastLines[prevIndex]);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Roast saved!'),
                      duration: Duration(milliseconds: 800),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                }
              }
              return true;
            },
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            cardBuilder: (context, index, percentX, percentY) {
              return _RoastCardItem(roastLine: widget.roastLines[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _RoastCardItem extends StatelessWidget {
  final RoastLine roastLine;

  const _RoastCardItem({required this.roastLine});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                roastLine.emoji,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 16),
              Text(
                '"${roastLine.line}"',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      height: 1.3,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  roastLine.category,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: AppColors.primary, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
