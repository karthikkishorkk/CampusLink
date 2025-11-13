import 'package:flutter/material.dart';
import './notifications_page.dart';
import '../../widgets/event_card.dart';

class HomePage extends StatefulWidget {
  final Function(int)? onNavigateToNotifications;
  
  const HomePage({Key? key, this.onNavigateToNotifications}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Sample events data
  final List<Map<String, dynamic>> upcomingEvents = [
    {
      'title': 'Tech Fest 2024',
      'date': 'Nov 20-22, 2024',
      'time': '9:00 AM - 6:00 PM',
      'location': 'Main Auditorium',
      'color': const Color(0xFF7AB8F7),
    },
    {
      'title': 'Guest Lecture: AI & ML',
      'date': 'Nov 15, 2024',
      'time': '2:00 PM - 4:00 PM',
      'location': 'Room S201',
      'color': const Color(0xFF9B59B6),
    },
    {
      'title': 'Sports Day',
      'date': 'Nov 25, 2024',
      'time': '8:00 AM - 5:00 PM',
      'location': 'Sports Ground',
      'color': const Color(0xFFE74C3C),
    },
    {
      'title': 'Cultural Night',
      'date': 'Nov 30, 2024',
      'time': '6:00 PM - 10:00 PM',
      'location': 'Open Air Theatre',
      'color': const Color(0xFFF39C12),
    },
  ];

  // Sample notifications data - in real app, this would come from a shared state/provider
  final List<Map<String, dynamic>> allNotifications = [
    {
      'title': 'Urgent: Exam Schedule Released',
      'date': 'Nov 11, 2024',
      'message': 'Mid-semester examination schedule has been released. Check your timetable now!',
      'isLiked': false,
      'priority': 'high',
    },
    {
      'title': 'Assignment Deadline Extended',
      'date': 'Nov 10, 2024',
      'message': 'The deadline for Database Management System assignment has been extended to Nov 15, 2024.',
      'isLiked': true,
      'priority': 'high',
    },
    {
      'title': 'Campus Event: Tech Fest 2024',
      'date': 'Nov 9, 2024',
      'message': 'Annual Tech Fest is scheduled for Nov 20-22. Register now to participate in exciting competitions!',
      'isLiked': true,
      'priority': 'normal',
    },
    {
      'title': 'Library Notice',
      'date': 'Nov 8, 2024',
      'message': 'Library will remain open 24/7 during exam week. Please maintain silence in reading areas.',
      'isLiked': false,
      'priority': 'normal',
    },
    {
      'title': 'New Course Material Available',
      'date': 'Nov 7, 2024',
      'message': 'Prof. Smith has uploaded new lecture notes for Machine Learning. Check the classroom section.',
      'isLiked': true,
      'priority': 'normal',
    },
    {
      'title': 'Hostel Maintenance Notice',
      'date': 'Nov 6, 2024',
      'message': 'Water supply will be interrupted on Nov 12 from 10 AM to 2 PM for maintenance work.',
      'isLiked': false,
      'priority': 'high',
    },
  ];

  List<Map<String, dynamic>> get highPriorityNotifications {
    return allNotifications.where((n) => n['priority'] == 'high').take(2).toList();
  }

  List<Map<String, dynamic>> get likedNotifications {
    return allNotifications.where((n) => n['isLiked'] == true).take(2).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final cardColor = Theme.of(context).cardColor;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Header
                Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                // Events Section - Horizontal Scrollable
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upcoming Events',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to all events page
                      },
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          color: Color(0xFF7AB8F7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: upcomingEvents.length,
                    itemBuilder: (context, index) {
                      final event = upcomingEvents[index];
                      return EventCard(
                        title: event['title']!,
                        date: event['date']!,
                        time: event['time']!,
                        location: event['location']!,
                        color: event['color']!,
                      );
                    },
                  ),
                ),
                
                SizedBox(height: screenHeight * 0.03),

                // Notifications Section - Side by Side
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // High Priority Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                            'Priority',
                            Icons.priority_high,
                            Colors.red,
                            onTap: () => _navigateToNotifications(1),
                          ),
                          const SizedBox(height: 12),
                          if (highPriorityNotifications.isEmpty)
                            _buildEmptyState('No priority alerts')
                          else
                            ...highPriorityNotifications.map((notification) =>
                                _buildCompactNotificationCard(notification, isCompact: true)
                            ).toList(),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Interested Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                            'Interested',
                            Icons.favorite,
                            Colors.pink,
                            onTap: () => _navigateToNotifications(2),
                          ),
                          const SizedBox(height: 12),
                          if (likedNotifications.isEmpty)
                            _buildEmptyState('No liked items')
                          else
                            ...likedNotifications.map((notification) =>
                                _buildCompactNotificationCard(notification, isCompact: true)
                            ).toList(),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToNotifications(int tabIndex) {
    // Use callback if provided (when in navigation), otherwise push new page
    if (widget.onNavigateToNotifications != null) {
      widget.onNavigateToNotifications!(tabIndex);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NotificationsPage(initialTab: tabIndex),
        ),
      );
    }
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          if (onTap != null)
            Icon(Icons.arrow_forward_ios, color: color, size: 18),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCompactNotificationCard(Map<String, dynamic> notification, {bool isCompact = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NotificationDetailsPage(
              title: notification['title']!,
              date: notification['date']!,
              message: notification['message']!,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    notification['title']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: textColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (notification['isLiked'])
                  const Icon(Icons.favorite, color: Colors.red, size: 14),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              notification['date']!,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              notification['message']!,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
