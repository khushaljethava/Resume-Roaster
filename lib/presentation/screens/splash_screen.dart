import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, a, b) => const HomeScreen(),
            transitionsBuilder: (_, animation, a2, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: Stack(
        children: [
          // Ember particles
          ...List.generate(12, (index) => _EmberParticle(index: index)),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '\u{1F525}',
                  style: const TextStyle(fontSize: 80),
                )
                    .animate(onPlay: (c) => c.repeat())
                    .scale(
                      begin: const Offset(0.9, 0.9),
                      end: const Offset(1.1, 1.1),
                      duration: 800.ms,
                    )
                    .then()
                    .scale(
                      begin: const Offset(1.1, 1.1),
                      end: const Offset(0.9, 0.9),
                      duration: 800.ms,
                    ),
                const SizedBox(height: 24),
                Text(
                  AppStrings.appName,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppColors.primary,
                      ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: 8),
                Text(
                  AppStrings.tagline,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 300.ms)
                    .slideY(begin: 0.3, end: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmberParticle extends StatelessWidget {
  final int index;
  const _EmberParticle({required this.index});

  @override
  Widget build(BuildContext context) {
    final random = Random(index);
    final left = random.nextDouble() * MediaQuery.of(context).size.width;
    final delay = random.nextInt(2000);
    final size = 4.0 + random.nextDouble() * 6;

    return Positioned(
      left: left,
      bottom: 0,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: index.isEven ? AppColors.primary : AppColors.secondary,
          shape: BoxShape.circle,
        ),
      )
          .animate(onPlay: (c) => c.repeat())
          .slideY(
            begin: 0,
            end: -120,
            duration: Duration(milliseconds: 2000 + random.nextInt(1500)),
            delay: Duration(milliseconds: delay),
          )
          .fadeOut(
            duration: Duration(milliseconds: 2000 + random.nextInt(1500)),
            delay: Duration(milliseconds: delay),
          ),
    );
  }
}
