import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

import 'scan_environment_model.dart';
export 'scan_environment_model.dart';

class ScanEnvironmentWidget extends StatefulWidget {
  const ScanEnvironmentWidget({super.key});

  static String routeName = 'ScanEnvironment';
  static String routePath = '/scanEnvironment';

  @override
  State<ScanEnvironmentWidget> createState() => _ScanEnvironmentWidgetState();
}

class _ScanEnvironmentWidgetState extends State<ScanEnvironmentWidget> {
  late ScanEnvironmentModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  CameraController? _cameraController;
  final FlutterTts _flutterTts = FlutterTts();

  Interpreter? _interpreter;
  List<String> _labels = [];

  bool _isCameraReady = false;
  bool _permissionDenied = false;
  bool _isDetecting = false;
  bool _modelLoaded = false;

  String _currentObservation = 'Loading model...';
  String _lastSpokenLabel = '';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ScanEnvironmentModel());
    _initTts();
    _loadModel();
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _interpreter?.close();
    _flutterTts.stop();
    _model.dispose();
    super.dispose();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setVolume(1.0);
  }

  Future<void> _speak(String text) async {
    if (text == _lastSpokenLabel) return;
    _lastSpokenLabel = text;
    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/ssd_mobilenet.tflite',
      );

      final labelsData = await rootBundle.loadString(
        'assets/models/labels.txt',
      );

      _labels = labelsData
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      debugPrint('✅ Model loaded! Labels count: ${_labels.length}');

      if (mounted) {
        setState(() {
          _modelLoaded = true;
          _currentObservation = 'Scanning...';
        });
      }
    } catch (e) {
      debugPrint('❌ Model load error: $e');
      if (mounted) {
        setState(() => _currentObservation = 'Model failed to load: $e');
      }
    }
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      setState(() => _permissionDenied = true);
      return;
    }

    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      backCamera,
      ResolutionPreset.low,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await _cameraController!.initialize();
    if (!mounted) return;

    setState(() => _isCameraReady = true);
    _cameraController!.startImageStream(_processCameraImage);
  }

  // Convert YUV420 to 300x300 RGB input for COCO SSD
  List<List<List<List<int>>>> _prepareInput(CameraImage image) {
    final int width = image.width;
    final int height = image.height;

    final yPlane = image.planes[0];
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];

    final yBytes = yPlane.bytes;
    final uBytes = uPlane.bytes;
    final vBytes = vPlane.bytes;

    final int uvRowStride = uPlane.bytesPerRow;
    final int uvPixelStride = uPlane.bytesPerPixel ?? 1;

    // Build image from YUV
    final rawImg = img.Image(width: width, height: height);
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int yIndex = y * yPlane.bytesPerRow + x;
        final int uvIndex =
            (y ~/ 2) * uvRowStride + (x ~/ 2) * uvPixelStride;

        final int yVal = yBytes[yIndex];
        final int uVal = uBytes[uvIndex];
        final int vVal = vBytes[uvIndex];

        int r = (yVal + 1.402 * (vVal - 128)).round().clamp(0, 255);
        int g = (yVal - 0.344136 * (uVal - 128) - 0.714136 * (vVal - 128))
            .round()
            .clamp(0, 255);
        int b = (yVal + 1.772 * (uVal - 128)).round().clamp(0, 255);

        rawImg.setPixelRgb(x, y, r, g, b);
      }
    }

    // Resize to 300x300
    final resized = img.copyResize(rawImg, width: 300, height: 300);

    // Build [1][300][300][3] input
    return List<List<List<List<int>>>>.generate(
      1,
      (_) => List.generate(
        300,
        (y) => List.generate(
          300,
          (x) {
            final pixel = resized.getPixel(x, y);
            return [
              pixel.r.toInt(),
              pixel.g.toInt(),
              pixel.b.toInt(),
            ];
          },
        ),
      ),
    );
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isDetecting || !_modelLoaded || _interpreter == null) return;
    _isDetecting = true;

    try {
      final input = _prepareInput(image);

      final outputBoxes =
          List.generate(1, (_) => List.generate(10, (_) => List.filled(4, 0.0)));
      final outputClasses =
          List.generate(1, (_) => List.filled(10, 0.0));
      final outputScores =
          List.generate(1, (_) => List.filled(10, 0.0));
      final numDetections = List.filled(1, 0.0);

      final outputs = {
        0: outputBoxes,
        1: outputClasses,
        2: outputScores,
        3: numDetections,
      };

      _interpreter!.runForMultipleInputs([input], outputs);

      final scores = outputScores[0];
      final classes = outputClasses[0];

      // DEBUG — makikita sa terminal
      debugPrint('📊 Scores: $scores');
      debugPrint('🏷️ Classes: $classes');
      debugPrint('🔢 Num detections: $numDetections');

      double bestScore = 0.0;
      int bestIndex = -1;

      for (int i = 0; i < scores.length; i++) {
        if (scores[i] > bestScore) {
          bestScore = scores[i];
          bestIndex = i;
        }
      }

      debugPrint('✅ Best score: $bestScore at index $bestIndex');

      // Temporarily lower threshold to 20% para makita kung may lumalabas
      if (bestIndex >= 0 && bestScore > 0.2) {
        final classIndex = classes[bestIndex].toInt();
        debugPrint('🎯 Class index: $classIndex, Label: ${classIndex < _labels.length ? _labels[classIndex] : "OUT OF RANGE"}');

        if (classIndex >= 0 && classIndex < _labels.length) {
          final label = _labels[classIndex];
          final confidence = (bestScore * 100).toStringAsFixed(0);

          if (label != _lastSpokenLabel) {
            if (mounted) {
              setState(() => _currentObservation = '$label ($confidence%)');
            }
            await _speak('$label in front of you');
          }
        }
      } else {
        debugPrint('⚠️ No confident detection. Best was: $bestScore');
        if (_lastSpokenLabel != '') {
          _lastSpokenLabel = '';
          if (mounted) {
            setState(() => _currentObservation = 'Scanning...');
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Detection error: $e');
    } finally {
      _isDetecting = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF0A1A3F),
      body: _permissionDenied
          ? const Center(
              child: Text(
                'Camera permission denied.\nPlease enable it in Settings.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : !_isCameraReady
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Stack(
                  children: [
                    Positioned.fill(
                      child: CameraPreview(_cameraController!),
                    ),

                    // LIVE badge
                    Positioned(
                      top: 50,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, color: Colors.white, size: 8),
                            SizedBox(width: 6),
                            Text(
                              'LIVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Model status badge — top left
                    Positioned(
                      top: 50,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _modelLoaded
                              ? Colors.green.withOpacity(0.85)
                              : Colors.orange.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _modelLoaded ? 'COCO SSD ✓' : 'Loading...',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),

                    // Bottom panel
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding:
                            const EdgeInsets.fromLTRB(20, 20, 20, 40),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.85),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.visibility,
                                    color: Colors.blueAccent, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'DETECTING',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _currentObservation,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}