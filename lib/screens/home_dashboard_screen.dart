import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'ai_scan_screen.dart';
import 'growth_tracking_screen.dart';
import 'nutrition_plan_screen.dart';
import 'profile_screen.dart';
import 'role_selection_screen.dart';
import 'main_scaffold.dart';

/// Compatibility wrapper — redirects to MainScaffold.
class HomeDashboardScreen extends StatelessWidget {
  final String childName;

  const HomeDashboardScreen({
    Key? key,
    this.childName = 'Aarav',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(childName: childName, initialIndex: 0);
  }
}

/// Body content for the Home tab — no Scaffold, no bottom nav.
/// Rendered inside MainScaffold.
class HomeDashboardScreenBody extends StatefulWidget {
  final String childName;
  final ValueChanged<int>? onNavRequested;
  final VoidCallback? onScanPressed;

  const HomeDashboardScreenBody({
    Key? key,
    this.childName = 'Aarav',
    this.onNavRequested,
    this.onScanPressed,
  }) : super(key: key);

  @override
  State<HomeDashboardScreenBody> createState() => _HomeDashboardScreenBodyState();
}

class _HomeDashboardScreenBodyState extends State<HomeDashboardScreenBody>
    with SingleTickerProviderStateMixin {
  int _currentCardIndex = 0;
  bool _isDarkMode = false;
  double _dragDx = 0.0;
  late AnimationController _counterController;
  late Animation<double> _counterAnimation;
  Timer? _autoRotateTimer;

  @override
  void initState() {
    super.initState();
    _counterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _counterAnimation = CurvedAnimation(
      parent: _counterController,
      curve: Curves.easeOutCubic,
    );
    _counterController.forward();
    _startAutoRotation();
  }

  void _startAutoRotation() {
    _autoRotateTimer?.cancel();
    _autoRotateTimer = Timer.periodic(const Duration(milliseconds: 3800), (timer) {
      if (mounted) {
        _nextCard();
      }
    });
  }

  void _resetAutoRotation() {
    _autoRotateTimer?.cancel();
    _startAutoRotation();
  }

  @override
  void dispose() {
    _autoRotateTimer?.cancel();
    _counterController.dispose();
    super.dispose();
  }

  void _nextCard() {
    _resetAutoRotation();
    setState(() {
      _currentCardIndex = (_currentCardIndex + 1) % 3;
      _dragDx = 0.0;
    });
    if (_currentCardIndex == 0) {
      _counterController.forward(from: 0.0);
    }
  }

  void _prevCard() {
    _resetAutoRotation();
    setState(() {
      _currentCardIndex = (_currentCardIndex - 1 + 3) % 3;
      _dragDx = 0.0;
    });
    if (_currentCardIndex == 0) {
      _counterController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _isDarkMode ? const Color(0xFF14241B) : const Color(0xFFEAF1E9),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(),
            const SizedBox(height: 8),
            _buildGreeting(),
            const SizedBox(height: 14),
            _buildRotatingCardStack(),
            const SizedBox(height: 12),
            _buildDotsIndicator(),
            const SizedBox(height: 18),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.forestGreen.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.remove_red_eye_rounded,
                  color: AppColors.forestGreen,
                  size: 19,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Home',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _isDarkMode = !_isDarkMode),
                child: Container(
                  width: 44,
                  height: 24,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBE6DB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Align(
                    alignment: _isDarkMode ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2AE196),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isDarkMode ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                        size: 12,
                        color: const Color(0xFF0C2417),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  if (widget.onNavRequested != null) {
                    widget.onNavRequested!(4);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                          childName: widget.childName,
                          onLogout: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                              (route) => false,
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.forestGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.person_rounded, color: Colors.white, size: 17),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good morning, ${widget.childName}',
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${widget.childName} is doing well today.',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRotatingCardStack() {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() => _dragDx += details.delta.dx);
        },
        onHorizontalDragEnd: (details) {
          if (_dragDx < -40) {
            _nextCard();
          } else if (_dragDx > 40) {
            _prevCard();
          } else {
            setState(() => _dragDx = 0.0);
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Card 2 (Back)
            _buildDeckCard((_currentCardIndex + 2) % 3, 2),
            // Card 1 (Mid)
            _buildDeckCard((_currentCardIndex + 1) % 3, 1),
            // Card 0 (Front)
            _buildDeckCard(_currentCardIndex, 0),
          ],
        ),
      ),
    );
  }

  Widget _buildDeckCard(int cardIndex, int offset) {
    final isTop = offset == 0;
    final isSecond = offset == 1;

    final double baseRotation = isTop
        ? (_dragDx * 0.001)
        : (isSecond ? -0.05 : 0.05);
    final double scale = isTop ? 1.0 : (isSecond ? 0.94 : 0.88);
    final double yOffset = isTop ? 0.0 : (isSecond ? -10.0 : -18.0);
    final double xOffset = isTop ? _dragDx : 0.0;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      top: 10 + yOffset,
      left: xOffset,
      right: -xOffset,
      child: Transform.rotate(
        angle: baseRotation,
        child: Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2EAE2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isTop ? 0.08 : 0.04),
                  blurRadius: isTop ? 22 : 12,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: _buildCardContent(cardIndex),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(int index) {
    if (index == 0) {
      return AnimatedBuilder(
        animation: _counterAnimation,
        builder: (context, child) {
          final w = (14.2 * _counterAnimation.value).toStringAsFixed(1);
          final h = (92.5 * _counterAnimation.value).toStringAsFixed(1);
          final m = (14.5 * _counterAnimation.value).toStringAsFixed(1);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Current Vitals',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        icon: const Icon(Icons.sync_rounded, size: 16, color: Color(0xFF5A7263)),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: _nextCard,
                      ),
                    ],
                  ),
                  const Text('Updated 2 days ago', style: TextStyle(fontSize: 11, color: Color(0xFF5A7263))),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _metric('Weight', w, 'kg'),
                  _metric('Height', h, 'cm'),
                  _metric('MUAC', m, 'cm'),
                ],
              ),
            ],
          );
        },
      );
    } else if (index == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F4EA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.assignment_turned_in_rounded, color: Color(0xFF0F3827)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Latest Assessment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text('Analysis indicates healthy milestones.', style: TextStyle(fontSize: 11.5, color: Color(0xFF5A7263))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GrowthTrackingScreen(childName: widget.childName),
                    ),
                  );
                },
                child: const Text(
                  'View full report →',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F3827),
                  ),
                ),
              ),
              const Text('Passed', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF065F46))),
            ],
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('✦ GROWTH STATUS', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF0F3827))),
          const SizedBox(height: 4),
          const Text('Normal Growth', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 2),
          Text('${widget.childName} remains in the healthy percentile.', style: const TextStyle(fontSize: 11.5, color: Color(0xFF5A7263))),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GrowthTrackingScreen(childName: widget.childName),
                ),
              );
            },
            child: const Text(
              'View growth details →',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F3827),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _metric(String l, String v, String u) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(l, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF5A7263))),
      Row(
        children: [
          Text(v, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900, fontFamily: 'monospace')),
          const SizedBox(width: 2),
          Text(u, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
        ],
      ),
    ],
  );

  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final isActive = _currentCardIndex == i;
        return GestureDetector(
          onTap: () => setState(() => _currentCardIndex = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: isActive ? 22 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF0C2417) : const Color(0xFFB8C7BC),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              if (widget.onScanPressed != null) {
                widget.onScanPressed!();
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AiScanScreen(childName: widget.childName),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.forestGreen,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.qr_code_scanner_rounded, size: 20),
                SizedBox(width: 8),
                Text('Start New Scan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {
              if (widget.onNavRequested != null) {
                widget.onNavRequested!(3);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NutritionPlanScreen(childName: widget.childName),
                  ),
                );
              }
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              side: const BorderSide(color: Color(0xFFD3DED3)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.restaurant_menu_rounded, color: Color(0xFF0F3827), size: 20),
                SizedBox(width: 8),
                Text('Nutrition Plan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0C2417))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
