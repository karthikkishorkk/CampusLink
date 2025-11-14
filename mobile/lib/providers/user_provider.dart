import 'package:flutter/foundation.dart';
import '../services/supabase_service.dart';

class UserProvider with ChangeNotifier {
  String _role = 'student'; // 'student' or 'teacher'
  String _name = 'John Doe';
  String _email = '';
  String _rollNumber = '';
  String _userBranch = '';
  bool _isAuthenticated = false;
  String? _userId;

  // Getters
  String get role => _role;
  String get name => _name;
  String get email => _email;
  String get rollNumber => _rollNumber;
  String get userBranch => _userBranch;
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
        _userBranch = student['branch'];
      } else {
        final teacher = await SupabaseService.getTeacherByEmail(_email);
        if (teacher != null) {
          _role = 'teacher';
          _name = teacher['name'];
          _rollNumber = teacher['tid'];
          _userBranch = teacher['branch'];
        }
      }
      notifyListeners();
    }
  }

  // Load user from existing session
  Future<void> loadUserFromSession() async {
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
        _userBranch = student['branch'];
      } else {
        final teacher = await SupabaseService.getTeacherByEmail(_email);
        if (teacher != null) {
          _role = 'teacher';
          _name = teacher['name'];
          _rollNumber = teacher['tid'];
          _userBranch = teacher['branch'];
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
          _userBranch = student['branch'];
        } else {
          final teacher = await SupabaseService.getTeacherByEmail(email);
          if (teacher != null) {
            _role = 'teacher';
            _name = teacher['name'];
            _rollNumber = teacher['tid'];
            _userBranch = teacher['branch'];
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
            id: response.user!.id,
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
        _userBranch = branch ?? '';
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
    _userBranch = '';
    _userId = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  // Update profile
  Future<void> updateProfile({required String name}) async {
    if (_userId == null) throw Exception("User not logged in.");

    // 1. Call the new Supabase service
    await SupabaseService.updateUserProfile(
      userId: _userId!,
      userType: _role,
      data: {'name': name},
    );

    // 2. Update the local state
    _name = name;
    notifyListeners();
  }
}
