import 'package:flutter/foundation.dart';
// import '../services/supabase_service.dart'; // Commented out - will implement later

class EventProvider with ChangeNotifier {
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch events from Supabase
  Future<void> fetchEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement when events feature is needed
      // _events = await SupabaseService.getEvents();
      _events = []; // Return empty for now
    } catch (e) {
      _error = e.toString();
      _events = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create event (for admin/teachers)
  Future<void> createEvent({
    required String title,
    required String description,
    required DateTime date,
    String? imageUrl,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement when events feature is needed
      // await SupabaseService.createEvent(
      //   title: title,
      //   description: description,
      //   date: date,
      //   imageUrl: imageUrl,
      // );
      // Refresh events after creating
      await fetchEvents();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
