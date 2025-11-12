import 'package:flutter/foundation.dart';
// import '../services/supabase_service.dart'; // Commented out - will implement later

class ClassroomProvider with ChangeNotifier {
  List<Map<String, dynamic>> _classrooms = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get classrooms => _classrooms;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get available classrooms for specific date and time from Supabase
  Future<void> getAvailableClassrooms(DateTime date, String timeSlot) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement when classroom booking is needed
      // _classrooms = await SupabaseService.getClassrooms(
      //   date: date,
      //   timeSlot: timeSlot,
      // );
      _classrooms = []; // Return empty for now
    } catch (e) {
      _error = e.toString();
      _classrooms = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Book a classroom with Supabase
  Future<bool> bookClassroom({
    required String classroomId,
    required DateTime date,
    required String timeSlot,
    required String userId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement when classroom booking is needed
      // await SupabaseService.bookClassroom(
      //   classroomId: classroomId,
      //   date: date,
      //   timeSlot: timeSlot,
      //   userId: userId,
      // );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
