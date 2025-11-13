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
    // Get all classrooms
    final allClassrooms = await client
        .from('classrooms')
        .select()
        .eq('status', 'Available');
    
    // Get bookings for the specified date and time
    final bookings = await client
        .from('bookings')
        .select('room')
        .eq('date', date.toIso8601String().split('T')[0])
        .eq('time_slot', timeSlot)
        .eq('status', 'Approved');
    
    final bookedRooms = (bookings as List).map((b) => b['room']).toSet();
    
    // Filter out booked classrooms
    final available = (allClassrooms as List).where((classroom) {
      return !bookedRooms.contains(classroom['room_no']);
    }).toList();
    
    return List<Map<String, dynamic>>.from(available);
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
    });
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
}
