import 'package:flutter/material.dart';
import 'post_assignment_page.dart';
import 'manage_assignments_page.dart';
import 'manage_event_page.dart';
import 'classroom_finder_page.dart';

class TeacherActionsPage extends StatefulWidget {
  const TeacherActionsPage({Key? key}) : super(key: key);

  @override
  State<TeacherActionsPage> createState() => _TeacherActionsPageState();
}

class _TeacherActionsPageState extends State<TeacherActionsPage> {
  // 2. ALL DIALOG CODE AND VARIABLES (selectedDate, timeSlots, etc.) ARE REMOVED.
  //    _showBookingDialog and _submitBookingRequest are also gone.

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page Title
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      color: isDark ? const Color(0xFFF5E6D3) : const Color(0xFF8B1538),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'serif',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'What would you like to do?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.05),
            
            // 3. UPDATED BOOK CLASSROOM CARD
            _buildActionCard(
              context: context,
              icon: Icons.meeting_room,
              iconColor: const Color(0xFF7AB8F7),
              title: 'Book Classroom',
              description: 'Find and reserve an available classroom', // Updated description
              onTap: () {
                // 4. NAVIGATE to the finder page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ClassroomFinderPage()),
                );
              },
            ),
            
            SizedBox(height: screenWidth * 0.04),

            // Post Assignments Card (No changes)
            _buildActionCard(
              context: context,
              icon: Icons.assignment_turned_in,
              iconColor: const Color(0xFF1ABC9C),
              title: 'Post Assignments',
              description: 'Upload course material or assignments',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PostAssignmentPage()),
                );
              },
            ),

            SizedBox(height: screenWidth * 0.04),

            // Manage Assignments Card (No changes)
            _buildActionCard(
              context: context,
              icon: Icons.edit_document,
              iconColor: const Color(0xFF3498DB),
              title: 'Manage Assignments',
              description: 'Delete or edit your posted assignments',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageAssignmentsPage()),
                );
              },
            ),

            SizedBox(height: screenWidth * 0.04),

            // Manage Events Card (No changes)
            _buildActionCard(
              context: context,
              icon: Icons.event,
              iconColor: const Color(0xFF9B59B6),
              title: 'Manage Events',
              description: 'Post new events or delete old ones',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageEventPage()),
                );
              },
            ),
          ],
        ),
            ),
          ),
        ),
      ), // End of Container
    ); // End of Scaffold
  }

  // _buildActionCard helper function (No changes)
  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}