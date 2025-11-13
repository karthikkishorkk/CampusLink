import 'package:flutter/material.dart';
import 'post_assignment_page.dart';
import 'manage_assignments_page.dart';

class TeacherActionsPage extends StatefulWidget {
  const TeacherActionsPage({Key? key}) : super(key: key);

  @override
  State<TeacherActionsPage> createState() => _TeacherActionsPageState();
}

class _TeacherActionsPageState extends State<TeacherActionsPage> {
  DateTime? selectedDate;
  String? selectedTimeSlot;
  String? selectedClassroom;

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

  final List<String> classrooms = [
    'S001', 'S002', 'S003', 'S004', 'S005', 'S006',
    'S007', 'S008', 'S009', 'S010', 'S011', 'S012',
    'N001', 'N002', 'N003', 'N004', 'N005', 'N006',
    'N007', 'N008', 'N009', 'N010', 'N011', 'N012',
  ];

  void _showBookingDialog(BuildContext context) {
    setState(() {
      selectedDate = null;
      selectedTimeSlot = null;
      selectedClassroom = null;
    });

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7AB8F7).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.meeting_room,
                    color: Color(0xFF7AB8F7),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Book Classroom',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Selection
                  const Text(
                    'Select Date',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
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
                        setDialogState(() {
                          selectedDate = picked;
                        });
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Color(0xFF7AB8F7), size: 20),
                          const SizedBox(width: 12),
                          Text(
                            selectedDate != null
                                ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                : 'Select date',
                            style: TextStyle(
                              fontSize: 16,
                              color: selectedDate != null ? const Color(0xFF2C3E50) : Colors.grey.shade500,
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
                  const Text(
                    'Select Time Slot',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
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
                          setDialogState(() {
                            selectedTimeSlot = value;
                          });
                          setState(() {
                            selectedTimeSlot = value;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Classroom Selection
                  const Text(
                    'Select Classroom',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text(
                          'Select classroom',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        value: selectedClassroom,
                        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF7AB8F7)),
                        items: classrooms.map((classroom) {
                          return DropdownMenuItem<String>(
                            value: classroom,
                            child: Row(
                              children: [
                                const Icon(Icons.meeting_room, color: Color(0xFF7AB8F7), size: 20),
                                const SizedBox(width: 12),
                                Text(classroom),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            selectedClassroom = value;
                          });
                          setState(() {
                            selectedClassroom = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: (selectedDate != null && selectedTimeSlot != null && selectedClassroom != null)
                    ? () {
                        _submitBookingRequest(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7AB8F7),
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'Submit Request',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _submitBookingRequest(BuildContext context) {
    // TODO: Send booking request to backend
    Navigator.pop(context); // Close the dialog
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Booking Request Submitted!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Classroom: $selectedClassroom • ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Quick Actions',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What would you like to do?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: screenWidth * 0.05),
            
            // Book Classroom Card
            _buildActionCard(
              context: context,
              icon: Icons.meeting_room,
              iconColor: const Color(0xFF7AB8F7),
              title: 'Book Classroom',
              description: 'Reserve a classroom for your lecture or event',
              onTap: () {
                _showBookingDialog(context);
              },
            ),
            
            SizedBox(height: screenWidth * 0.04),

            // Post Assignments Card
            _buildActionCard(
              context: context,
              icon: Icons.assignment_turned_in, // Changed
              iconColor: const Color(0xFF1ABC9C), // Changed
              title: 'Post Assignments', // Changed
              description: 'Upload course material or assignments', // Changed
              onTap: () {
                // Navigate to the new page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PostAssignmentPage()),
                );
              },
            ),

            SizedBox(height: screenWidth * 0.04),

            // Manage Assignments Card
            _buildActionCard(
              context: context,
              icon: Icons.edit_document,
              iconColor: const Color(0xFF3498DB), // A different blue
              title: 'Manage Assignments',
              description: 'Delete or edit your posted assignments',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageAssignmentsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
