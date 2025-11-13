import 'package:flutter/material.dart';

class ClassroomFinderPage extends StatefulWidget {
  const ClassroomFinderPage({Key? key}) : super(key: key);

  @override
  State<ClassroomFinderPage> createState() => _ClassroomFinderPageState();
}

class _ClassroomFinderPageState extends State<ClassroomFinderPage> {
  late DateTime selectedDate;
  String? selectedTimeSlot;
  bool showResults = true; // Show results by default
  bool showFilterSection = false; // Filter section collapsed by default

  // Define time slots first before initState
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
    // Set today's date and current time slot by default based on device time
    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;
    const cutoffMinutes = 13 * 60 + 20; // 13:20
    if (nowMinutes >= cutoffMinutes) {
      selectedDate = now.add(const Duration(days: 1));
      if (timeSlots.isNotEmpty) {
        final first = timeSlots.first;
        selectedTimeSlot = '${first['start']} - ${first['end']}';
      } else {
        selectedTimeSlot = null;
      }
    } else {
      selectedDate = now;
      selectedTimeSlot = _getCurrentTimeSlot();
    }
  }

  // Get current time slot based on device time
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

    // If current time is past cutoff (1:20 PM), return null so caller can advance date
    const cutoffMinutes = 13 * 60 + 20;
    if (currentMinutes >= cutoffMinutes) return null;

    // Otherwise return first slot as default
    if (timeSlots.isNotEmpty) {
      final firstSlot = timeSlots.first;
      return '${firstSlot['start']} - ${firstSlot['end']}';
    }

    return null;
  }

  // Sample data - in real app, this would come from backend based on date/time
  // This simulates which classrooms are free for the selected slot
  Map<String, bool> allClassrooms = {
    'S001': false,
    'S002': true,
    'S003': false,
    'S004': false,
    'S005': true,
    'S006': false,
    'S007': true,
    'S008': false,
    'S009': false,
    'S010': true,
    'S011': false,
    'S012': false,
    'N001': false,
    'N002': true,
    'N003': false,
    'N004': true,
    'N005': false,
    'N006': false,
    'N007': true,
    'N008': false,
    'N009': true,
    'N010': false,
    'N011': false,
    'N012': true,
  };

  List<String> get freeClassrooms {
    return allClassrooms.entries
        .where((entry) => !entry.value) // Only free classrooms
        .map((entry) => entry.key)
        .toList();
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
        showResults = true; // Show results immediately
      });
    }
  }

  void _searchClassrooms() {
    if (selectedTimeSlot != null) {
      setState(() {
        showResults = true;
        showFilterSection = false; // Collapse filter after search
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
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title (filter removed)
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Row(
                children: [
                  Text(
                    'Classrooms',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: textColor,
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
                    // Current Date and Time Info (Tappable to change)
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

                    // Filter/Search Section (Collapsible)
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

                          // Date Selection
                          Text(
                            'Change Date',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
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
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: textColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.arrow_drop_down, color: Color(0xFF7AB8F7)),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Time Slot Selection
                          Text(
                            'Change Time Slot',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
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
                                hint: Text(
                                  'Select time slot',
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
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
                                    showResults = true; // Show results immediately
                                  });
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Apply Filter Button
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
                                      color: selectedTimeSlot != null
                                          ? Colors.white
                                          : Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Results Section
                    if (showResults) ...[
                      const SizedBox(height: 24),
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

                      // Available Classrooms Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: freeClassrooms.length,
                        itemBuilder: (context, index) {
                          return _buildClassroomCard(freeClassrooms[index]);
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassroomCard(String classroomName) {
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    
    return Container(
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
    );
  }
}
