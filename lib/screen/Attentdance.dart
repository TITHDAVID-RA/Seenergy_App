import 'dart:async';
import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../localization/language_controller.dart';


/// Model for Employee Attendance Record
class AttendanceRecord {
  final String id;
  final String name;
  final String department;
  final String avatarInitials;
  String status; // Present, Late, Absent, On Leave
  DateTime? checkIn;
  DateTime? checkOut;

  AttendanceRecord({
    required this.id,
    required this.name,
    required this.department,
    required this.avatarInitials,
    required this.status,
    this.checkIn,
    this.checkOut,
  });

  String get workingDuration {
    if (checkIn == null) return '--';
    final end = checkOut ?? DateTime.now();
    final diff = end.difference(checkIn!);
    if (diff.isNegative) return '--';
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
  }
}

/// Main Attendance Page supporting both Personal & Team Management views.
class AttendancePage extends StatefulWidget {
  final bool isManager;

  const AttendancePage({
    super.key,
    this.isManager = false,
  });

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Timer? _liveClockTimer;
  DateTime _currentTime = DateTime.now();

  // Current User's Personal Attendance State
  bool _isClockedIn = true;
  DateTime? _myCheckIn = DateTime(2026, 11, 8, 8, 25);
  DateTime? _myCheckOut;
  String _myStatus = 'Present';

  // Filters and Search for Team View
  String selectedFilter = 'All';
  String searchText = '';

  // Team Attendance Data
  final List<AttendanceRecord> employees = [
    AttendanceRecord(
      id: 'EMP-1001',
      name: 'Sok Dara',
      department: 'Mobile Engineering',
      avatarInitials: 'SD',
      status: 'Present',
      checkIn: DateTime(2026, 11, 8, 8, 10),
      checkOut: null,
    ),
    AttendanceRecord(
      id: 'EMP-1002',
      name: 'Chan Sokha',
      department: 'UI/UX Design',
      avatarInitials: 'CS',
      status: 'Late',
      checkIn: DateTime(2026, 11, 8, 8, 48),
      checkOut: null,
    ),
    AttendanceRecord(
      id: 'EMP-1003',
      name: 'Vong Mey Mey',
      department: 'Finance & Payroll',
      avatarInitials: 'MM',
      status: 'Absent',
    ),
    AttendanceRecord(
      id: 'EMP-1004',
      name: 'Dara Vicheka',
      department: 'HR Management',
      avatarInitials: 'DV',
      status: 'On Leave',
    ),
    AttendanceRecord(
      id: 'EMP-1005',
      name: 'Buntha Rith',
      department: 'Backend Services',
      avatarInitials: 'BR',
      status: 'Present',
      checkIn: DateTime(2026, 11, 8, 7, 55),
      checkOut: null,
    ),
  ];

  // Past Attendance Logs for Current User
  final List<Map<String, dynamic>> _myPersonalLogs = [
    {
      'date': 'Yesterday (Nov 7)',
      'in': '08:15 AM',
      'out': '05:10 PM',
      'duration': '8h 55m',
      'status': 'Present',
    },
    {
      'date': 'Wednesday (Nov 6)',
      'in': '08:42 AM',
      'out': '05:30 PM',
      'duration': '8h 48m',
      'status': 'Late',
    },
    {
      'date': 'Tuesday (Nov 5)',
      'in': '08:10 AM',
      'out': '05:00 PM',
      'duration': '8h 50m',
      'status': 'Present',
    },
    {
      'date': 'Monday (Nov 4)',
      'in': '08:05 AM',
      'out': '05:02 PM',
      'duration': '8h 57m',
      'status': 'Present',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _liveClockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _liveClockTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  // Time formatter
  String _formatTime(DateTime? time) {
    if (time == null) return '--:--';
    final hour = time.hour > 12
        ? (time.hour - 12).toString().padLeft(2, '0')
        : (time.hour == 0 ? '12' : time.hour.toString().padLeft(2, '0'));
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  // Live ticking time format
  String _formatLiveClock(DateTime time) {
    final hour = time.hour > 12
        ? (time.hour - 12).toString().padLeft(2, '0')
        : (time.hour == 0 ? '12' : time.hour.toString().padLeft(2, '0'));
    final minute = time.minute.toString().padLeft(2, '0');
    final second = time.second.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute:$second $period';
  }

  // Date format
  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    const weekdays = [
      'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
    ];
    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    return '$weekday, $month ${date.day}, ${date.year}';
  }

  // Toggle Check In / Check Out for current user
  void _toggleMyClock() {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();

    setState(() {
      if (!_isClockedIn) {
        // Clock In
        _isClockedIn = true;
        _myCheckIn = now;
        _myCheckOut = null;
        // If later than 08:30 AM -> Late
        if (now.hour > 8 || (now.hour == 8 && now.minute > 30)) {
          _myStatus = 'Late';
        } else {
          _myStatus = 'Present';
        }
      } else {
        // Clock Out
        _isClockedIn = false;
        _myCheckOut = now;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _isClockedIn ? Icons.check_circle : Icons.logout_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              _isClockedIn
                  ? '${l10n.clockedIn} (${_formatTime(_myCheckIn)})'
                  : '${l10n.clockOut} (${_formatTime(_myCheckOut)})',
            ),
          ],
        ),
        backgroundColor: _isClockedIn
            ? const Color(0xFF10B981)
            : const Color(0xFF2563EB),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Filtered employees for Manager view
  List<AttendanceRecord> get filteredEmployees {
    return employees.where((employee) {
      final matchesSearch =
          employee.name.toLowerCase().contains(searchText.toLowerCase()) ||
          employee.id.toLowerCase().contains(searchText.toLowerCase()) ||
          employee.department.toLowerCase().contains(searchText.toLowerCase());

      final matchesFilter =
          selectedFilter == 'All' || employee.status == selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  int _countStatus(String status) {
    return employees.where((e) => e.status == status).length;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Present':
        return const Color(0xFF10B981); // Emerald
      case 'Late':
        return const Color(0xFFF59E0B); // Amber
      case 'Absent':
        return const Color(0xFFEF4444); // Red
      case 'On Leave':
        return const Color(0xFF3B82F6); // Blue
      default:
        return const Color(0xFF64748B);
    }
  }

  // Dialog to request attendance regularization
  void _showRegularizationDialog(AppLocalizations l10n) {
    final reasonController = TextEditingController();
    String selectedType = 'Forgot Punch In/Out';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.edit_calendar_rounded, color: Color(0xFF2563EB)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.requestRegularization,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Request Type',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Forgot Punch In/Out',
                        child: Text('Forgot Punch In/Out'),
                      ),
                      DropdownMenuItem(
                        value: 'Offsite Client Meeting',
                        child: Text('Offsite Client Meeting'),
                      ),
                      DropdownMenuItem(
                        value: 'System/GPS Issue',
                        child: Text('System/GPS Issue'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedType = val);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Reason & Details',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: reasonController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: l10n.reasonHint,
                      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.cancel, style: const TextStyle(color: Color(0xFF64748B))),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.regularizationSubmitted),
                      backgroundColor: const Color(0xFF10B981),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(l10n.submit),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isManager = widget.isManager;
    final l10n = AppLocalizations.of(context);
    final isKhmer = LanguageController.instance.isKhmer;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.moduleAttendance,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          // Language Switcher Pill
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => LanguageController.instance.changeLanguage('en'),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: !isKhmer ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'EN',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: !isKhmer ? const Color(0xFF1E3A8A) : Colors.white70,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => LanguageController.instance.changeLanguage('km'),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isKhmer ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'ខ្មែរ',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isKhmer ? const Color(0xFF1E3A8A) : Colors.white70,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: isManager? TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFF93C5FD),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: [
            Tab(
              icon: const Icon(Icons.person_pin_circle_outlined, size: 20),
              text: l10n.myAttendance,
            ),
            Tab(
              icon: const Icon(Icons.groups_outlined, size: 20),
              text: l10n.teamAttendance,
            ),
          ],
        )
        : null
      ),
      body: isManager
          ? TabBarView(
              controller: _tabController,
              children: [
                _buildMyAttendanceView(l10n),
                _buildTeamOverviewView(l10n),
              ],
            )
          : _buildMyAttendanceView(l10n),
    );
  }

  // ==========================================
  // TAB 1: EMPLOYEE PERSONAL ATTENDANCE VIEW
  // ==========================================
  Widget _buildMyAttendanceView(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // HERO LIVE CLOCK & PUNCH CARD
          _buildHeroPunchCard(l10n),

          const SizedBox(height: 20),

          // THIS MONTH ATTENDANCE STATS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'This Month Overview',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              TextButton.icon(
                onPressed: () => _showRegularizationDialog(l10n),
                icon: const Icon(Icons.pending_actions, size: 16, color: Color(0xFF2563EB)),
                label: Text(
                  l10n.requestRegularization,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          _buildMonthlyKpiGrid(l10n),

          const SizedBox(height: 24),

          // ATTENDANCE LOGS HISTORY
          Text(
            l10n.history,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 12),

          ..._myPersonalLogs.map((log) => _buildPersonalHistoryCard(log)),
        ],
      ),
    );
  }

  /// Big Hero Punch Card with Live Clock & GPS Verification
  Widget _buildHeroPunchCard(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Date & Geofence Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDate(_currentTime),
                    style: const TextStyle(
                      color: Color(0xFFBFDBFE),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatLiveClock(_currentTime),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              // GPS verification badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.gps_fixed_rounded, color: Color(0xFF34D399), size: 14),
                    SizedBox(width: 5),
                    Text(
                      'GPS Verified',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Location info pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.business_rounded, color: Color(0xFF93C5FD), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.officeLocation,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Radius: 18m',
                    style: TextStyle(color: Color(0xFF6EE7B7), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Big Interactive Punch Button
          GestureDetector(
            onTap: _toggleMyClock,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: _isClockedIn
                      ? [const Color(0xFFEF4444), const Color(0xFFDC2626)]
                      : [const Color(0xFF10B981), const Color(0xFF059669)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (_isClockedIn ? const Color(0xFFEF4444) : const Color(0xFF10B981))
                        .withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isClockedIn ? Icons.logout_rounded : Icons.fingerprint_rounded,
                    color: Colors.white,
                    size: 44,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isClockedIn ? l10n.clockOut : l10n.clockIn,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 22),

          // Daily Punch Timestamps Row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeDetailColumn(
                  Icons.login_rounded,
                  'Check In',
                  _formatTime(_myCheckIn),
                  const Color(0xFF10B981),
                ),
                Container(height: 30, width: 1, color: const Color(0xFFE2E8F0)),
                _buildTimeDetailColumn(
                  Icons.logout_rounded,
                  'Check Out',
                  _formatTime(_myCheckOut),
                  const Color(0xFFEF4444),
                ),
                Container(height: 30, width: 1, color: const Color(0xFFE2E8F0)),
                _buildTimeDetailColumn(
                  Icons.timer_outlined,
                  l10n.workingHours,
                  _isClockedIn ? 'In Progress' : 'Completed',
                  const Color(0xFF2563EB),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDetailColumn(
    IconData icon,
    String title,
    String time,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  /// Monthly KPI summary cards
  Widget _buildMonthlyKpiGrid(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: _buildSimpleKpi(
            'Present',
            '21 Days',
            const Color(0xFF10B981),
            Icons.check_circle_outline,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSimpleKpi(
            'Late',
            '2 Days',
            const Color(0xFFF59E0B),
            Icons.access_time,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSimpleKpi(
            'Absent',
            '0 Days',
            const Color(0xFFEF4444),
            Icons.cancel_outlined,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSimpleKpi(
            'Leave',
            '1 Day',
            const Color(0xFF3B82F6),
            Icons.beach_access_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleKpi(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  /// Personal Attendance History Card
  Widget _buildPersonalHistoryCard(Map<String, dynamic> log) {
    final status = log['status'] as String;
    final color = _getStatusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              status == 'Late' ? Icons.access_time_rounded : Icons.check_circle_rounded,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log['date'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'In: ${log['in']}  •  Out: ${log['out']}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                log['duration'],
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 2: MANAGER / TEAM OVERVIEW VIEW
  // ==========================================
  Widget _buildTeamOverviewView(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Text
          Text(
            l10n.teamAttendance,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Real-time employee presence & shift tracking',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),

          const SizedBox(height: 16),

          // Overview Dashboard KPIs
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildTeamKpiCard(
                l10n.present,
                _countStatus('Present'),
                const Color(0xFF10B981),
                Icons.check_circle_outline,
              ),
              _buildTeamKpiCard(
                l10n.late,
                _countStatus('Late'),
                const Color(0xFFF59E0B),
                Icons.access_time,
              ),
              _buildTeamKpiCard(
                l10n.absent,
                _countStatus('Absent'),
                const Color(0xFFEF4444),
                Icons.cancel_outlined,
              ),
              _buildTeamKpiCard(
                l10n.onLeave,
                _countStatus('On Leave'),
                const Color(0xFF3B82F6),
                Icons.event_busy_outlined,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Search Field
          TextField(
            decoration: InputDecoration(
              hintText: 'Search employee name, ID or department...',
              hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
          ),

          const SizedBox(height: 12),

          // Status Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Present', 'Late', 'Absent', 'On Leave'].map((filter) {
                final isSelected = selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    selectedColor: const Color(0xFF2563EB).withValues(alpha: 0.15),
                    checkmarkColor: const Color(0xFF2563EB),
                    labelStyle: TextStyle(
                      color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF475569),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Employees List
          if (filteredEmployees.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 10),
                    Text(
                      'No matching employees found',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
          else
            ...filteredEmployees.map(_buildEmployeeCard),
        ],
      ),
    );
  }

  Widget _buildTeamKpiCard(String title, int count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(AttendanceRecord employee) {
    final color = _getStatusColor(employee.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF2563EB).withValues(alpha: 0.1),
                child: Text(
                  employee.avatarInitials,
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      '${employee.id} • ${employee.department}',
                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  employee.status,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const Divider(height: 20, color: Color(0xFFF1F5F9)),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSmallTimeInfo(
                Icons.login_rounded,
                'Check In',
                _formatTime(employee.checkIn),
                const Color(0xFF10B981),
              ),
              _buildSmallTimeInfo(
                Icons.logout_rounded,
                'Check Out',
                _formatTime(employee.checkOut),
                const Color(0xFFEF4444),
              ),
              _buildSmallTimeInfo(
                Icons.timelapse_rounded,
                'Worked',
                employee.workingDuration,
                const Color(0xFF2563EB),
              ),
            ],
          ),

          // Quick Manager Action Button (Manual Override)
          if (employee.status != 'On Leave') ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        if (employee.checkIn == null) {
                          employee.checkIn = DateTime.now();
                          employee.status = 'Present';
                        } else if (employee.checkOut == null) {
                          employee.checkOut = DateTime.now();
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Updated ${employee.name}\'s attendance record'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text(
                      employee.checkIn == null
                          ? 'Manual Clock In'
                          : employee.checkOut == null
                              ? 'Manual Clock Out'
                              : 'Shift Finished',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: employee.checkOut != null
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF2563EB),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSmallTimeInfo(IconData icon, String title, String time, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
            ),
            Text(
              time,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
