import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // Get Supabase client instance
  static SupabaseClient get client => Supabase.instance.client;
  
  // Auth helpers
  static User? get currentUser => client.auth.currentUser;
  static bool get isLoggedIn => currentUser != null;
  
  // Sign in with email and password
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  // Sign up with email and password
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: metadata,
    );
  }
  
  // Sign out
  static Future<void> signOut() async {
    await client.auth.signOut();
  }
  
  // Get auth state changes stream
  static Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
  
  // User Management
  static Future<Map<String, dynamic>?> getStudentByEmail(String email) async {
    final response = await client
        .from('students')
        .select()
        .eq('email', email)
        .maybeSingle();
    return response;
  }
  
  static Future<Map<String, dynamic>?> getTeacherByEmail(String email) async {
    final response = await client
        .from('teachers')
        .select()
        .eq('email', email)
        .maybeSingle();
    return response;
  }
  
  static Future<void> createStudent({
    required String rollNo,
    required String name,
    required String branch,
    required String email,
  }) async {
    await client.from('students').insert({
      'roll_no': rollNo,
      'name': name,
      'branch': branch,
      'email': email,
      'status': 'Active',
    });
  }
  
  static Future<void> createTeacher({
    required String id,
    required String tid,
    required String name,
    required String branch,
    required String email,
  }) async {
    await client.from('teachers').insert({
      'id': id,
      'tid': tid,
      'name': name,
      'branch': branch,
      'email': email,
      'status': 'Active',
    });
  }
  
  // Classroom Management
  static Future<List<Map<String, dynamic>>> getAllClassrooms() async {
    final response = await client
        .from('classrooms')
        .select()
        .order('building');
    return List<Map<String, dynamic>>.from(response);
  }
  
  static Future<List<Map<String, dynamic>>> getAvailableClassrooms({
    required DateTime date,
    required String timeSlot,
  }) async {
    
    // 1. Get ALL classrooms
    final allClassroomsResponse = await client
        .from('classrooms')
        .select(); // Semicolon was missing here before

    // Cast the response to a List
    final allClassrooms = List<Map<String, dynamic>>.from(allClassroomsResponse);

    // 2. Get all bookings that are 'Pending' OR 'Approved'
    final bookingsResponse = await client
        .from('bookings')
        .select('room')
        .eq('date', date.toIso8601String().split('T')[0])
        .eq('time_slot', timeSlot)
        // 
        // THIS IS THE FIX:
        //
        .inFilter('status', ['Pending', 'Approved']); // Use .inFilter instead of .in_

    // 3. Cast the bookings response
    final bookedRooms = (bookingsResponse as List).map((b) => b['room']).toSet();
    
    // 4. Filter the full list
    final available = allClassrooms.where((classroom) {
      return !bookedRooms.contains(classroom['room_no']);
    }).toList();
    
    return available;
  }
  
  // Booking Management
  static Future<void> createBooking({
    required String teacherId,
    required String room,
    required DateTime date,
    required String timeSlot,
    String? purpose,
  }) async {
    await client.from('bookings').insert({
      'teacher_id': teacherId,
      'room': room,
      'date': date.toIso8601String().split('T')[0],
      'time_slot': timeSlot,
      'purpose': purpose,
      'status': 'Pending',
    });
  }
  
  static Future<List<Map<String, dynamic>>> getTeacherBookings(String teacherId) async {
    final response = await client
        .from('bookings')
        .select('*, teachers(*)')
        .eq('teacher_id', teacherId)
        .order('date', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }
  
  static Future<List<Map<String, dynamic>>> getAllBookings() async {
    final response = await client
        .from('bookings')
        .select('*, teachers(*)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }
  
  // Alerts Management
  static Future<List<Map<String, dynamic>>> getAlerts({String? type}) async {
    var query = client.from('alerts').select('*, admins(name)');
    
    if (type != null) {
      query = query.eq('type', type);
    }
    
    final response = await query.order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }
  
  static Future<List<Map<String, dynamic>>> getActiveAlerts() async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final response = await client
        .from('alerts')
        .select('*, admins(name)')
        .lte('start_date', today)
        .gte('end_date', today)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }
  
  static Future<void> createAlert({
    required String title,
    required String description,
    required String type,
    required DateTime startDate,
    required DateTime endDate,
    required String postedBy,
    String? fileUrl,
  }) async {
    await client.from('alerts').insert({
      'title': title,
      'description': description,
      'type': type,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate.toIso8601String().split('T')[0],
      'file_url': fileUrl,
      'posted_by': postedBy,
    });
  }
  
  // Documents Management
  static Future<void> uploadAssignment({
    required File file,
    required String title,
    required String caption, // Using 'category' field for this
    required String branch,
    required String teacherId,
  }) async {
    // 1. Create a unique file path
    final fileExtension = file.path.split('.').last;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
    final filePath = '$branch/$fileName';

    // 2. Upload the file to Supabase Storage
    //    (You'll need to create a 'assignments' bucket in Supabase Storage)
    await client.storage.from('assignments').upload(
          filePath,
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );

    // 3. Get the public URL
    final fileUrl = client.storage.from('assignments').getPublicUrl(filePath);

    // 4. Insert the record into the 'documents' table
    await client.from('documents').insert({
      'name': title,
      'category': caption, // Using 'category' field for caption as planned
      'file_url': fileUrl,
      'uploaded_by': teacherId, // This now correctly points to a teacher's ID
      'branch': branch, // The new branch field
      'file_path': filePath,
    });
  }

  static Future<List<Map<String, dynamic>>> getAssignmentsByTeacher(String teacherId) async {
    final response = await client
        .from('documents')
        .select() // Select all fields, including the new file_path
        .eq('uploaded_by', teacherId)
        .order('created_at', ascending: false);
        
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> deleteAssignment({
    required String documentId, // The 'id' of the row in the table
    required String filePath, // The 'file_path' we stored
  }) async {
    
    // Step 1: Delete the file from Storage
    await client.storage.from('assignments').remove([filePath]);

    // Step 2: Delete the record from the database
    await client.from('documents').delete().eq('id', documentId);
  }

  static Future<void> postEvent({
    required String title,
    required String description,
    required DateTime date,
    required String postedBy,
  }) async {
    await client.from('alerts').insert({
      'title': title,
      'description': description,
      'type': 'Event', // Differentiates this from Admin alerts
      'start_date': date.toIso8601String().split('T')[0],
      'end_date': date.toIso8601String().split('T')[0],
      'posted_by': postedBy,
      // 'created_at' is usually auto-generated by Supabase, so we can omit it if your DB is set up that way
    });
  }

  static Future<List<Map<String, dynamic>>> getGlobalEvents() async {
    final response = await client
        .from('alerts')
        .select()
        .eq('type', 'Event') // Only fetch events, not emergency alerts
        .gte('start_date', DateTime.now().toIso8601String().split('T')[0]) // Only upcoming events
        .order('start_date', ascending: true);
        
    return List<Map<String, dynamic>>.from(response);
  }

  // New function for students to get assignments for their branch
  static Future<List<Map<String, dynamic>>> getAssignmentsByBranch(
      String branch) async {
    final response = await client
        .from('documents')
        .select('*, teachers(name)') // Joins with teachers table to get name
        .eq('branch', branch)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  // GET Events posted by a specific teacher
  static Future<List<Map<String, dynamic>>> getEventsByTeacher(String teacherId) async {
    final response = await client
        .from('alerts')
        .select()
        .eq('type', 'Event') // We only want events
        .eq('posted_by', teacherId) // Only for this teacher
        .order('start_date', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // DELETE an event from the 'alerts' table by its ID
  static Future<void> deleteEvent(String eventId) async {
    // Events have no files, so we just delete the database row.
    await client
        .from('alerts')
        .delete()
        .eq('id', eventId);
  }

  static Future<void> updateUserProfile({
    required String userId,
    required String userType, // 'student' or 'teacher'
    required Map<String, dynamic> data,
  }) async {
    // Determine the correct table based on user type
    final table = userType == 'student' ? 'students' : 'teachers';
    
    await client
        .from(table)
        .update(data)
        .eq('id', userId); // Assumes 'id' is the UUID foreign key
  }

}
