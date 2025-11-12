import 'package:flutter/material.dart';
import 'user_profile_edit_page.dart';
import 'change_password_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDarkMode = false;
  bool pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Heading - bigger and more left
                const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 30),

              // Profile Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Color(0xFF7AB8F7),
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Welcome',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Mr. John Doe',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  // Logout Button
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Implement logout
                      Navigator.of(context).pushNamedAndRemoveUntil('/opening', (route) => false);
                    },
                    icon: const Icon(Icons.logout, color: Colors.red, size: 20),
                    label: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // User Profile option
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.person_outline, color: Color(0xFF7AB8F7)),
                  title: const Text('User Profile'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserProfileEditPage()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Change Password option
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.lock_outline, color: Color(0xFF7AB8F7)),
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Dark Mode toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined, color: Color(0xFF7AB8F7)),
                  title: const Text('Dark Mode'),
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                    });
                  },
                  activeColor: const Color(0xFF7AB8F7),
                ),
              ),
              const SizedBox(height: 12),

              // Push Notifications toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined, color: Color(0xFF7AB8F7)),
                  title: const Text('Push Notifications'),
                  value: pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      pushNotifications = value;
                    });
                  },
                  activeColor: const Color(0xFF7AB8F7),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
