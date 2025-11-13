import 'package:flutter/foundation.dart';
import '../services/supabase_service.dart';

class UserProvider with ChangeNotifier {
  String _role = 'student'; // 'student' or 'teacher'
  String _name = 'John Doe';
  String _email = '';
  String _rollNumber = '';
  bool _isAuthenticated = false;
  String? _userId;

  // Getters
  String get role => _role;
  String get name => _name;
  String get email => _email;
  String get rollNumber => _rollNumber;
  bool get isAuthenticated => _isAuthenticated;
  bool get isTeacher => _role == 'teacher';
  bool get isStudent => _role == 'student';
  String? get userId => _userId;

  // Initialize auth state
  Future<void> initializeAuth() async {
    final user = SupabaseService.currentUser;
    if (user != null) {
      _userId = user.id;
      _email = user.email ?? '';
      _isAuthenticated = true;
      
      // Check if user is student or teacher
      final student = await SupabaseService.getStudentByEmail(_email);
      if (student != null) {
        _role = 'student';
        _name = student['name'];
        _rollNumber = student['roll_no'];
      } else {
        final teacher = await SupabaseService.getTeacherByEmail(_email);
        if (teacher != null) {
          _role = 'teacher';
          _name = teacher['name'];
          _rollNumber = teacher['tid'];
        }
      }
      notifyListeners();
    }
  }

  // Login with Supabase
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await SupabaseService.signIn(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        _userId = response.user!.id;
        _email = email;
        _isAuthenticated = true;
        
        // Get user details from students or teachers table
        final student = await SupabaseService.getStudentByEmail(email);
        if (student != null) {
          _role = 'student';
          _name = student['name'];
          _rollNumber = student['roll_no'];
        } else {
          final teacher = await SupabaseService.getTeacherByEmail(email);
          if (teacher != null) {
            _role = 'teacher';
            _name = teacher['name'];
            _rollNumber = teacher['tid'];
          } else {
            throw Exception('User not found in students or teachers table');
          }
        }
        
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Sign up with Supabase
  Future<void> signUp({
    required String role,
    required String name,
    required String email,
    required String password,
    required String idNumber, // roll_no for students, tid for teachers
    String? branch,
  }) async {
    try {
      // First create auth user
      final response = await SupabaseService.signUp(
        email: email,
        password: password,
        metadata: {
          'role': role,
          'name': name,
        },
      );
      
      if (response.user != null) {
        // Then create entry in students or teachers table
        if (role == 'student') {
          await SupabaseService.createStudent(
            rollNo: idNumber,
            name: name,
            branch: branch ?? '',
            email: email,
          );
        } else {
          await SupabaseService.createTeacher(
            tid: idNumber,
            name: name,
            branch: branch ?? '',
            email: email,
          );
        }
        
        _userId = response.user!.id;
        _role = role;
        _name = name;
        _email = email;
        _rollNumber = idNumber;
        _isAuthenticated = true;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    await SupabaseService.signOut();
    _role = 'student';
    _name = '';
    _email = '';
    _rollNumber = '';
    _userId = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  // Update profile
  void updateProfile({String? name, String? email}) {
    if (name != null) _name = name;
    if (email != null) _email = email;
    notifyListeners();
  }
}
