import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../providers/camera_overlay_provider.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/camera_overlay_entity.dart';

class CameraOverlayScreen extends ConsumerStatefulWidget {
  final String? imagePath;
  
  const CameraOverlayScreen({super.key, this.imagePath});

  @override
  ConsumerState<CameraOverlayScreen> createState() => _CameraOverlayScreenState();
}

class _CameraOverlayScreenState extends ConsumerState<CameraOverlayScreen> 
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  String? _errorMessage;
  bool _isInitialized = false; // guard: only run overlay init once

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Guard: only initialize once.
    // didChangeDependencies fires again whenever GoRouterState (or any
    // InheritedWidget) changes — including when a bottom sheet opens/closes.
    // Without this guard, every sheet dismissal resets the overlay to defaults.
    if (_isInitialized) return;
    _isInitialized = true;

    // Read navigation arguments for image path (safe to access context here)
    final args = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final imagePathFromArgs = args?['imagePath'] as String?;

    // Initialize overlay provider and set image path if provided
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        // Initialize the overlay provider first
        await ref.read(cameraOverlayProvider.notifier).init();

        // Then set the overlay if image path is provided
        if (imagePathFromArgs != null) {
          _initializeOverlay(imagePathFromArgs);
        } else if (widget.imagePath != null) {
          _initializeOverlay(widget.imagePath!);
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      // Request camera permission
      final cameraPermission = await Permission.camera.request();
      if (!cameraPermission.isGranted) {
        setState(() {
          _errorMessage = 'Camera permission is required';
        });
        return;
      }

      // Get available cameras
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _errorMessage = 'No cameras available';
        });
        return;
      }

      // Initialize camera controller (use back camera by default)
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _errorMessage = null;
        });
        
        // Initialize overlay if image path is provided
        if (widget.imagePath != null) {
          _initializeOverlay(widget.imagePath!);
        }
      }
    } catch (e) {
      AppLogger.error('Failed to initialize camera', error: e);
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to initialize camera: ${e.toString()}';
        });
      }
    }
  }

  void _initializeOverlay(String imagePath) {
    try {
      final overlay = CameraOverlayEntity.create(
        imagePath: imagePath,
        opacity: 0.7,
        scale: 1.0,
        isVisible: true,
      );
      
      // Update the provider with the new overlay
      ref.read(cameraOverlayProvider.notifier).setOverlay(overlay);
    } catch (e) {
      AppLogger.error('Failed to initialize overlay', error: e);
      setState(() {
        _errorMessage = 'Failed to load overlay image: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final overlayState = ref.watch(cameraOverlayProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.8),
        title: const Text(
          'Camera Overlay',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => context.go(AppRoutes.settings),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera Preview
          if (_isCameraInitialized && _cameraController != null)
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            )
          else
            Positioned.fill(
              child: _buildCameraPlaceholder(),
            ),

          // Overlay Image — wrapped in Consumer for direct, granular updates
          if (_isCameraInitialized)
            Consumer(
              builder: (context, ref, _) {
                final overlay = ref.watch(cameraOverlayProvider).overlay;
                if (overlay == null || !overlay.isVisible) return const SizedBox.shrink();
                return Positioned.fill(
                  child: _buildOverlayImage(overlay),
                );
              },
            ),

          // Control Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildControlPanel(overlayState),
          ),

          // Loading/Error Overlay
          if (overlayState.isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCameraPlaceholder() {
    if (_errorMessage != null) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _initializeCamera,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Initializing camera...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayImage(CameraOverlayEntity overlay) {
    return Transform.translate(
      offset: overlay.position,
      child: Transform.scale(
        scale: overlay.scale,
        child: Transform.rotate(
          angle: overlay.rotation,
          child: Opacity(
            opacity: overlay.opacity,
            child: Image.file(
              File(overlay.imagePath),
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.red.withValues(alpha: 0.3),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image,
                          size: 48,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Overlay image not found',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlPanel(CameraOverlayState overlayState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Overlay Status
          if (overlayState.overlay != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    overlayState.overlay!.isVisible 
                        ? Icons.visibility 
                        : Icons.visibility_off,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Overlay: ${overlayState.overlay!.isVisible ? 'Visible' : 'Hidden'} | Opacity: ${(overlayState.overlay!.opacity * 100).toInt()}% | Scale: ${(overlayState.overlay!.scale * 100).toInt()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Control Buttons
          Row(
            children: [
              // Toggle Visibility
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: overlayState.overlay != null
                      ? () => ref.read(cameraOverlayProvider.notifier).toggleVisibility()
                      : null,
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text('Toggle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Opacity Control
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: overlayState.overlay != null
                      ? () => _showOpacitySlider(overlayState)
                      : null,
                  icon: const Icon(Icons.opacity, size: 18),
                  label: const Text('Opacity'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Scale Control
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: overlayState.overlay != null
                      ? () => _showScaleSlider(overlayState)
                      : null,
                  icon: const Icon(Icons.zoom_in, size: 18),
                  label: const Text('Scale'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showOpacitySlider(CameraOverlayState overlayState) {
    if (overlayState.overlay == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      barrierColor: Colors.black38,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final opacity =
              ref.watch(cameraOverlayProvider).overlay?.opacity ??
              overlayState.overlay!.opacity;

          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Adjust Opacity',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Slider(
                  value: opacity,
                  min: 0.0,
                  max: 1.0,
                  divisions: 100,
                  activeColor: Colors.white,
                  inactiveColor: Colors.white.withValues(alpha: 0.3),
                  onChanged: (value) {
                    ref
                        .read(cameraOverlayProvider.notifier)
                        .updateOpacityInMemory(value);
                  },
                ),
                Text(
                  '${(opacity * 100).toInt()}%',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref
                          .read(cameraOverlayProvider.notifier)
                          .updateOpacity(opacity);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showScaleSlider(CameraOverlayState overlayState) {
    if (overlayState.overlay == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      barrierColor: Colors.black38,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final scale =
              ref.watch(cameraOverlayProvider).overlay?.scale ??
              overlayState.overlay!.scale;

          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Adjust Scale',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Slider(
                  value: scale,
                  min: 0.5,
                  max: 3.0,
                  divisions: 50,
                  activeColor: Colors.white,
                  inactiveColor: Colors.white.withValues(alpha: 0.3),
                  onChanged: (value) {
                    ref
                        .read(cameraOverlayProvider.notifier)
                        .updateScaleInMemory(value);
                  },
                ),
                Text(
                  '${(scale * 100).toInt()}%',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref
                          .read(cameraOverlayProvider.notifier)
                          .updateScale(scale);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
