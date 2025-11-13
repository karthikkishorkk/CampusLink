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
  
  // Database helpers
  static Future<List<Map<String, dynamic>>> getClassrooms({
    required DateTime date,
    required String timeSlot,
  }) async {
    final response = await client
        .from('classrooms')
        .select()
        .eq('date', date.toIso8601String())
        .eq('time_slot', timeSlot);
    return List<Map<String, dynamic>>.from(response);
  }
  
  static Future<void> bookClassroom({
    required String classroomId,
    required DateTime date,
    required String timeSlot,
    required String userId,
  }) async {
    await client.from('bookings').insert({
      'classroom_id': classroomId,
      'date': date.toIso8601String(),
      'time_slot': timeSlot,
      'user_id': userId,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
  
  static Future<List<Map<String, dynamic>>> getNotifications({
    String? userId,
    bool? isPriority,
  }) async {
    var query = client.from('notifications').select();
    
    if (userId != null) {
      query = query.eq('user_id', userId);
    }
    
    if (isPriority != null) {
      query = query.eq('is_priority', isPriority);
    }
    
    final response = await query.order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }
  
  static Future<List<Map<String, dynamic>>> getEvents() async {
    final response = await client
        .from('events')
        .select()
        .order('date', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }
  
  static Future<void> createEvent({
    required String title,
    required String description,
    required DateTime date,
    String? imageUrl,
  }) async {
    await client.from('events').insert({
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'image_url': imageUrl,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
  
  static Future<void> postNotification({
    required String title,
    required String message,
    required bool isPriority,
    String? userId,
  }) async {
    await client.from('notifications').insert({
      'title': title,
      'message': message,
      'is_priority': isPriority,
      'user_id': userId,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
}
