import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/image_picker_provider.dart';
import '../../domain/entities/image_entity.dart';
import '../../domain/entities/image_source.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routing/app_router.dart';

class ImagePickerScreen extends ConsumerWidget {
  const ImagePickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(imagePickerProvider);
    final notifier = ref.read(imagePickerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.selectImage),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Error Message
              if (state.errorMessage != null) ...[
                _buildErrorCard(context, state.errorMessage!, notifier),
                const SizedBox(height: AppConstants.defaultPadding),
              ],

              // Selected Image Preview
              if (state.selectedImage != null) ...[
                _buildSelectedImageCard(context, state.selectedImage!, notifier),
                const SizedBox(height: AppConstants.defaultPadding),
              ],

              // Image Source Options
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildImageSourceButton(
                        context,
                        title: AppStrings.takePhoto,
                        icon: Icons.camera_alt,
                        onTap: () => _pickImage(ref, ImageSource.camera),
                        isLoading: state.isLoading,
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      _buildImageSourceButton(
                        context,
                        title: AppStrings.chooseFromGallery,
                        icon: Icons.photo_library,
                        onTap: () => _pickImage(ref, ImageSource.gallery),
                        isLoading: state.isLoading,
                      ),
                    ],
                  ),
                ),
              ),

              // Continue Button (only enabled when image is selected)
              if (state.selectedImage != null)
                ElevatedButton(
                  onPressed: state.isLoading ? null : () => _navigateToCameraOverlay(context, ref),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                  child: const Text(
                    AppStrings.continueText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String error, ImagePickerNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppTheme.errorColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppTheme.errorColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: TextStyle(
                color: AppTheme.errorColor,
                fontSize: 14,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: notifier.clearError,
            color: AppTheme.errorColor,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedImageCard(BuildContext context, ImageEntity image, ImagePickerNotifier notifier) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Preview
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppConstants.borderRadius)),
            child: Image.file(
              File(image.path),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: AppTheme.backgroundColor,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 48,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Image Info
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        image.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(image.size / 1024 / 1024).toStringAsFixed(2)} MB',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: notifier.clearSelectedImage,
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSourceButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required bool isLoading,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 80,
        maxHeight: 140,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppTheme.borderColor),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          onTap: isLoading ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: isLoading ? AppTheme.textTertiary : AppTheme.primaryColor,
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isLoading ? AppTheme.textTertiary : AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
                if (isLoading) ...[
                  const SizedBox(height: 6),
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pickImage(WidgetRef ref, ImageSource source) {
    ref.read(imagePickerProvider.notifier).pickImage(source);
  }

  void _navigateToCameraOverlay(BuildContext context, WidgetRef ref) {
    final state = ref.read(imagePickerProvider);
    if (state.selectedImage != null) {
      context.go(AppRoutes.cameraOverlayWithImage(state.selectedImage!.path));
    } else {
      context.go(AppRoutes.cameraOverlay);
    }
  }
}
