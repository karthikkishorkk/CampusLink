import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';

import '../screens/common/home_page.dart';
import '../screens/common/profile_page.dart';
import '../screens/common/classroom_finder_page.dart';
import '../screens/teacher/teacher_actions_page.dart';
import '../screens/teacher/teacher_alerts_page.dart';
import '../screens/student/student_assignments_page.dart';
import '../screens/student/alerts_page.dart';
import '../providers/user_provider.dart';

class Navigation extends StatefulWidget {
  final String role;

  const Navigation({Key? key, required this.role}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentIndex = 0;

  /// If other pages want to programmatically switch to "notifications/alerts",
  /// call this with the desired inner tab index (if applicable).
  void _switchToNotifications(int tabIndex) {
    setState(() {
      _currentIndex = 1; // Switch to the second tab (notifications/alerts)
    });
  }

  List<Widget> get _pages {
    // Teacher: use TeacherAlertsPage instead of NotificationsPage
    if (widget.role == 'teacher') {
      return [
        HomePage(onNavigateToNotifications: _switchToNotifications),
        const TeacherAlertsPage(), // Teacher alerts view
        const TeacherActionsPage(), // Index 2 - + action
        ClassroomFinderPage(), // Index 3 - Classroom
        ProfilePage(), // Index 4 - Profile
      ];
    }

    // Student: replace NotificationsPage with AlertsPage (student alerts view)
    return [
      HomePage(onNavigateToNotifications: _switchToNotifications),
      // AlertsPage uses Supabase to show alerts/circulars for students
      const AlertsPage(),
      StudentAssignmentsPage(), // Index 2 - Assignments
      ClassroomFinderPage(), // Index 3 - Classroom
      ProfilePage(), // Index 4 - Profile
    ];
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isTeacher = userProvider.isTeacher || widget.role == 'teacher';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: _pages[_currentIndex],
      extendBody: true, // Extend body behind navigation bar
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE8D5C4),
          color: isDark ? const Color(0xFFF5E6D3) : const Color(0xFF8B1538), // Creamy in dark mode, maroon in light
          buttonBackgroundColor: const Color(0xFFD4AF37),
          height: 75,
          animationDuration: const Duration(milliseconds: 300),
          index: _currentIndex,
          items: isTeacher
              ? <Widget>[
                  // TEACHER: Home, Notifications, +, Classroom, Profile
                  Icon(Icons.home_outlined,
                      size: 30,
                      color: _currentIndex == 0 
                          ? (isDark ? const Color(0xFF1A1A1A) : const Color(0xFF8B1538))
                          : (isDark ? const Color(0xFF8B1538) : const Color(0xFFFFF9F0))),
                  Icon(Icons.notifications_outlined,
                      size: 30,
                      color: _currentIndex == 1 
                          ? (isDark ? const Color(0xFF1A1A1A) : const Color(0xFF8B1538))
                          : (isDark ? const Color(0xFF8B1538) : const Color(0xFFFFF9F0))),
                  Icon(Icons.add_circle_outline,
                      size: 35,
                      color: _currentIndex == 2 
                          ? (isDark ? const Color(0xFF1A1A1A) : const Color(0xFF8B1538))
                          : (isDark ? const Color(0xFF8B1538) : const Color(0xFFFFF9F0))),
                  Icon(Icons.class_outlined,
                      size: 30,
                      color: _currentIndex == 3 
                          ? (isDark ? const Color(0xFF1A1A1A) : const Color(0xFF8B1538))
                          : (isDark ? const Color(0xFF8B1538) : const Color(0xFFFFF9F0))),
                  Icon(Icons.person_outline,
                      size: 30,
                      color: _currentIndex == 4 
                          ? (isDark ? const Color(0xFF1A1A1A) : const Color(0xFF8B1538))
                          : (isDark ? const Color(0xFF8B1538) : const Color(0xFFFFF9F0))),
                ]
              : <Widget>[
                  // STUDENT: Home, Alerts, Assignments, Classroom, Profile
                  Icon(Icons.home_outlined,
                      size: 30,
                      color: _currentIndex == 0 
                          ? (isDark ? const Color(0xFF1A1A1A) : const Color(0xFF8B1538))
                          : (isDark ? const Color(0xFF8B1538) : const Color(0xFFFFF9F0))),
                  Icon(Icons.notifications_outlined,
                      size: 30,
                      color: _currentIndex == 1 
                          ? (isDark ? const Color(0xFF1A1A1A) : const Color(0xFF8B1538))
                          : (isDark ? const Color(0xFF8B1538) : const Color(0xFFFFF9F0))),
                  Icon(Icons.description_outlined,
                      size: 30,
                      color: _currentIndex == 2 
                          ? (isDark ? const Color(0xFF1A1A1A) : const Color(0xFF8B1538))
                          : (isDark ? const Color(0xFF8B1538) : const Color(0xFFFFF9F0))),
                  Icon(Icons.school_outlined,
                      size: 30,
                      color: _currentIndex == 3 
                          ? (isDark ? const Color(0xFF1A1A1A) : const Color(0xFF8B1538))
                          : (isDark ? const Color(0xFF8B1538) : const Color(0xFFFFF9F0))),
                  Icon(Icons.person_outline,
                      size: 30,
                      color: _currentIndex == 4 
                          ? (isDark ? const Color(0xFF1A1A1A) : const Color(0xFF8B1538))
                          : (isDark ? const Color(0xFF8B1538) : const Color(0xFFFFF9F0))),
                ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ); // End of Scaffold
  }
}
