import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../main.dart';
import 'results_screen.dart';

class RoastingScreen extends StatefulWidget {
  const RoastingScreen({super.key});

  @override
  State<RoastingScreen> createState() => _RoastingScreenState();
}

class _RoastingScreenState extends State<RoastingScreen> {
  int _messageIndex = 0;
  double _progress = 0.0;
  Timer? _messageTimer;
  Timer? _progressTimer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _startLoadingAnimation();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startRoasting());
  }

  void _startLoadingAnimation() {
    // Cycle through loading messages
    _messageTimer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      if (mounted) {
        setState(() {
          _messageIndex =
              (_messageIndex + 1) % AppStrings.loadingMessages.length;
        });
      }
    });

    // Progress bar animation (fills over ~8 seconds)
    _progressTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          _progress += 0.0125; // ~8 seconds to fill
          if (_progress > 0.95) _progress = 0.95; // Cap at 95% until done
        });
      }
    });
  }

  Future<void> _startRoasting() async {
    final provider = RoastProviderScope.read(context);
    await provider.startRoasting();

    if (!mounted || _navigated) return;
    _navigated = true;

    setState(() => _progress = 1.0);

    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    if (provider.errorMessage != null) {
      _showError(provider.errorMessage!);
    } else if (provider.result != null) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, a, b) =>
              ResultsScreen(result: provider.result!),
          transitionsBuilder: (_, animation, a2, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '\u{1F480} Roast Failed',
          style: TextStyle(color: AppColors.primary),
        ),
        content: Text(
          message,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // dialog
              Navigator.of(context).pop(); // back to upload
            },
            child: const Text('Try Again',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, AppColors.homeGradientEnd],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Fire animation
                  const Text('\u{1F525}', style: TextStyle(fontSize: 100))
                      .animate(onPlay: (c) => c.repeat())
                      .scale(
                        begin: const Offset(0.85, 0.85),
                        end: const Offset(1.15, 1.15),
                        duration: 600.ms,
                      )
                      .then()
                      .scale(
                        begin: const Offset(1.15, 1.15),
                        end: const Offset(0.85, 0.85),
                        duration: 600.ms,
                      )
                      .shimmer(
                        duration: 1200.ms,
                        color: AppColors.accent.withValues(alpha: 0.3),
                      ),
                  const SizedBox(height: 40),
                  // Loading message
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: Text(
                      AppStrings.loadingMessages[_messageIndex],
                      key: ValueKey(_messageIndex),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: AppColors.accent),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 8,
                      backgroundColor:
                          AppColors.textSecondary.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.lerp(
                            AppColors.primary, AppColors.accent, _progress)!,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${(_progress * 100).toInt()}%',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.textSecondary),
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
