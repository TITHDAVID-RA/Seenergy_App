import 'package:flutter/material.dart';

/// AppLocalizations handles bilingual strings for English (en) and Khmer (km).
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('km'),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Login Strings
      'brandName': 'SEENERGY',
      'brandSubtitle': 'CAPITAL',
      'signIn': 'Sign In',
      'welcomeBack': 'Welcome back! Enter your details to continue.',
      'emailLabel': 'EMAIL ADDRESS *',
      'emailHint': 'Email Address',
      'passwordLabel': 'PASSWORD *',
      'passwordHint': 'Password',
      'logIn': 'Log In',
      'securityFooter': 'Protected by Enterprise Security',
      'copyright': '© SEENERGY CAPITAL. All rights reserved.',
      'language': 'Language',
      'english': 'English',
      'khmer': 'ភាសាខ្មែរ',
      'testAccountHint': 'Test Account: admin@seenergy.com / password123',
      'autoFillTest': 'Auto-fill Test Account',
      'emptyEmailError': 'Please enter your email',
      'invalidEmailError': 'Please enter a valid email address',
      'emptyPasswordError': 'Please enter your password',
      'loginFailedError': 'Invalid email or password (Use admin@seenergy.com / password123)',

      // HRMS Strings
      'hrmsPortal': 'HRMS Portal',
      'dashboard': 'HR Dashboard',
      'greetingAdmin': 'Welcome back, Admin',
      'roleTitle': 'HR Operations Manager',
      'clockIn': 'Clock In',
      'clockedIn': 'Clocked In',
      'quickStats': 'Overview Today',
      'totalEmployees': 'Total Staff',
      'attendanceRate': 'Attendance',
      'onLeave': 'On Leave',
      'pendingApprovals': 'Approvals',
      'hrModules': 'HR Management',
      'moduleEmployees': 'Employees',
      'moduleAttendance': 'Attendance',
      'moduleLeaves': 'Leave Requests',
      'modulePayroll': 'Payroll',
      'modulePerformance': 'Performance',
      'moduleAnnouncements': 'Notices',
      'recentActivity': 'Recent Activity',
      'activity1': 'Dara Sok submitted an Annual Leave request',
      'activity2': 'Monthly Payroll processed for October',
      'activity3': 'Bopha Vong clocked in at 08:24 AM',
      'logoutConfirm': 'Do you want to log out?',
      'logout': 'Log Out',
      'cancel': 'Cancel',

      // Attendance Module Strings
      'myAttendance': 'My Attendance',
      'teamAttendance': 'Team Overview',
      'clockOut': 'Clock Out',
      'present': 'Present',
      'late': 'Late',
      'absent': 'Absent',
      'workingHours': 'Working Hours',
      'officeLocation': 'Seenergy HQ (In Radius)',
      'requestRegularization': 'Request Regularization',
      'regularizationSubmitted': 'Regularization request submitted to HR manager',
      'reasonHint': 'Reason (e.g., Client meeting, forgot punch)...',
      'submit': 'Submit',
      'history': 'Attendance History',
    },
    'km': {
      // Login Strings
      'brandName': 'SEENERGY',
      'brandSubtitle': 'CAPITAL',
      'signIn': 'ចូលគណនី',
      'welcomeBack': 'សូមស្វាគមន៍ត្រឡប់មកវិញ! សូមបញ្ចូលព័ត៌មានរបស់អ្នកដើម្បីបន្ត។',
      'emailLabel': 'អាសយដ្ឋានអ៊ីមែល *',
      'emailHint': 'បញ្ចូលអាសយដ្ឋានអ៊ីមែល',
      'passwordLabel': 'ពាក្យសម្ងាត់ *',
      'passwordHint': 'បញ្ចូលពាក្យសម្ងាត់',
      'logIn': 'ចូលគណនី',
      'securityFooter': 'ការពារដោយប្រព័ន្ធសុវត្ថិភាពកម្រិតសហគ្រាស',
      'copyright': '© SEENERGY CAPITAL. រក្សាសិទ្ធិគ្រប់យ៉ាង។',
      'language': 'ភាសា',
      'english': 'English',
      'khmer': 'ភាសាខ្មែរ',
      'testAccountHint': 'គណនីសាកល្បង៖ admin@seenergy.com / password123',
      'autoFillTest': 'បំពេញគណនីសាកល្បង',
      'emptyEmailError': 'សូមបញ្ចូលអាសយដ្ឋានអ៊ីមែលរបស់អ្នក',
      'invalidEmailError': 'ទម្រង់អ៊ីមែលមិនត្រឹមត្រូវទេ',
      'emptyPasswordError': 'សូមបញ្ចូលពាក្យសម្ងាត់របស់អ្នក',
      'loginFailedError': 'អ៊ីមែល ឬពាក្យសម្ងាត់មិនត្រឹមត្រូវ (សូមប្រើ admin@seenergy.com / password123)',

      // HRMS Strings
      'hrmsPortal': 'ប្រព័ន្ធគ្រប់គ្រងធនធានមនុស្ស (HRMS)',
      'dashboard': 'ផ្ទាំងព័ត៌មាន HR',
      'greetingAdmin': 'សូមស្វាគមន៍ត្រឡប់មកវិញ, Admin',
      'roleTitle': 'អ្នកគ្រប់គ្រងធនធានមនុស្ស',
      'clockIn': 'កត់ត្រាម៉ោងចូល',
      'clockedIn': 'បានចូលធ្វើការរួចរាល់',
      'quickStats': 'ទិដ្ឋភាពទូទៅថ្ងៃនេះ',
      'totalEmployees': 'បុគ្គលិកសរុប',
      'attendanceRate': 'វត្តមាន',
      'onLeave': 'សុំច្បាប់',
      'pendingApprovals': 'ការអនុម័ត',
      'hrModules': 'ផ្នែកគ្រប់គ្រងទូទៅ',
      'moduleEmployees': 'បុគ្គលិក',
      'moduleAttendance': 'វត្តមាន',
      'moduleLeaves': 'ច្បាប់សម្រាក',
      'modulePayroll': 'ប្រាក់បៀវត្សរ៍',
      'modulePerformance': 'ការវាយតម្លៃ',
      'moduleAnnouncements': 'សេចក្តីជូនដំណឹង',
      'recentActivity': 'សកម្មភាពថ្មីៗ',
      'activity1': 'សុខ តារា បានដាក់ពាក្យសុំច្បាប់សម្រាកប្រចាំឆ្នាំ',
      'activity2': 'បានបើកផ្តល់ប្រាក់បៀវត្សរ៍ប្រចាំខែតុលា',
      'activity3': 'វង្ស បុប្ផា បានកត់ត្រាវត្តមាននៅម៉ោង ០៨:២៤ ព្រឹក',
      'logoutConfirm': 'តើអ្នកពិតជាចង់ចាកចេញមែនទេ?',
      'logout': 'ចាកចេញ',
      'cancel': 'បោះបង់',

      // Attendance Module Strings
      'myAttendance': 'វត្តមានផ្ទាល់ខ្លួន',
      'teamAttendance': 'ទិដ្ឋភាពរួមក្រុមការងារ',
      'clockOut': 'កត់ត្រាម៉ោងចេញ',
      'present': 'មានវត្តមាន',
      'late': 'យឺត',
      'absent': 'អវត្តមាន',
      'workingHours': 'ម៉ោងធ្វើការ',
      'officeLocation': 'ការិយាល័យកណ្តាល Seenergy (ក្នុងបរិវេណ)',
      'requestRegularization': 'ស្នើសុំកែសម្រួលវត្តមាន',
      'regularizationSubmitted': 'សំណើកែសម្រួលវត្តមានត្រូវបានបញ្ជូនទៅអ្នកគ្រប់គ្រង',
      'reasonHint': 'មូលហេតុ (ឧ. ប្រជុំជាមួយអតិថិជន, ភ្លេចស្កេន)...',
      'submit': 'បញ្ជូនសំណើ',
      'history': 'ប្រវត្តិកត់ត្រាវត្តមាន',
    },
  };

  String _get(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  // Login Getters
  String get brandName => _get('brandName');
  String get brandSubtitle => _get('brandSubtitle');
  String get signIn => _get('signIn');
  String get welcomeBack => _get('welcomeBack');
  String get emailLabel => _get('emailLabel');
  String get emailHint => _get('emailHint');
  String get passwordLabel => _get('passwordLabel');
  String get passwordHint => _get('passwordHint');
  String get logIn => _get('logIn');
  String get securityFooter => _get('securityFooter');
  String get copyright => _get('copyright');
  String get language => _get('language');
  String get english => _get('english');
  String get khmer => _get('khmer');
  String get testAccountHint => _get('testAccountHint');
  String get autoFillTest => _get('autoFillTest');
  String get emptyEmailError => _get('emptyEmailError');
  String get invalidEmailError => _get('invalidEmailError');
  String get emptyPasswordError => _get('emptyPasswordError');
  String get loginFailedError => _get('loginFailedError');

  // HRMS Getters
  String get hrmsPortal => _get('hrmsPortal');
  String get dashboard => _get('dashboard');
  String get greetingAdmin => _get('greetingAdmin');
  String get roleTitle => _get('roleTitle');
  String get clockIn => _get('clockIn');
  String get clockedIn => _get('clockedIn');
  String get quickStats => _get('quickStats');
  String get totalEmployees => _get('totalEmployees');
  String get attendanceRate => _get('attendanceRate');
  String get onLeave => _get('onLeave');
  String get pendingApprovals => _get('pendingApprovals');
  String get hrModules => _get('hrModules');
  String get moduleEmployees => _get('moduleEmployees');
  String get moduleAttendance => _get('moduleAttendance');
  String get moduleLeaves => _get('moduleLeaves');
  String get modulePayroll => _get('modulePayroll');
  String get modulePerformance => _get('modulePerformance');
  String get moduleAnnouncements => _get('moduleAnnouncements');
  String get recentActivity => _get('recentActivity');
  String get activity1 => _get('activity1');
  String get activity2 => _get('activity2');
  String get activity3 => _get('activity3');
  String get logoutConfirm => _get('logoutConfirm');
  String get logout => _get('logout');
  String get cancel => _get('cancel');

  // Attendance Module Getters
  String get myAttendance => _get('myAttendance');
  String get teamAttendance => _get('teamAttendance');
  String get clockOut => _get('clockOut');
  String get present => _get('present');
  String get late => _get('late');
  String get absent => _get('absent');
  String get workingHours => _get('workingHours');
  String get officeLocation => _get('officeLocation');
  String get requestRegularization => _get('requestRegularization');
  String get regularizationSubmitted => _get('regularizationSubmitted');
  String get reasonHint => _get('reasonHint');
  String get submit => _get('submit');
  String get history => _get('history');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'km'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
