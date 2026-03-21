import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../main.dart';
import '../../presentation/providers/roast_provider.dart';
import '../widgets/fire_button.dart';
import 'roasting_screen.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = RoastProviderScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Resume'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Go back',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppStrings.uploadTitle,
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.uploadSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Upload area
              _buildUploadArea(context, provider),
              const SizedBox(height: 32),
              // Intensity selector
              _buildIntensitySelector(context, provider),
              const SizedBox(height: 32),
              // Ignite button
              if (provider.selectedFilePath != null)
                FireButton(
                  label: '${AppStrings.ignite} \u{1F525}',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const RoastingScreen()),
                    );
                  },
                  semanticLabel: 'Start roasting resume',
                ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadArea(BuildContext context, RoastProvider provider) {
    final hasFile = provider.selectedFilePath != null;

    return GestureDetector(
      onTap: () => _pickFile(context, provider),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: hasFile ? AppColors.primary : AppColors.textSecondary,
            width: hasFile ? 2 : 1,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          children: [
            Icon(
              hasFile ? Icons.check_circle : Icons.cloud_upload_outlined,
              size: 56,
              color: hasFile ? AppColors.primary : AppColors.textSecondary,
              semanticLabel: hasFile ? 'File selected' : 'Upload file',
            ),
            const SizedBox(height: 16),
            if (hasFile) ...[
              Text(
                provider.selectedFileName ?? '',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                _formatFileSize(provider.selectedFileSize ?? 0),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => _pickFile(context, provider),
                child: const Text('Change file',
                    style: TextStyle(color: AppColors.secondary)),
              ),
            ] else ...[
              Text(
                AppStrings.selectPdf,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'PDF files only',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildIntensitySelector(
      BuildContext context, RoastProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.roastIntensity,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ...RoastIntensity.values.map((intensity) {
          final isSelected = provider.intensity == intensity;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () =>
                  RoastProviderScope.read(context).setIntensity(intensity),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isSelected ? AppColors.primary : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Text(intensity.emoji,
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            intensity.label,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                ),
                          ),
                          Text(
                            intensity.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle,
                          color: AppColors.primary, size: 22),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Future<void> _pickFile(BuildContext context, RoastProvider provider) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      final file = result.files.single;
      provider.setFile(file.path!, file.name, file.size);
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
