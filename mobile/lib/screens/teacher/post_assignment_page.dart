import 'dart:io'; // Used to store the file
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // To pick the file
import 'package:provider/provider.dart';      
import '../../providers/user_provider.dart';    
import '../../services/supabase_service.dart';

class PostAssignmentPage extends StatefulWidget {
  const PostAssignmentPage({Key? key}) : super(key: key);

  @override
  _PostAssignmentPageState createState() => _PostAssignmentPageState();
}

class _PostAssignmentPageState extends State<PostAssignmentPage> {
  final _titleController = TextEditingController();
  final _captionController = TextEditingController();
  File? _selectedFile;
  bool _isLoading = false;

  // Method to pick a file
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'png', 'jpg'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: ${e.toString()}')),
      );
    }
  }

  // Method to submit the assignment
  Future<void> _submitAssignment() async {
    if (_selectedFile == null || _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a title and select a file.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Get user data from Provider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final String teacherId = userProvider.userId ?? '';
      final String branch = userProvider.userBranch; // <-- Now this works!

      if (teacherId.isEmpty || branch.isEmpty) {
        throw Exception('User data not found. Please log in again.');
      }

      // 2. Call the new service function
      await SupabaseService.uploadAssignment(
        file: _selectedFile!,
        title: _titleController.text.trim(),
        caption: _captionController.text.trim(),
        branch: branch,
        teacherId: teacherId,
      );

      // 3. Show success
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Assignment posted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back to the previous screen
      }
    } catch (e) {
      // 4. Add error handling
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      // 5. Always stop loading
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if form is valid
    final bool isFormValid = _titleController.text.isNotEmpty && _selectedFile != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF2C3E50)),
        title: const Text(
          'Post Assignment',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Title Field ---
            const Text(
              'Title',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'e.g., Database Assignment 5',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              onChanged: (_) => setState(() {}), // To update button state
            ),
            const SizedBox(height: 24),

            // --- Caption Field (Optional) ---
            const Text(
              'Caption / Remarks (Optional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _captionController,
              decoration: InputDecoration(
                hintText: 'e.g., Please submit by next Tuesday.',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),

            // --- File Picker Button ---
            const Text(
              'Document',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50)),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.attach_file, color: Color(0xFF1ABC9C)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedFile == null
                            ? 'Select a file (PDF, DOC, etc.)'
                            : _selectedFile!.path.split('/').last, // Show file name
                        style: TextStyle(
                          color: _selectedFile == null ? Colors.grey.shade600 : const Color(0xFF2C3E50),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // --- Submit Button ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (isFormValid && !_isLoading) ? _submitAssignment : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1ABC9C),
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Post Assignment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}