import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/drawing_controls_provider.dart';
import '../../domain/entities/drawing_tool_entity.dart';
import '../../domain/entities/drawing_settings_entity.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

class DrawingControlsScreen extends ConsumerWidget {
  const DrawingControlsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(drawingControlsProvider);
    final notifier = ref.read(drawingControlsProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        title: const Text(
          'Drawing Controls',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            )
          : Column(
              children: [
                // Error Message
                if (state.errorMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    margin: const EdgeInsets.all(AppConstants.defaultPadding),
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
                            state.errorMessage!,
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
                  ),
                ],

                // Drawing Tools Section
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Drawing Tools',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Tools Grid
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.0,
                          ),
                          itemCount: state.drawingTools.length,
                          itemBuilder: (context, index) {
                            final tool = state.drawingTools[index];
                            return _buildToolCard(context, tool, notifier, state.selectedTool);
                          },
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Settings Section
                        const Text(
                          'Drawing Settings',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        _buildSettingsCard(context, state.settings, notifier),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildToolCard(
    BuildContext context,
    DrawingToolEntity tool,
    dynamic notifier,
    DrawingToolEntity? selectedTool,
  ) {
    final isSelected = selectedTool?.id == tool.id;
    
    return GestureDetector(
      onTap: () => notifier.selectTool(tool.id),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowColor,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getToolIcon(tool.type),
              size: 32,
              color: isSelected ? Colors.white : AppTheme.textPrimary,
            ),
            const SizedBox(height: 8),
            Text(
              tool.name ?? tool.type.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Container(
              width: 20,
              height: 3,
              decoration: BoxDecoration(
                color: tool.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context,
    DrawingSettingsEntity settings,
    dynamic notifier,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          // Grid Settings
          _buildSettingToggle(
            title: 'Show Grid',
            value: settings.showGrid,
            onChanged: (value) => notifier.updateSettings(
              settings.copyWith(showGrid: value),
            ),
          ),
          
          if (settings.showGrid) ...[
            const SizedBox(height: 12),
            _buildSettingSlider(
              title: 'Grid Opacity',
              value: settings.gridOpacity,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              onChanged: (value) => notifier.updateSettings(
                settings.copyWith(gridOpacity: value),
              ),
            ),
          ],
          
          const Divider(height: 24),
          
          // Ruler Settings
          _buildSettingToggle(
            title: 'Show Ruler',
            value: settings.showRuler,
            onChanged: (value) => notifier.updateSettings(
              settings.copyWith(showRuler: value),
            ),
          ),
          
          const Divider(height: 24),
          
          // Smoothing Settings
          _buildSettingToggle(
            title: 'Enable Smoothing',
            value: settings.enableSmoothing,
            onChanged: (value) => notifier.updateSettings(
              settings.copyWith(enableSmoothing: value),
            ),
          ),
          
          if (settings.enableSmoothing) ...[
            const SizedBox(height: 12),
            _buildSettingSlider(
              title: 'Smoothing Level',
              value: settings.smoothingLevel,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              onChanged: (value) => notifier.updateSettings(
                settings.copyWith(smoothingLevel: value),
              ),
            ),
          ],
          
          const Divider(height: 24),
          
          // Auto-save Settings
          _buildSettingToggle(
            title: 'Auto-save',
            value: settings.autoSave,
            onChanged: (value) => notifier.updateSettings(
              settings.copyWith(autoSave: value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingToggle({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.textPrimary,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.primaryColor,
        ),
      ],
    );
  }

  Widget _buildSettingSlider({
    required String title,
    required double value,
    required double min,
    required double max,
    int? divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: AppTheme.primaryColor,
          inactiveColor: AppTheme.borderColor,
          onChanged: onChanged,
        ),
      ],
    );
  }

  IconData _getToolIcon(DrawingToolType type) {
    switch (type) {
      case DrawingToolType.pen:
        return Icons.edit;
      case DrawingToolType.brush:
        return Icons.brush;
      case DrawingToolType.eraser:
        return Icons.cleaning_services;
      case DrawingToolType.line:
        return Icons.horizontal_rule;
      case DrawingToolType.rectangle:
        return Icons.crop_square;
      case DrawingToolType.circle:
        return Icons.radio_button_unchecked;
      case DrawingToolType.text:
        return Icons.text_fields;
    }
  }
}
