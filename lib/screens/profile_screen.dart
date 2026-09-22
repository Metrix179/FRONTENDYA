import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  final String childName;
  final VoidCallback? onLogout;

  const ProfileScreen({
    Key? key,
    this.childName = 'Aarav',
    this.onLogout,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDarkMode = false;
  bool _isHistoryView = false;
  int _historyMetricIndex = 0;

  String _childName = 'Aarav';
  String _age = '2 years, 3 months';
  String _gender = 'Boy';
  String _status = 'On Track';
  String _parentName = 'Sarah & Leo';
  String _accountType = 'Premium Account';

  @override
  void initState() {
    super.initState();
    _childName = widget.childName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF3ED),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                child: _isHistoryView ? _buildHistoryView() : _buildProfileView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF0C2417)),
                onPressed: () {
                  if (_isHistoryView) {
                    setState(() => _isHistoryView = false);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
              const Icon(Icons.remove_red_eye_outlined, color: Color(0xFF0C2417), size: 22),
              const SizedBox(width: 6),
              Text(
                _isHistoryView ? 'Child History' : 'Child Profile',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0C2417),
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _isDarkMode = !_isDarkMode),
                child: Container(
                  width: 54,
                  height: 28,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDFE8DF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFCEDECE)),
                  ),
                  child: Row(
                    mainAxisAlignment: _isDarkMode
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: _isDarkMode
                              ? const Color(0xFF0F3827)
                              : const Color(0xFF2AE196),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                          size: 13,
                          color: _isDarkMode ? Colors.white : const Color(0xFF0C2417),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFF0C2417),
                child: Icon(Icons.person_outline, size: 16, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AARAV'S PROFILE
        Text(
          "${_childName.toUpperCase()}'S\nPROFILE",
          style: const TextStyle(
            fontSize: 44,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0C2417),
            height: 0.94,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 12),

        // CHILD HISTORY
        GestureDetector(
          onTap: () => setState(() => _isHistoryView = true),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: Color(0xFFD8E3D8)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'CHILD HISTORY',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF556D5E),
                    letterSpacing: 1.2,
                  ),
                ),
                Row(
                  children: [
                    Text('01—05', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF556D5E))),
                    Icon(Icons.chevron_right, size: 18, color: Color(0xFF556D5E)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 01 CHILD PROFILE
        _buildSectionHeader('01 CHILD PROFILE'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE2EAE2)),
          ),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F7F4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFD8E3D8), style: BorderStyle.solid),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_photo_alternate_outlined, size: 28, color: Color(0xFF556D5E)),
                    SizedBox(height: 4),
                    Text('NO PHOTO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF556D5E), letterSpacing: 0.8)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_childName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF0C2417))),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          onPressed: _showEditChildModal,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    _infoRow('AGE', _age),
                    const SizedBox(height: 3),
                    _infoRow('GENDER', _gender),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('STATUS', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF556D5E), letterSpacing: 0.6)),
                        Text(_status, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: Color(0xFF10B981))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // 02 PARENT / ACCOUNT
        _buildSectionHeader('02 PARENT / ACCOUNT'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE2EAE2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_parentName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0C2417))),
                  const SizedBox(height: 2),
                  Text(_accountType, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF556D5E))),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                onPressed: _showEditParentModal,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // 03 PREFERENCES
        _buildSectionHeader('03 PREFERENCES'),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE2EAE2)),
          ),
          child: Column(
            children: [
              _menuItem('01', Icons.notifications_none, 'Notifications'),
              const Divider(height: 1, color: Color(0xFFF0F4F0)),
              _menuItem('02', Icons.settings_outlined, 'App Settings'),
              const Divider(height: 1, color: Color(0xFFF0F4F0)),
              _menuItem('03', Icons.people_outline, 'Manage Profiles'),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // 04 SUPPORT
        _buildSectionHeader('04 SUPPORT'),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE2EAE2)),
          ),
          child: Column(
            children: [
              _menuItem('01', Icons.help_outline, 'Help Center'),
              const Divider(height: 1, color: Color(0xFFF0F4F0)),
              _menuItem('02', Icons.shield_outlined, 'Privacy & Security'),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 05 Sign Out
        GestureDetector(
          onTap: widget.onLogout ?? () => Navigator.of(context).popUntil((route) => route.isFirst),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('05', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF556D5E))),
                  SizedBox(width: 10),
                  Text('Sign Out', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF0C2417))),
                ],
              ),
              Icon(Icons.logout, color: Color(0xFF0C2417), size: 24),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHistoryView() {
    final metrics = [
      {'label': 'HEIGHT', 'value': '90.5 cm', 'icon': Icons.straighten, 'idx': '01 / 03'},
      {'label': 'WEIGHT', 'value': '14.8 kg', 'icon': Icons.scale, 'idx': '02 / 03'},
      {'label': 'AGE', 'value': '13y 6m', 'icon': Icons.calendar_today, 'idx': '03 / 03'},
    ];
    final active = metrics[_historyMetricIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('CHILD HISTORY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF556D5E), letterSpacing: 1.5)),
        const SizedBox(height: 2),
        Text(_childName, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF0C2417))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFBCE4BC)),
          ),
          child: const Text('Health status : Healthy', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF065F46))),
        ),
        const SizedBox(height: 10),
        const Text('A clear record of growth, scans, and clinical notes.', style: TextStyle(fontSize: 13, color: Color(0xFF556D5E))),
        const SizedBox(height: 16),

        // CURRENT DETAILS (01 / 03)
        Align(alignment: Alignment.centerLeft, child: _buildSectionHeader('CURRENT DETAILS', right: active['idx'] as String)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => setState(() => _historyMetricIndex = (_historyMetricIndex + 1) % metrics.length),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE2EAE2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(active['icon'] as IconData, color: const Color(0xFF445B4E)),
                const SizedBox(height: 10),
                Text(active['label'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF556D5E), letterSpacing: 1)),
                const SizedBox(height: 4),
                Text(active['value'] as String, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF0C2417))),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(metrics.length, (i) => Container(
                    margin: const EdgeInsets.only(right: 6),
                    width: i == _historyMetricIndex ? 22 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == _historyMetricIndex ? const Color(0xFF10B981) : const Color(0xFFD0DDD0),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  )),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),

        // PREVIOUS SCANS
        Align(alignment: Alignment.centerLeft, child: _buildSectionHeader('PREVIOUS SCANS & RECORDS', right: '01 entries')),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE2EAE2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('GROWTH TRACKING', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF556D5E))),
                  Text('22 Sept 2026, 7:25 pm', style: TextStyle(fontSize: 11.5, color: Color(0xFF556D5E))),
                ],
              ),
              const SizedBox(height: 6),
              const Text('On Track', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0C2417))),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statCol('HEIGHT', '90.5 cm'),
                  _statCol('WEIGHT', '14.8 kg'),
                  _statCol('BMI', '16.2'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // DOCTOR'S PRESCRIPTION
        Align(alignment: Alignment.centerLeft, child: _buildSectionHeader("DOCTOR'S PRESCRIPTION", right: '03 / 03')),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE2EAE2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Continue the current care plan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0C2417))),
              SizedBox(height: 6),
              Text('Keep regular meals, hydration, and outdoor play consistent. Bring this record to the next pediatric review.', style: TextStyle(fontSize: 13, color: Color(0xFF3D5345), height: 1.4)),
              SizedBox(height: 10),
              Text('📄 REVIEW AT NEXT VISIT', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: Color(0xFF556D5E))),
            ],
          ),
        ),
        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('PDF Report exported successfully')),
            );
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
              Icon(Icons.picture_as_pdf, size: 18),
              SizedBox(width: 8),
              Text('Export PDF report', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {String right = '/'}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF556D5E), letterSpacing: 0.8)),
        Text(right, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF556D5E))),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF556D5E), letterSpacing: 0.6)),
        Text(value, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF0C2417))),
      ],
    );
  }

  Widget _menuItem(String num, IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(num, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF556D5E))),
              const SizedBox(width: 12),
              Icon(icon, size: 18, color: const Color(0xFF0C2417)),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0C2417))),
            ],
          ),
          const Icon(Icons.chevron_right, size: 18, color: Color(0xFF556D5E)),
        ],
      ),
    );
  }

  Widget _statCol(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF556D5E))),
        const SizedBox(height: 2),
        Text(val, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0C2417))),
      ],
    );
  }

  void _showEditChildModal() {
    final nameCtrl = TextEditingController(text: _childName);
    final ageCtrl = TextEditingController(text: '2');
    final genderCtrl = TextEditingController(text: _gender.toLowerCase());
    final statusCtrl = TextEditingController(text: _status);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Edit child profile', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: ageCtrl, decoration: const InputDecoration(labelText: 'Age')),
              TextField(controller: genderCtrl, decoration: const InputDecoration(labelText: 'Gender')),
              TextField(controller: statusCtrl, decoration: const InputDecoration(labelText: 'Growth status')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _childName = nameCtrl.text;
                _age = '${ageCtrl.text} years, 3 months';
                _gender = genderCtrl.text;
                _status = statusCtrl.text;
              });
              Navigator.pop(ctx);
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _showEditParentModal() {
    final parentCtrl = TextEditingController(text: _parentName);
    final typeCtrl = TextEditingController(text: _accountType);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Edit parent account', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: parentCtrl, decoration: const InputDecoration(labelText: 'Parent name')),
            TextField(controller: typeCtrl, decoration: const InputDecoration(labelText: 'Account type')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _parentName = parentCtrl.text;
                _accountType = typeCtrl.text;
              });
              Navigator.pop(ctx);
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
