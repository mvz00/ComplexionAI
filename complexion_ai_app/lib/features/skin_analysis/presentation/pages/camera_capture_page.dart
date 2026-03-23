import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../app/di.dart';
import '../../../../app/router.dart';
import '../bloc/analysis_bloc.dart';
import '../bloc/analysis_event.dart';
import '../bloc/analysis_state.dart';
import '../../domain/entities/analysis_result.dart';

class CameraCapturePage extends StatelessWidget {
  const CameraCapturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AnalysisBloc>(),
      child: const _CameraCaptureView(),
    );
  }
}

class _CameraCaptureView extends StatefulWidget {
  const _CameraCaptureView();

  @override
  State<_CameraCaptureView> createState() => _CameraCaptureViewState();
}

class _CameraCaptureViewState extends State<_CameraCaptureView> {
  final _picker = ImagePicker();
  bool _isPicking = false;
  Uint8List? _previewBytes;
  String? _imagePath;

  Future<void> _pickImage(ImageSource source) async {
    setState(() => _isPicking = true);
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 90,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (!mounted) return;
      if (file == null) {
        setState(() => _isPicking = false);
        return;
      }
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() {
        _previewBytes = bytes;
        _imagePath = file.path;
        _isPicking = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isPicking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _submitAnalysis() {
    final path = _imagePath;
    if (path == null) return;
    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
    context.read<AnalysisBloc>().add(
          AnalysisCaptureRequested(imagePath: path, userId: userId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AnalysisBloc, AnalysisState>(
      listener: (context, state) {
        if (state is AnalysisComplete) {
          context.go(Routes.analysisResult, extra: state.result);
        } else if (state is AnalysisError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      },
      child: BlocBuilder<AnalysisBloc, AnalysisState>(
        builder: (context, state) {
          final isProcessing = state is AnalysisProcessing;
          final isLoading = _isPicking || isProcessing;

          return Scaffold(
            backgroundColor: const Color(0xFF111111),
            body: SafeArea(
              child: Column(
                children: [
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70),
                          onPressed: isProcessing ? null : () => context.pop(),
                        ),
                        const Expanded(
                          child: Text(
                            'Skin Scan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  // Preview area
                  Expanded(
                    child: Center(
                      child: isLoading
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(
                                  color: Color(0xFFF4A7B9),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  isProcessing ? 'Analysing skin...' : 'Loading...',
                                  style: const TextStyle(color: Colors.white54),
                                ),
                              ],
                            )
                          : _previewBytes != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.memory(
                                    _previewBytes!,
                                    width: 260,
                                    height: 320,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 220,
                                      height: 280,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(110),
                                        border: Border.all(
                                          color: const Color(0xFFF4A7B9),
                                          width: 2,
                                        ),
                                      ),
                                      child: const Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.face_retouching_natural,
                                            size: 56,
                                            color: Color(0x66F4A7B9),
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            'Align your face here',
                                            style: TextStyle(
                                              color: Color(0x99F4A7B9),
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      'Use good, even lighting for best results',
                                      style: TextStyle(
                                        color: Colors.white38,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                    ),
                  ),

                  // Buttons
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                    child: _previewBytes != null
                        ? Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: isProcessing
                                      ? null
                                      : () => setState(() {
                                            _previewBytes = null;
                                            _imagePath = null;
                                          }),
                                  icon: const Icon(Icons.refresh, size: 18),
                                  label: const Text('Retake'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white70,
                                    side: const BorderSide(color: Colors.white30),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: isProcessing ? null : _submitAnalysis,
                                  icon: const Icon(Icons.auto_awesome, size: 18),
                                  label: const Text('Analyse Skin'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFFF4A7B9),
                                    foregroundColor: const Color(0xFF1A1A2E),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _CircleButton(
                                icon: Icons.photo_library_outlined,
                                label: 'Gallery',
                                onTap: isLoading ? null : () => _pickImage(ImageSource.gallery),
                              ),
                              const SizedBox(width: 32),
                              GestureDetector(
                                onTap: isLoading ? null : () => _pickImage(ImageSource.camera),
                                child: Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white70, width: 3),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 32),
                              const SizedBox(width: 64),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _CircleButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white12,
              border: Border.all(color: Colors.white24),
            ),
            child: Icon(icon, color: Colors.white70, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
