// lib/screens/student/student_assignments_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // You will need to add url_launcher: ^6.0.0 to pubspec.yaml
import '../../providers/user_provider.dart';
import '../../services/supabase_service.dart';

class StudentAssignmentsPage extends StatefulWidget {
  const StudentAssignmentsPage({Key? key}) : super(key: key);

  @override
  _StudentAssignmentsPageState createState() => _StudentAssignmentsPageState();
}

class _StudentAssignmentsPageState extends State<StudentAssignmentsPage> {
  late Future<List<Map<String, dynamic>>> _assignmentsFuture;

  @override
  void initState() {
    super.initState();
    // Get the student's branch from UserProvider and fetch assignments
    // This will now work because we fixed the provider
    final studentBranch = Provider.of<UserProvider>(context, listen: false).userBranch;
    _assignmentsFuture = SupabaseService.getAssignmentsByBranch(studentBranch);
  }

  // Helper to launch URL
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      // Attempt to launch the URL in an external app
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        // If it fails, throw an error
        throw 'Could not launch $url';
      }
    } catch (e) {
      // Catch the error and show a snackbar
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open file. Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final cardColor = Theme.of(context).cardColor;
    
    // Use the same cream/dark gradient background as other pages and
    // make the AppBar transparent; title text will be maroon to match dashboard.
    return Scaffold(
      body: Container(
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
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Text(
                'Assignments',
                style: TextStyle(
                  color: isDark ? const Color(0xFFF5E6D3) : const Color(0xFF8B1538),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'serif',
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _assignmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'No assignments have been posted for your branch yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.grey, 
                    fontSize: 16
                  ),
                ),
              ),
            );
          }

          final assignments = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              final doc = assignments[index];
              final teacher = doc['teachers']; // Supabase join
              final teacherName = teacher != null ? teacher['name'] : 'Unknown';

              return Card(
                color: cardColor,
                margin: const EdgeInsets.only(bottom: 16.0),
                elevation: 2,
                shadowColor: Colors.black.withOpacity(0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF1ABC9C),
                    child: Icon(Icons.description, color: Colors.white),
                  ),
                  title: Text(
                    doc['name'] ?? 'No Title',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                  subtitle: Text(
                    'Posted by: $teacherName\n${doc['category'] ?? ''}',
                    style: TextStyle(
                      color: isDark ? Colors.grey.shade400 : Colors.black54,
                    ),
                  ),
                  trailing: const Icon(Icons.download_for_offline, color: Color(0xFF7AB8F7)),
                  onTap: () {
                    if (doc['file_url'] != null) {
                      _launchURL(doc['file_url']);
                    }
                  },
                ),
              );
            },
          );
        }, // end builder
      ), // end FutureBuilder
            ), // end Expanded
          ], // end Column children
        ), // end Column
      ), // end Container
    ); // End of Scaffold
  } // end build
} // end class