import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/card_swap_stack.dart';
import '../widgets/interactive_eye_logo.dart';
import 'ai_scan_screen.dart';
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
  State<HomeDashboardScreenBody> createState() =>
      _HomeDashboardScreenBodyState();
}

class _HomeDashboardScreenBodyState extends State<HomeDashboardScreenBody> {
  int _currentCardIndex = 0;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeTransition(
      isDark: _isDarkMode,
      child: Container(
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
                child: const InteractiveEyeLogo(
                  width: 23,
                  color: AppColors.forestGreen,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Home',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _isDarkMode
                      ? const Color(0xFFE8F2EA)
                      : AppColors.textPrimary,
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
                    alignment: _isDarkMode
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2AE196),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isDarkMode
                            ? Icons.nightlight_round
                            : Icons.wb_sunny_rounded,
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
                              MaterialPageRoute(
                                  builder: (_) => const RoleSelectionScreen()),
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
                  child: const Icon(Icons.person_rounded,
                      color: Colors.white, size: 17),
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
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w900,
              color:
                  _isDarkMode ? const Color(0xFFE8F2EA) : AppColors.textPrimary,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${widget.childName} is doing well today.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _isDarkMode
                  ? const Color(0xFFA9C0B1)
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRotatingCardStack() {
    return Container(
      height: 230,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: CardSwapStack(
        currentIndex: _currentCardIndex,
        onCardChanged: (index) => setState(() => _currentCardIndex = index),
        cardWidth: 320,
        cardHeight: 190,
        cardDistance: 18,
        verticalDistance: 12,
        autoSwapDuration: const Duration(seconds: 4),
        animDuration: const Duration(milliseconds: 850),
        cards: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2E7E1), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1B3D2B),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'GROWTH STATUS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Color(0xFF1B3D2B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Normal Growth',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF173124),
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.childName} remains in the healthy percentile for their age group according to WHO standards.',
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Color(0xFF5A625C),
                  ),
                ),
                const Spacer(),
                const Text(
                  'View growth details →',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF173124),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAF8),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFD6DEC3), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2C5E3B),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'VITALS UPDATE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Color(0xFF2C5E3B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Healthy Weight & Height',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2C5E3B),
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Weight: 12.4 kg | Height: 88 cm. Updated 2 days ago.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Color(0xFF5A625C),
                  ),
                ),
                const Spacer(),
                const Text(
                  'View all vitals →',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C5E3B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF3EB),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFCBD8C7), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF173124),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'ASSESSMENT',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Color(0xFF173124),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Nutrition Milestones',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF173124),
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Analysis indicates optimal protein intake and micro-nutrient balance.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Color(0xFF5A625C),
                  ),
                ),
                const Spacer(),
                const Text(
                  'Download report →',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF173124),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
              color:
                  isActive ? const Color(0xFF0C2417) : const Color(0xFFB8C7BC),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.qr_code_scanner_rounded, size: 20),
                SizedBox(width: 8),
                Text('Start New Scan',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
                    builder: (_) =>
                        NutritionPlanScreen(childName: widget.childName),
                  ),
                );
              }
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              side: const BorderSide(color: Color(0xFFD3DED3)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.restaurant_menu_rounded,
                    color: Color(0xFF0F3827), size: 20),
                SizedBox(width: 8),
                Text('Nutrition Plan',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF0C2417))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
