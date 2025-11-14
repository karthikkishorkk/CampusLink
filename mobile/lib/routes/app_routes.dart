import 'package:flutter/widgets.dart';
import '../screens/common/opening_screen.dart';
import '../screens/common/login_page.dart';
import '../screens/common/dashboard_page.dart';
import '../screens/common/documents_page.dart';
import '../screens/common/profile_page.dart';
import '../screens/common/logout_page.dart';
import '../screens/common/classroom_finder_page.dart';
import '../screens/student/alerts_page.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/opening': (context) => const OpeningScreen(),
  '/login': (context) => const AuthScreen(),
  '/dashboard': (context) => const DashboardPage(),
  '/documents': (context) => const DocumentsPage(),
  '/profile': (context) => const ProfilePage(),
  '/logout': (context) => const LogoutPage(),
  '/teacher/find': (context) => const ClassroomFinderPage(),
  '/student/alerts': (context) => const AlertsPage(),
};
