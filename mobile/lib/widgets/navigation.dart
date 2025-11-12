import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import '../screens/common/home_page.dart';
import '../screens/common/notifications_page.dart';
import '../screens/common/profile_page.dart';
import '../screens/common/classroom_finder_page.dart';
import '../screens/teacher/teacher_actions_page.dart';
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

  void _switchToNotifications(int tabIndex) {
    setState(() {
      _currentIndex = 1; // Switch to notifications tab
      _notificationTabIndex = tabIndex;
    });
  }

  List<Widget> get _pages {
    if (widget.role == 'teacher') {
      return [
        HomePage(onNavigateToNotifications: _switchToNotifications),
        NotificationsPage(initialTab: _notificationTabIndex, key: ValueKey(_notificationTabIndex)),
        const TeacherActionsPage(), // Index 2 - + button page
        const ClassroomFinderPage(), // Index 3 - Classroom
        const ProfilePage(), // Index 4
      ];
    } else {
      // Students only have 4 pages
      return [
        HomePage(onNavigateToNotifications: _switchToNotifications),
        NotificationsPage(initialTab: _notificationTabIndex, key: ValueKey(_notificationTabIndex)),
        const ClassroomFinderPage(),
        const ProfilePage(),
      ];
    }
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
          items: isTeacher ? <Widget>[
            // TEACHER: 5 icons (Home, Notifications, +, Classroom, Profile)
            Icon(Icons.home_outlined, size: 30, color: _currentIndex == 0 ? Colors.white : const Color(0xFF7AB8F7)),
            Icon(Icons.notifications_outlined, size: 30, color: _currentIndex == 1 ? Colors.white : const Color(0xFF7AB8F7)),
            Icon(Icons.add_circle_outline, size: 35, color: _currentIndex == 2 ? Colors.white : const Color(0xFF7AB8F7)),
            Icon(Icons.class_outlined, size: 30, color: _currentIndex == 3 ? Colors.white : const Color(0xFF7AB8F7)),
            Icon(Icons.person_outline, size: 30, color: _currentIndex == 4 ? Colors.white : const Color(0xFF7AB8F7)),
          ] : <Widget>[
            // STUDENT: 4 icons (Home, Notifications, Classroom, Profile)
            Icon(Icons.home_outlined, size: 30, color: _currentIndex == 0 ? Colors.white : const Color(0xFF7AB8F7)),
            Icon(Icons.notifications_outlined, size: 30, color: _currentIndex == 1 ? Colors.white : const Color(0xFF7AB8F7)),
            Icon(Icons.school_outlined, size: 30, color: _currentIndex == 2 ? Colors.white : const Color(0xFF7AB8F7)),
            Icon(Icons.person_outline, size: 30, color: _currentIndex == 3 ? Colors.white : const Color(0xFF7AB8F7)),
          ],
          onTap: (index) {
            if (isTeacher) {
              // Teacher navigation
              if (index == 3) {
                // Classroom icon (4th position) -> navigate to index 3
                setState(() {
                  _currentIndex = 3;
                });
              } else {
                // All other icons work normally
                setState(() {
                  _currentIndex = index;
                });
              }
            } else {
              // Student navigation - straightforward
              setState(() {
                _currentIndex = index;
              });
            }
          },
        ),
      ),
    );
  }
}
