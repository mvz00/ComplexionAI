import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../app/router.dart';

class CameraCapturePage extends StatefulWidget {
  const CameraCapturePage({super.key});

  @override
  State<CameraCapturePage> createState() => _CameraCapturePageState();
}

class _CameraCapturePageState extends State<CameraCapturePage> {
  final _picker = ImagePicker();
  bool _isLoading = false;
  Uint8List? _previewBytes;

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() => _isLoading = true);
      final XFile? file = await _picker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 90,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (file == null) {
        setState(() => _isLoading = false);
        return;
      }
      final bytes = await file.readAsBytes();
      setState(() {
        _previewBytes = bytes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not access camera: $e')),
        );
      }
    }
  }

  void _confirmAndAnalyse() {
    // TODO: pass _previewBytes through BLoC to analysis pipeline
    context.go(Routes.analysisResult);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => context.pop(),
                  ),
                  const Text(
                    'Skin Scan',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Preview / guide area
            Expanded(
              child: Center(
                child: _previewBytes != null
                    ? _PreviewImage(bytes: _previewBytes!)
                    : _FaceGuide(isLoading: _isLoading),
              ),
            ),

            // Instructions
            if (_previewBytes == null && !_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: Text(
                  'Position your face in good lighting.\nTap the camera button or upload a photo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.5),
                ),
              ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 36, top: 16),
              child: _previewBytes != null
                  ? _ConfirmButtons(
                      onRetake: () => setState(() => _previewBytes = null),
                      onAnalyse: _confirmAndAnalyse,
                    )
                  : _CaptureButtons(
                      isLoading: _isLoading,
                      onCamera: () => _pickImage(ImageSource.camera),
                      onGallery: () => _pickImage(ImageSource.gallery),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaceGuide extends StatelessWidget {
  final bool isLoading;
  const _FaceGuide({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 220,
          height: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(110),
            border: Border.all(color: Colors.white24, width: 2),
          ),
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator(color: Color(0xFFF4A7B9))
                : const Icon(Icons.face, size: 64, color: Colors.white12),
          ),
        ),
        // Corner guides
        ...[ [-1.0, -1.0], [1.0, -1.0], [-1.0, 1.0], [1.0, 1.0]].map((pos) {
          return Positioned(
            left: pos[0] < 0 ? 40 : null,
            right: pos[0] > 0 ? 40 : null,
            top: pos[1] < 0 ? 24 : null,
            bottom: pos[1] > 0 ? 24 : null,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border(
                  left: pos[0] < 0 ? const BorderSide(color: Color(0xFFF4A7B9), width: 2) : BorderSide.none,
                  right: pos[0] > 0 ? const BorderSide(color: Color(0xFFF4A7B9), width: 2) : BorderSide.none,
                  top: pos[1] < 0 ? const BorderSide(color: Color(0xFFF4A7B9), width: 2) : BorderSide.none,
                  bottom: pos[1] > 0 ? const BorderSide(color: Color(0xFFF4A7B9), width: 2) : BorderSide.none,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _PreviewImage extends StatelessWidget {
  final Uint8List bytes;
  const _PreviewImage({required this.bytes});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.memory(
        bytes,
        width: 280,
        height: 340,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _CaptureButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  const _CaptureButtons({
    required this.isLoading,
    required this.onCamera,
    required this.onGallery,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Gallery button
        IconButton(
          onPressed: isLoading ? null : onGallery,
          icon: const Icon(Icons.photo_library_outlined, color: Colors.white54, size: 28),
          tooltip: 'Upload photo',
        ),
        const SizedBox(width: 24),
        // Shutter button
        GestureDetector(
          onTap: isLoading ? null : onCamera,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white70, width: 3),
            ),
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
        // Placeholder for symmetry (front cam flip on mobile)
        const SizedBox(width: 48),
      ],
    );
  }
}

class _ConfirmButtons extends StatelessWidget {
  final VoidCallback onRetake;
  final VoidCallback onAnalyse;
  const _ConfirmButtons({required this.onRetake, required this.onAnalyse});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: onRetake,
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Retake'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white70,
            side: const BorderSide(color: Colors.white30),
          ),
        ),
        const SizedBox(width: 16),
        FilledButton.icon(
          onPressed: onAnalyse,
          icon: const Icon(Icons.auto_awesome, size: 18),
          label: const Text('Analyse Skin'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFF4A7B9),
            foregroundColor: const Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}
