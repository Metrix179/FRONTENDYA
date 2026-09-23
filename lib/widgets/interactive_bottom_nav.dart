import 'package:flutter/material.dart';

class InteractiveBottomNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onScanPressed;

  const InteractiveBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onScanPressed,
  }) : super(key: key);

  @override
  State<InteractiveBottomNav> createState() => _InteractiveBottomNavState();
}

class _InteractiveBottomNavState extends State<InteractiveBottomNav> {
  int? _elevatedIndex;

  final List<String> _labels = ['Home', 'Growth', 'Scan', 'Nutrition', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 14, right: 14, top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0C2417),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(0, Icons.home_rounded),
          _buildNavItem(1, Icons.trending_up_rounded),
          _buildScanButton(),
          _buildNavItem(3, Icons.restaurant_menu_rounded),
          _buildNavItem(4, Icons.person_rounded),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final isSelected = widget.currentIndex == index;
    final isElevated = _elevatedIndex == index;

    return GestureDetector(
      onTapDown: (_) => setState(() => _elevatedIndex = index),
      onTapUp: (_) {
        setState(() => _elevatedIndex = null);
        widget.onTabSelected(index);
      },
      onTapCancel: () => setState(() => _elevatedIndex = null),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Floating elevated bubble (seen in video at 00:21-00:26)
          if (isElevated)
            Positioned(
              top: -36,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: 1.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A1E13),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF2AE196).withOpacity(0.4)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 16, color: const Color(0xFF2AE196)),
                      Text(
                        _labels[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Base nav item
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutBack,
            transform: Matrix4.identity()
              ..scale(isElevated ? 0.9 : (isSelected ? 1.05 : 1.0)),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white.withOpacity(0.12) : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                  size: 23,
                ),
                const SizedBox(height: 3),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isSelected ? 5 : 0,
                  height: isSelected ? 5 : 0,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2AE196),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanButton() {
    return GestureDetector(
      onTap: widget.onScanPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: const Color(0xFF2AE196),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2AE196).withOpacity(0.45),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.qr_code_scanner_rounded,
          color: Color(0xFF0A2014),
          size: 25,
        ),
      ),
    );
  }
}
