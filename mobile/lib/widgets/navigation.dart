import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';

import '../screens/common/home_page.dart';
import '../screens/common/notifications_page.dart';
import '../screens/common/profile_page.dart';
import '../screens/common/classroom_finder_page.dart';
import '../screens/teacher/teacher_actions_page.dart';
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
  int _notificationTabIndex = 0;

  /// If other pages want to programmatically switch to "notifications/alerts",
  /// call this with the desired inner tab index (if applicable).
  void _switchToNotifications(int tabIndex) {
    setState(() {
      _currentIndex = 1; // Switch to the second tab (notifications/alerts)
      _notificationTabIndex = tabIndex;
    });
  }

  List<Widget> get _pages {
    // Teacher: keep NotificationsPage (teacher-specific)
    if (widget.role == 'teacher') {
      return [
        HomePage(onNavigateToNotifications: _switchToNotifications),
        NotificationsPage(
          initialTab: _notificationTabIndex,
          key: ValueKey(_notificationTabIndex),
        ),
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

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: CurvedNavigationBar(
          backgroundColor: const Color(0xFFF8F9FA),
          color: Colors.white,
          buttonBackgroundColor: const Color(0xFF7AB8F7),
          height: 60,
          animationDuration: const Duration(milliseconds: 300),
          index: _currentIndex,
          items: isTeacher
              ? <Widget>[
                  // TEACHER: Home, Notifications, +, Classroom, Profile
                  Icon(Icons.home_outlined,
                      size: 30,
                      color: _currentIndex == 0 ? Colors.white : const Color(0xFF7AB8F7)),
                  Icon(Icons.notifications_outlined,
                      size: 30,
                      color: _currentIndex == 1 ? Colors.white : const Color(0xFF7AB8F7)),
                  Icon(Icons.add_circle_outline,
                      size: 35,
                      color: _currentIndex == 2 ? Colors.white : const Color(0xFF7AB8F7)),
                  Icon(Icons.class_outlined,
                      size: 30,
                      color: _currentIndex == 3 ? Colors.white : const Color(0xFF7AB8F7)),
                  Icon(Icons.person_outline,
                      size: 30,
                      color: _currentIndex == 4 ? Colors.white : const Color(0xFF7AB8F7)),
                ]
              : <Widget>[
                  // STUDENT: Home, Alerts, Assignments, Classroom, Profile
                  Icon(Icons.home_outlined,
                      size: 30,
                      color: _currentIndex == 0 ? Colors.white : const Color(0xFF7AB8F7)),
                  Icon(Icons.notifications_outlined,
                      size: 30,
                      color: _currentIndex == 1 ? Colors.white : const Color(0xFF7AB8F7)),
                  Icon(Icons.description_outlined,
                      size: 30,
                      color: _currentIndex == 2 ? Colors.white : const Color(0xFF7AB8F7)),
                  Icon(Icons.school_outlined,
                      size: 30,
                      color: _currentIndex == 3 ? Colors.white : const Color(0xFF7AB8F7)),
                  Icon(Icons.person_outline,
                      size: 30,
                      color: _currentIndex == 4 ? Colors.white : const Color(0xFF7AB8F7)),
                ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
