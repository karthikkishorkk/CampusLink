import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import 'user_profile_edit_page.dart';
import 'change_password_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool pushNotifications = true;

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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Heading - bigger and more left
                Text(
                'Profile',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: textColor,
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
                      children: [
                        Text(
                          'Welcome',
                          style: TextStyle(fontSize: 14, color: isDark ? Colors.grey.shade400 : Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Mr. John Doe',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
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
                  color: cardColor,
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
                  color: cardColor,
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
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined, color: Color(0xFF7AB8F7)),
                  title: const Text('Dark Mode'),
                  subtitle: Text(
                    isDark ? 'Dark theme enabled' : 'Light theme enabled',
                    style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                  ),
                  value: isDark,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false).toggleDarkMode(value);
                  },
                  activeColor: const Color(0xFF7AB8F7),
                ),
              ),
              const SizedBox(height: 12),

              // Push Notifications toggle
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
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
