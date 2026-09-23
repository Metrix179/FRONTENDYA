import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../theme/app_colors.dart';

class AiScanScreen extends StatefulWidget {
  final String childName;

  const AiScanScreen({
    Key? key,
    this.childName = 'Aarav',
  }) : super(key: key);

  @override
  State<AiScanScreen> createState() => _AiScanScreenState();
}

enum _ScanState { scanner, mascot, result }

class _AiScanScreenState extends State<AiScanScreen>
    with TickerProviderStateMixin {
  _ScanState _state = _ScanState.scanner;
  bool _soundsEnabled = false;
  bool _isScanning = false;
  int _selectedMascotIndex = 2; // Cheetah default

  late AnimationController _laserController;
  late Animation<double> _laserAnimation;

  late AnimationController _spinController;

  late AnimationController _counterController;
  late Animation<double> _counterAnimation;

  CameraController? _cameraController;
  String? _cameraError;
  bool _isCameraReady = false;

  final List<Map<String, dynamic>> _mascots = [
    {'name': 'Albatross', 'subtitle': 'Graceful Ocean Soarer', 'emoji': '🪶'},
    {'name': 'Shark', 'subtitle': 'Swift Friendly Swimmer', 'emoji': '🦈'},
    {'name': 'Cheetah', 'subtitle': 'Lightning Fast Runner', 'emoji': '🐆'},
  ];

  @override
  void initState() {
    super.initState();
    // Laser up and down sweep
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _laserAnimation = CurvedAnimation(
      parent: _laserController,
      curve: Curves.easeInOut,
    );

    // Shutter button spin
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Result counters
    _counterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _counterAnimation = CurvedAnimation(
      parent: _counterController,
      curve: Curves.easeOutCubic,
    );
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw CameraException('NoCamera', 'No camera was found on this device.');
      }

      final preferredCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        preferredCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _cameraController = controller;
        _isCameraReady = true;
        _cameraError = null;
      });
    } on CameraException catch (error) {
      if (!mounted) return;
      setState(() {
        _cameraError = _cameraErrorMessage(error);
        _isCameraReady = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _cameraError = 'Camera access is unavailable. Check browser permissions.';
        _isCameraReady = false;
      });
    }
  }

  String _cameraErrorMessage(CameraException error) {
    switch (error.code) {
      case 'CameraAccessDenied':
      case 'CameraAccessDeniedWithoutPrompt':
        return 'Camera permission was denied. Allow camera access to use AI Scan.';
      case 'CameraAccessRestricted':
        return 'Camera access is restricted on this device.';
      case 'CameraNotFound':
      case 'NoCamera':
        return 'No camera was found on this device.';
      default:
        return error.description ?? 'Camera access is unavailable.';
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _laserController.dispose();
    _spinController.dispose();
    _counterController.dispose();
    super.dispose();
  }

  void _triggerScan() async {
    if (_isScanning) return;
    setState(() => _isScanning = true);
    _spinController.repeat();

    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;
    _spinController.stop();
    setState(() {
      _isScanning = false;
      _state = _ScanState.result;
    });
    _counterController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: _buildBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF0C2417)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const Icon(Icons.remove_red_eye_outlined, color: Color(0xFF0C2417), size: 22),
              const SizedBox(width: 6),
              const Text(
                'Ai Scan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0C2417),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCE7DC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.wb_sunny_outlined, size: 18, color: Color(0xFF0F3827)),
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 17,
                backgroundColor: Color(0xFF0C2417),
                child: Icon(Icons.person_outline, size: 18, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case _ScanState.scanner:
        return _buildScannerView();
      case _ScanState.mascot:
        return _buildMascotView();
      case _ScanState.result:
        return _buildResultView();
    }
  }

  // 1. SCANNER VIEW (00:02 - 00:11 & 00:32 - 00:38)
  Widget _buildScannerView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Growth Scan',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF0C2417)),
                ),
                const SizedBox(height: 2),
                Text(
                  'Position ${widget.childName} inside the guide frame below.',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF556D5E)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Scan Frame Box
          Container(
            width: double.infinity,
            height: 310,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAF8),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: const Color(0xFFD8E6D9), width: 2),
            ),
            child: Stack(
              children: [
                // Live camera preview starts as soon as the scan page opens.
                if (_isCameraReady && _cameraController != null)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _cameraController!.value.previewSize!.height,
                          height: _cameraController!.value.previewSize!.width,
                          child: CameraPreview(_cameraController!),
                        ),
                      ),
                    ),
                  ),

                if (!_isCameraReady)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAF8).withOpacity(0.92),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.videocam_outlined, size: 34, color: Color(0xFF0F3827)),
                              const SizedBox(height: 10),
                              Text(
                                _cameraError ?? 'Starting camera...',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF445B4E)),
                              ),
                              if (_cameraError != null) ...[
                                const SizedBox(height: 12),
                                TextButton.icon(
                                  onPressed: _initializeCamera,
                                  icon: const Icon(Icons.refresh, size: 16),
                                  label: const Text('Try again'),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // Corner Brackets
                Positioned.fill(
                  child: CustomPaint(
                    painter: _CornerBracketPainter(),
                  ),
                ),

                // Dashed child silhouette symbol
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ChildSilhouettePainter(),
                  ),
                ),

                // Animated Laser Line
                AnimatedBuilder(
                  animation: _laserAnimation,
                  builder: (context, child) {
                    final top = 30.0 + _laserAnimation.value * 230.0;
                    return Positioned(
                      top: top,
                      left: 20,
                      right: 20,
                      child: Column(
                        children: [
                          Container(
                            height: 2,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2AE196),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF2AE196).withOpacity(0.8),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // Status pill
                Positioned(
                  bottom: 14,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFA7F3D0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Text(
                            _isScanning ? 'Scanning Biometrics...' : 'Aligning Posture',
                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0C2417)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Row with SOUNDS and Mascot Mode
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _soundsEnabled = !_soundsEnabled),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: _soundsEnabled ? const Color(0xFFECF7ED) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFD8E3D8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _soundsEnabled ? Icons.volume_up : Icons.volume_off,
                              size: 16,
                              color: _soundsEnabled ? const Color(0xFF059669) : const Color(0xFF7D9585),
                            ),
                            const SizedBox(width: 6),
                            const Text('SOUNDS', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800)),
                          ],
                        ),
                        Container(
                          width: 34,
                          height: 20,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: _soundsEnabled ? const Color(0xFF0F3827) : const Color(0xFFCBD8CB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: _soundsEnabled ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _state = _ScanState.mascot),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFD8E3D8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.auto_awesome, size: 16, color: Color(0xFF059669)),
                        SizedBox(width: 6),
                        Text('Mascot Mode', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0C2417))),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Big Shutter Button
          GestureDetector(
            onTap: _triggerScan,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF0F3827),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: _isScanning
                    ? RotationTransition(
                        turns: _spinController,
                        child: const Icon(Icons.sync, color: Color(0xFF2AE196), size: 30),
                      )
                    : const Icon(Icons.camera_alt, color: Colors.white, size: 30),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _isScanning ? 'Processing scan...' : 'Tap shutter to scan',
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF556D5E)),
          ),
        ],
      ),
    );
  }

  // 2. MASCOT MODE (00:12 - 00:31)
  Widget _buildMascotView() {
    final active = _mascots[_selectedMascotIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('INTERACTIVE MODE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF047857), letterSpacing: 1.0)),
          const SizedBox(height: 2),
          Text('Look here, ${widget.childName}!', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: Color(0xFF0C2417))),
          const SizedBox(height: 2),
          Text('Pick a mascot to keep ${widget.childName} focused.', style: const TextStyle(fontSize: 13, color: Color(0xFF556D5E))),
          const SizedBox(height: 16),

          // Stacked cards
          SizedBox(
            height: 210,
            child: Stack(
              children: List.generate(_mascots.length, (i) {
                final isSelected = i == _selectedMascotIndex;
                final offset = (i - _selectedMascotIndex + _mascots.length) % _mascots.length;
                final top = offset * 8.0;
                final scale = 1.0 - offset * 0.05;

                return Positioned(
                  top: top,
                  left: 10 + offset * 4.0,
                  right: 10 + offset * 4.0,
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedMascotIndex = i),
                    child: Transform.scale(
                      scale: scale,
                      child: Container(
                        height: 180,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF10B981) : const Color(0xFFE2EAE2),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_mascots[i]['emoji'], style: const TextStyle(fontSize: 36)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_mascots[i]['name'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0C2417))),
                                    Text(_mascots[i]['subtitle'], style: const TextStyle(fontSize: 12, color: Color(0xFF556D5E))),
                                  ],
                                ),
                                if (isSelected)
                                  const CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Color(0xFF059669),
                                    child: Icon(Icons.check, color: Colors.white, size: 16),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),

          // Black Playing Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0C140F),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white12,
                  child: Text(active['emoji'], style: const TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(active['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                      const Text('Tap cards above to switch animals', style: TextStyle(fontSize: 11, color: Colors.white60)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2AE196).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF2AE196).withOpacity(0.4)),
                  ),
                  child: const Text('PLAYING', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF2AE196))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () => setState(() => _state = _ScanState.scanner),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0C2417),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: Color(0xFFD8E3D8)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.close, size: 16),
                SizedBox(width: 6),
                Text('Exit Distraction Mode', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. RESULT VIEW (00:39 - 00:50)
  Widget _buildResultView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: AnimatedBuilder(
        animation: _counterAnimation,
        builder: (context, child) {
          final p = _counterAnimation.value;
          final weight = (11.0 + (14.2 - 11.0) * p).toStringAsFixed(1);
          final height = (72.9 + (94.5 - 72.9) * p).toStringAsFixed(1);
          final muac = (11.6 + (15.0 - 11.6) * p).toStringAsFixed(1);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: Color(0xFFDCFCE7),
                child: Icon(Icons.check_circle_outline, color: Color(0xFF059669), size: 30),
              ),
              const SizedBox(height: 10),
              Text(
                '${widget.childName} is growing normally',
                style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: Color(0xFF0C2417)),
              ),
              const SizedBox(height: 2),
              const Text('Scan completed today at 10:42 AM', style: TextStyle(fontSize: 12.5, color: Color(0xFF556D5E))),
              const SizedBox(height: 16),

              // Measurements
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFDCE6DC)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('LATEST MEASUREMENTS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF556D5E), letterSpacing: 0.8)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Weight', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF445B4E))),
                        Text('$weight kg', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0C2417))),
                      ],
                    ),
                    const Divider(height: 20, color: Color(0xFFEDF2ED)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Height', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF445B4E))),
                        Text('$height cm', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0C2417))),
                      ],
                    ),
                    const Divider(height: 20, color: Color(0xFFEDF2ED)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('MUAC', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF445B4E))),
                        Row(
                          children: [
                            Text('$muac cm', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0C2417))),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(12)),
                              child: const Text('HEALTHY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF065F46))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Analysis Insights
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFDCE6DC)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ANALYSIS INSIGHTS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF556D5E), letterSpacing: 0.8)),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.childName} is tracking perfectly on standard WHO percentile growth curves. Weight and height are well-proportioned, and upper-arm circumference reflects robust nutritional health.',
                      style: const TextStyle(fontSize: 13, color: Color(0xFF2C3D32), height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.forestGreen,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.restaurant_menu, size: 18),
                    SizedBox(width: 6),
                    Text('View Nutrition Plan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () => setState(() => _state = _ScanState.scanner),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0C2417),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: const BorderSide(color: Color(0xFFD8E3D8)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.refresh, size: 18),
                    SizedBox(width: 6),
                    Text('Scan Again', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CornerBracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2AE196)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const arm = 26.0;
    const pad = 16.0;

    // TL
    canvas.drawLine(const Offset(pad, pad), const Offset(pad + arm, pad), paint);
    canvas.drawLine(const Offset(pad, pad), const Offset(pad, pad + arm), paint);

    // TR
    canvas.drawLine(Offset(size.width - pad, pad), Offset(size.width - pad - arm, pad), paint);
    canvas.drawLine(Offset(size.width - pad, pad), Offset(size.width - pad, pad + arm), paint);

    // BL
    canvas.drawLine(Offset(pad, size.height - pad), Offset(pad + arm, size.height - pad), paint);
    canvas.drawLine(Offset(pad, size.height - pad), Offset(pad, size.height - pad - arm), paint);

    // BR
    canvas.drawLine(Offset(size.width - pad, size.height - pad), Offset(size.width - pad - arm, size.height - pad), paint);
    canvas.drawLine(Offset(size.width - pad, size.height - pad), Offset(size.width - pad, size.height - pad - arm), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ChildSilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF445B4E)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Head oval
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy - 70), width: 50, height: 62),
      paint,
    );

    // Neck & Spine
    canvas.drawLine(Offset(cx, cy - 39), Offset(cx, cy + 40), paint);

    // Torso & Arms
    final bodyPath = Path();
    bodyPath.moveTo(cx - 24, cy - 25);
    bodyPath.cubicTo(cx - 45, cy - 10, cx - 50, cy + 30, cx - 35, cy + 40);
    bodyPath.cubicTo(cx - 20, cy + 40, cx - 18, cy + 10, cx, cy + 6);
    bodyPath.cubicTo(cx + 18, cy + 10, cx + 20, cy + 40, cx + 35, cy + 40);
    bodyPath.cubicTo(cx + 50, cy + 30, cx + 45, cy - 10, cx + 24, cy - 25);
    canvas.drawPath(bodyPath, paint);

    // Legs
    canvas.drawLine(Offset(cx - 16, cy + 40), Offset(cx - 20, cy + 100), paint);
    canvas.drawLine(Offset(cx + 16, cy + 40), Offset(cx + 20, cy + 100), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
