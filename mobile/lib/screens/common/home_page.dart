import 'package:flutter/material.dart';
import '../../services/supabase_service.dart'; // Import your service
import '../../widgets/event_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  final Function(int)? onNavigateToNotifications;
  
  const HomePage({Key? key, this.onNavigateToNotifications}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Dynamic Events Future
  late Future<List<Map<String, dynamic>>> _eventsFuture;
  late Future<List<Map<String, dynamic>>> _alertsFuture;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _eventsFuture = SupabaseService.getGlobalEvents();
    _alertsFuture = _fetchRecentAlerts();
  }

  Future<List<Map<String, dynamic>>> _fetchRecentAlerts() async {
    final data = await supabase
        .from('alerts')
        .select()
        .order('created_at', ascending: false)
        .limit(3);
    return List<Map<String, dynamic>>.from(data);
  }

  // Helper to format date strings from "2025-11-20" to "Nov 20"
  String _formatDate(String dateStr) {
    try {
      DateTime date = DateTime.parse(dateStr);
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return "${months[date.month - 1]} ${date.day}, ${date.year}";
    } catch (e) {
      return dateStr;
    }
  }

  // Card Colors to cycle through
  final List<Color> _cardColors = const [
    Color(0xFF7AB8F7),
    Color(0xFF9B59B6),
    Color(0xFFE74C3C),
    Color(0xFFF39C12),
  ];

  // Sample notifications data - KEPT HARDCODED AS REQUESTED
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1A1A1A),
                    const Color(0xFF2A2A2A),
                    const Color(0xFF3A3A3A),
                  ]
                : [
                    const Color(0xFFFFF9F0),
                    const Color(0xFFF5E6D3),
                    const Color(0xFFE8D5C4),
                  ],
          ),
        ),
        child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dashboard header - maroon in light mode, creamy in dark mode
                Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFFF5E6D3) : const Color(0xFF8B1538),
                    fontFamily: 'serif',
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                // Events Section - DYNAMIC via Supabase
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upcoming Events',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFFF5E6D3) : textColor,
                        fontFamily: 'serif',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to all events page if needed
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
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _eventsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error loading events"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("No upcoming events"));
                      }

                      final events = snapshot.data!;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          // Cycle through colors
                          final color = _cardColors[index % _cardColors.length];
                          
                          return EventCard(
                            title: event['title'] ?? 'No Title',
                            date: _formatDate(event['start_date'] ?? ''),
                            time: 'All Day', // We didn't store time in DB, so defaulting
                            location: 'Campus', // We didn't store loc in DB, so defaulting
                            color: color,
                          );
                        },
                      );
                    },
                  ),
                ),
                
                SizedBox(height: screenHeight * 0.03),

                // Recent Notifications from Alerts
                GestureDetector(
                  onTap: () {
                    // Use the callback to switch to notifications tab
                    if (widget.onNavigateToNotifications != null) {
                      widget.onNavigateToNotifications!(1);
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        'Notifications',
                        Icons.notifications,
                        const Color(0xFF8B1538),
                        onTap: () {
                          // Use the callback to switch to notifications tab
                          if (widget.onNavigateToNotifications != null) {
                            widget.onNavigateToNotifications!(1);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _alertsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                            return _buildEmptyState('No recent notifications');
                          }
                          return Column(
                            children: snapshot.data!.map((alert) => _buildAlertCard(alert)).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        ), // End of SafeArea
      ), // End of Container body
    ); // End of Scaffold
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getTypeColor(alert['type'] ?? 'general'),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.notifications, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert['title'] ?? 'No Title',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  alert['description'] ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'urgent':
        return Colors.red;
      case 'important':
        return Colors.orange;
      case 'circular':
        return Colors.blue;
      default:
        return Colors.green;
    }
  }

  static const Color _kMaroon = Color(0xFF8B1538);

  Widget _buildSectionHeader(String title, IconData icon, Color color, {VoidCallback? onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                  color: isDark ? const Color(0xFFF5E6D3) : _kMaroon,
                  fontFamily: 'serif',
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
}

class NotificationDetailsPage extends StatelessWidget {
  final String title;
  final String date;
  final String message;

  const NotificationDetailsPage({
    Key? key,
    required this.title,
    required this.date,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              date,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}