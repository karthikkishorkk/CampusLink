import 'package:flutter/foundation.dart';
// import '../services/supabase_service.dart'; // Commented out - will implement later

class NotificationProvider with ChangeNotifier {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  List<Map<String, dynamic>> get highPriorityNotifications =>
      _notifications.where((n) => n['is_priority'] == true).toList();
  
  List<Map<String, dynamic>> get likedNotifications =>
      _notifications.where((n) => n['is_liked'] == true).toList();

  // Fetch notifications from Supabase
  Future<void> fetchNotifications({String? userId, bool? isPriority}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement when notifications feature is needed
      // _notifications = await SupabaseService.getNotifications(
      //   userId: userId,
      //   isPriority: isPriority,
      // );
      _notifications = []; // Return empty for now
    } catch (e) {
      _error = e.toString();
      _notifications = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle like/unlike (update in Supabase)
  void toggleLike(String id) {
    final index = _notifications.indexWhere((n) => n['id'] == id);
    if (index != -1) {
      _notifications[index]['is_liked'] = !(_notifications[index]['is_liked'] ?? false);
      notifyListeners();
      // TODO: Update in Supabase
    }
  }

  // Post notification (for teachers/admin)
  Future<void> postNotification({
    required String title,
    required String message,
    required bool isPriority,
    String? userId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement when notifications feature is needed
      // await SupabaseService.postNotification(
      //   title: title,
      //   message: message,
      //   isPriority: isPriority,
      //   userId: userId,
      // );
      // Refresh notifications after posting
      await fetchNotifications(userId: userId);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
