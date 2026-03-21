import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../main.dart';
import '../widgets/fire_button.dart';
import 'upload_screen.dart';
import 'results_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = RoastProviderScope.of(context);

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 60),
                // Fire emoji
                const Text('\u{1F525}', style: TextStyle(fontSize: 80))
                    .animate(onPlay: (c) => c.repeat())
                    .scale(
                      begin: const Offset(0.95, 0.95),
                      end: const Offset(1.05, 1.05),
                      duration: 1200.ms,
                    )
                    .then()
                    .scale(
                      begin: const Offset(1.05, 1.05),
                      end: const Offset(0.95, 0.95),
                      duration: 1200.ms,
                    ),
                const SizedBox(height: 24),
                Text(
                  AppStrings.readyToGetRoasted,
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 500.ms),
                const SizedBox(height: 48),
                // Roast My Resume button
                FireButton(
                  label: '\u{1F525} ${AppStrings.roastMyResume}',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const UploadScreen()),
                    );
                  },
                  semanticLabel: 'Roast My Resume',
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 16),
                // How it works button
                OutlinedButton.icon(
                  onPressed: () => _showHowItWorks(context),
                  icon: const Text('\u{2139}\u{FE0F}',
                      style: TextStyle(fontSize: 18)),
                  label: Text(
                    AppStrings.howItWorks,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.textSecondary),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 48),
                // Stats
                Text(
                  '\u{1F4CA} ${AppStrings.resumesRoastedToday}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.textSecondary),
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 24),
                // Hall of Shame teaser
                _buildHallOfShameCard(context)
                    .animate()
                    .fadeIn(delay: 800.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 16),
                // History button
                if (provider.history.isNotEmpty)
                  TextButton.icon(
                    onPressed: () => _showHistory(context, provider),
                    icon: const Icon(Icons.history, color: AppColors.secondary),
                    label: Text(
                      'Roast History (${provider.history.length})',
                      style: const TextStyle(color: AppColors.secondary),
                    ),
                  ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHallOfShameCard(BuildContext context) {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\u{1F3AD} ${AppStrings.hallOfShame}',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.accent),
            ),
            const SizedBox(height: 8),
            ClipRect(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Text(
                  '"Your skills section reads like a random word generator had a seizure on a keyboard"',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Upload your resume to see your own roast!',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.primary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _showHowItWorks(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('How it works',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            _stepTile(context, '1', '\u{1F4C4} Upload',
                'Drop your resume PDF into the app'),
            _stepTile(context, '2', '\u{1F525} Roast',
                'Our AI will savagely critique it'),
            _stepTile(context, '3', '\u{1F4AA} Improve',
                'Get actionable tips to make it better'),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _stepTile(
      BuildContext context, String num, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary,
            child:
                Text(num, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(desc, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showHistory(BuildContext context, dynamic provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('\u{1F525} Roast History',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            ...provider.history.map<Widget>((result) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                    child: Text(
                      '${result.overallScore}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    result.scoreVerdict,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    '${result.timestamp.day}/${result.timestamp.month}/${result.timestamp.year}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ResultsScreen(result: result),
                      ),
                    );
                  },
                )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
