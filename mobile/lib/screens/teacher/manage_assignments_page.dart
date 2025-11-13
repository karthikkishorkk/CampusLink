// lib/screens/teacher/manage_assignments_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/supabase_service.dart';

class ManageAssignmentsPage extends StatefulWidget {
  const ManageAssignmentsPage({Key? key}) : super(key: key);

  @override
  _ManageAssignmentsPageState createState() => _ManageAssignmentsPageState();
}

class _ManageAssignmentsPageState extends State<ManageAssignmentsPage> {
  late Future<List<Map<String, dynamic>>> _assignmentsFuture;

  @override
  void initState() {
    super.initState();
    _fetchAssignments();
  }

  void _fetchAssignments() {
    final teacherId = Provider.of<UserProvider>(context, listen: false).userId;
    if (teacherId != null) {
      _assignmentsFuture = SupabaseService.getAssignmentsByTeacher(teacherId);
    }
  }

  // Show confirmation dialog before deleting
  Future<void> _confirmDelete(String documentId, String filePath) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Assignment?'),
          content: const Text('This will permanently delete the file and assignment. This action cannot be undone.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close the dialog
                await _deleteAssignment(documentId, filePath);
              },
            ),
          ],
        );
      },
    );
  }

  // Call the service and refresh the list
  Future<void> _deleteAssignment(String documentId, String filePath) async {
    try {
      await SupabaseService.deleteAssignment(
        documentId: documentId,
        filePath: filePath,
      );
      
      // Refresh the list
      setState(() {
        _fetchAssignments();
      });

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Delete failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF2C3E50)),
        title: const Text(
          'Manage Assignments',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _assignmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'You have not posted any assignments.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          final assignments = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              final doc = assignments[index];
              
              // Safely get ID and convert to String
              final String docId = doc['id']?.toString() ?? '';
              final String filePath = doc['file_path']?.toString() ?? '';

              // If either is missing, don't show the delete button (or show disabled)
              final bool canDelete = docId.isNotEmpty && filePath.isNotEmpty;

              return Card(
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
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    doc['category'] ?? 'No caption',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  trailing: canDelete ? IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () {
                      _confirmDelete(docId, filePath);
                    },
                  ) : const Icon(Icons.error_outline, color: Colors.grey), // Show error icon if data missing
                ),
              );
            },
          );
        },
      ),
    );
  }
}