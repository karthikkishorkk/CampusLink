// lib/screens/common/classroom_finder_page.dart
import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../student/classroom_details_page.dart'; // <--- THIS IS THE FIX

class ClassroomFinderPage extends StatefulWidget {
  const ClassroomFinderPage({Key? key}) : super(key: key);

  @override
  State<ClassroomFinderPage> createState() => _ClassroomFinderPageState();
}

class _ClassroomFinderPageState extends State<ClassroomFinderPage> {
  late DateTime selectedDate;
  String? selectedTimeSlot;
  bool showFilterSection = false;

  late Future<List<Map<String, dynamic>>> _classroomsFuture;

  final List<Map<String, String>> timeSlots = [
    {'start': '9:00', 'end': '9:50'},
    {'start': '9:50', 'end': '10:40'},
    {'start': '10:50', 'end': '11:40'},
    {'start': '11:40', 'end': '12:30'},
    {'start': '12:30', 'end': '1:20'},
    {'start': '1:20', 'end': '2:10'},
    {'start': '2:10', 'end': '3:00'},
    {'start': '3:10', 'end': '4:00'},
    {'start': '4:00', 'end': '5:00'},
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;
    const cutoffMinutes = 13 * 60 + 20; // 13:20

    if (nowMinutes >= cutoffMinutes) {
      selectedDate = now.add(const Duration(days: 1));
      selectedTimeSlot = '${timeSlots.first['start']} - ${timeSlots.first['end']}';
    } else {
      selectedDate = now;
      selectedTimeSlot = _getCurrentTimeSlot() ?? '${timeSlots.first['start']} - ${timeSlots.first['end']}';
    }
    
    _loadAvailableClassrooms();
  }

  void _loadAvailableClassrooms() {
    if (selectedTimeSlot == null) return;
    setState(() {
      _classroomsFuture = SupabaseService.getAvailableClassrooms(
        date: selectedDate,
        timeSlot: selectedTimeSlot!,
      );
    });
  }

  String? _getCurrentTimeSlot() {
    final now = TimeOfDay.now();
    final currentMinutes = now.hour * 60 + now.minute;

    for (var slot in timeSlots) {
      final startParts = slot['start']!.split(':');
      final startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
      final endParts = slot['end']!.split(':');
      final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

      if (currentMinutes >= startMinutes && currentMinutes < endMinutes) {
        return '${slot['start']} - ${slot['end']}';
      }
    }
    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
       builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7AB8F7),
              onPrimary: Colors.white,
              onSurface: Color(0xFF2C3E50),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _loadAvailableClassrooms(); 
      });
    }
  }

  void _searchClassrooms() {
    if (selectedTimeSlot != null) {
      _loadAvailableClassrooms();
      setState(() {
        showFilterSection = false; 
      });
    }
  }

  String _formatDate(DateTime date) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    
    if (date.year == today.year && date.month == today.month && date.day == today.day) {
      return 'Today';
    } else if (date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final cardColor = Theme.of(context).cardColor;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1A1A1A),
                    const Color(0xFF2A2A2A),
                    const Color(0xFF3A3A3A),
                  ]
                : [
                    const Color(0xFFFFF9F0),
                    const Color(0xFFF5E6D3),
                    const Color(0xFFE8D5C4),
                  ],
          ),
        ),
        child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Row(
                children: [
                  Text(
                    'Classrooms',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? const Color(0xFFF5E6D3) : const Color(0xFF8B1538),
                      fontFamily: 'serif',
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showFilterSection = !showFilterSection;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7AB8F7), Color(0xFF9EC8FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.calendar_today, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        _formatDate(selectedDate),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'Tap to change',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    selectedTimeSlot ?? 'Select time slot',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              showFilterSection ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 28,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    if (showFilterSection) Container(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Filter Classrooms',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: textColor),
                                onPressed: () {
                                  setState(() {
                                    showFilterSection = false;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text('Change Date', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor)),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey.shade800 : const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today, color: Color(0xFF7AB8F7), size: 20),
                                  const SizedBox(width: 12),
                                  Text(
                                    '${_formatDate(selectedDate)} - ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                    style: TextStyle(fontSize: 16, color: textColor),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.arrow_drop_down, color: Color(0xFF7AB8F7)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text('Change Time Slot', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey.shade800 : const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Text('Select time slot', style: TextStyle(color: Colors.grey.shade500)),
                                value: selectedTimeSlot,
                                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF7AB8F7)),
                                items: timeSlots.map((slot) {
                                  final String timeRange = '${slot['start']} - ${slot['end']}';
                                  return DropdownMenuItem<String>(
                                    value: timeRange,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.access_time, color: Color(0xFF7AB8F7), size: 20),
                                        const SizedBox(width: 12),
                                        Text(timeRange),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedTimeSlot = value;
                                  });
                                  _loadAvailableClassrooms(); 
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: selectedTimeSlot != null ? _searchClassrooms : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7AB8F7),
                                disabledBackgroundColor: Colors.grey.shade300,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.check_circle, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Apply Filter',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: selectedTimeSlot != null ? Colors.white : Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _classroomsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text("Error loading classrooms"));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("No available classrooms found for this slot."));
                        }

                        final freeClassrooms = snapshot.data!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  '${freeClassrooms.length} Available Classrooms',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.0,
                              ),
                              itemCount: freeClassrooms.length,
                              itemBuilder: (context, index) {
                                final classroom = freeClassrooms[index];
                                final classroomName = classroom['room_no'];
                                return _buildClassroomCard(
                                  classroomName: classroomName,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ClassroomDetailsPage(
                                          classroomName: classroomName,
                                          // Note: This details page doesn't accept date/time
                                          // It's a general info page, which is fine for students.
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        ), // End of SafeArea
      ), // End of Container
    ); // End of Scaffold
  }

  Widget _buildClassroomCard({required String classroomName, required VoidCallback onTap}) {
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    
    return InkWell( 
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF7AB8F7).withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.meeting_room,
              color: Color(0xFF7AB8F7),
              size: 32,
            ),
            const SizedBox(height: 6),
            Text(
              classroomName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Available',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}