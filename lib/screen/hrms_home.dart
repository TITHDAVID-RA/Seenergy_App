import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../localization/language_controller.dart';
import 'login.dart';
import 'Attentdance.dart';

/// Full-featured HRMS (Human Resource Management System) Dashboard screen.
class HrmsHomeScreen extends StatefulWidget {
  final String userEmail;

  const HrmsHomeScreen({
    super.key,
    required this.userEmail,
  });

  @override
  State<HrmsHomeScreen> createState() => _HrmsHomeScreenState();
}

class _HrmsHomeScreenState extends State<HrmsHomeScreen> {
  bool _isClockedIn = true;
  String _clockTime = '08:30 AM';

  void _toggleClockIn() {
    setState(() {
      _isClockedIn = !_isClockedIn;
      if (_isClockedIn) {
        final now = DateTime.now();
        final hour = now.hour.toString().padLeft(2, '0');
        final minute = now.minute.toString().padLeft(2, '0');
        _clockTime = '$hour:$minute';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isClockedIn
              ? 'Clocked In at $_clockTime'
              : 'Clocked Out successfully',
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: _isClockedIn ? const Color(0xFF10B981) : const Color(0xFF64748B),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.logout,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Text(l10n.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: Color(0xFF64748B)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MobileLoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        titleSpacing: 16,
        title: Row(
          children: [
            Image.asset(
              'assets/seenergy_logo.png',
              height: 26,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'HRMS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Top right language switcher
          _buildCompactLanguageSwitcher(),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFF64748B), size: 22),
            tooltip: l10n.logout,
            onPressed: () => _showLogoutDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- USER PROFILE & ATTENDANCE CARD ---
            _buildProfileBanner(l10n),
            const SizedBox(height: 20),

            // --- SECTION: KPI OVERVIEW STATS ---
            Text(
              l10n.quickStats,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            _buildStatsGrid(l10n),
            const SizedBox(height: 24),

            // --- SECTION: HR MODULES ---
            Text(
              l10n.hrModules,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            _buildModulesGrid(l10n),
            const SizedBox(height: 24),

            // --- SECTION: RECENT ACTIVITY ---
            Text(
              l10n.recentActivity,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            _buildRecentActivityList(l10n),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Compact language switcher in app bar
  Widget _buildCompactLanguageSwitcher() {
    final controller = LanguageController.instance;
    final isKhmer = controller.isKhmer;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => controller.changeLanguage('en'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: !isKhmer ? const Color(0xFF2563EB) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'EN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: !isKhmer ? Colors.white : const Color(0xFF64748B),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => controller.changeLanguage('km'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isKhmer ? const Color(0xFF2563EB) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'ខ្មែរ',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isKhmer ? Colors.white : const Color(0xFF64748B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Profile header with quick Clock-In button
  Widget _buildProfileBanner(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: const Text(
                  'AD',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.greetingAdmin,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.userEmail,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.roleTitle,
                      style: const TextStyle(
                        color: Color(0xFF93C5FD),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    _isClockedIn ? Icons.check_circle_rounded : Icons.access_time_rounded,
                    color: _isClockedIn ? const Color(0xFF34D399) : Colors.white70,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isClockedIn
                        ? '${l10n.clockedIn} ($_clockTime)'
                        : l10n.clockIn,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: _toggleClockIn,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _isClockedIn ? 'Clock Out' : l10n.clockIn,
                    style: TextStyle(
                      color: _isClockedIn ? const Color(0xFFEF4444) : const Color(0xFF2563EB),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 4 KPI Stat Cards
  Widget _buildStatsGrid(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: _buildKpiCard(
            title: l10n.totalEmployees,
            value: '148',
            icon: Icons.people_outline_rounded,
            color: const Color(0xFF2563EB),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AttendancePage()),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: _buildKpiCard(
              title: l10n.attendanceRate,
              value: '96%',
              icon: Icons.check_circle_outline_rounded,
              color: const Color(0xFF10B981),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildKpiCard(
            title: l10n.onLeave,
            value: '6',
            icon: Icons.flight_takeoff_rounded,
            color: const Color(0xFFF59E0B),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildKpiCard(
            title: l10n.pendingApprovals,
            value: '3',
            icon: Icons.assignment_outlined,
            color: const Color(0xFF8B5CF6),
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Grid of HR Modules
  Widget _buildModulesGrid(AppLocalizations l10n) {
    final modules = [
      {'title': l10n.moduleEmployees, 'icon': Icons.badge_outlined, 'color': const Color(0xFF2563EB)},
      {'title': l10n.moduleAttendance, 'icon': Icons.calendar_today_outlined, 'color': const Color(0xFF059669)},
      {'title': l10n.moduleLeaves, 'icon': Icons.beach_access_outlined, 'color': const Color(0xFFD97706)},
      {'title': l10n.modulePayroll, 'icon': Icons.payments_outlined, 'color': const Color(0xFF7C3AED)},
      {'title': l10n.modulePerformance, 'icon': Icons.trending_up_rounded, 'color': const Color(0xFFDC2626)},
      {'title': l10n.moduleAnnouncements, 'icon': Icons.campaign_outlined, 'color': const Color(0xFF0284C7)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: modules.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (context, index) {
        final item = modules[index];
        final color = item['color'] as Color;

        return InkWell(
          onTap: () {
            if (item['title'] == l10n.moduleAttendance) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AttendancePage()),
              );
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${item['title']} module opened'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item['icon'] as IconData, color: color, size: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  item['title'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Recent activity list
  Widget _buildRecentActivityList(AppLocalizations l10n) {
    final activities = [
      {
        'text': l10n.activity1,
        'time': '10 mins ago',
        'icon': Icons.beach_access_rounded,
        'color': const Color(0xFFF59E0B),
      },
      {
        'text': l10n.activity2,
        'time': '1 hour ago',
        'icon': Icons.account_balance_wallet_rounded,
        'color': const Color(0xFF8B5CF6),
      },
      {
        'text': l10n.activity3,
        'time': '2 hours ago',
        'icon': Icons.access_time_filled_rounded,
        'color': const Color(0xFF10B981),
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (context, index) => const Divider(color: Color(0xFFF1F5F9), height: 1),
        itemBuilder: (context, index) {
          final item = activities[index];
          final color = item['color'] as Color;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item['icon'] as IconData, color: color, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['text'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['time'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
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
