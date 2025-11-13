// lib/screens/teacher/manage_event_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/supabase_service.dart';
import 'create_event_page.dart'; // Import the create page

class ManageEventPage extends StatefulWidget {
  const ManageEventPage({Key? key}) : super(key: key);

  @override
  _ManageEventPageState createState() => _ManageEventPageState();
}

class _ManageEventPageState extends State<ManageEventPage> {
  late Future<List<Map<String, dynamic>>> _eventsFuture;
  late String _teacherId;

  @override
  void initState() {
    super.initState();
    _teacherId = Provider.of<UserProvider>(context, listen: false).userId ?? '';
    _loadEvents();
  }

  void _loadEvents() {
    setState(() {
      _eventsFuture = SupabaseService.getEventsByTeacher(_teacherId);
    });
  }

  Future<void> _deleteEvent(String eventId) async {
    // Show confirmation dialog
    bool? shouldDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event?'),
        content: const Text('This will permanently delete the event. This action cannot be undone.'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        await SupabaseService.deleteEvent(eventId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event deleted successfully'), backgroundColor: Colors.green),
        );
        _loadEvents(); // Refresh the list
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting event: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Manage Events', style: TextStyle(color: Color(0xFF2C3E50), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2C3E50)),
        actions: [
          // Pencil Icon to create new event
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF2C3E50)), // Using 'add' as it's more common than pencil
            onPressed: () async {
              // Navigate to create page and refresh when popped
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateEventPage()),
              );
              // When we come back from the create page, reload events
              _loadEvents();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final events = snapshot.data;
          if (events == null || events.isEmpty) {
            return const Center(
              child: Text(
                'You have not posted any events.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return _buildEventCard(event);
            },
          );
        },
      ),
    );
  }

  // Card UI similar to Manage Assignments
  Widget _buildEventCard(Map<String, dynamic> event) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF9B59B6), // Purple for events
          child: Icon(Icons.event, color: Colors.white),
        ),
        title: Text(
          event['title'] ?? 'No Title',
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          'Date: ${event['start_date'] ?? 'N/A'}',
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _deleteEvent(event['id'].toString()),
        ),
      ),
    );
  }
}