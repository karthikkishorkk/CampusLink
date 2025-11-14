// lib/screens/common/profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/user_provider.dart';
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
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final cardColor = Theme.of(context).cardColor;
    
    final userProvider = Provider.of<UserProvider>(context);
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
          //
          // THIS WAS THE FIX: Added the 'child:' property
          //
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Heading
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'serif',
                      color: isDark ? const Color(0xFFF5E6D3) : const Color(0xFF8B1538),
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
                            // MAKE THE NAME DYNAMIC
                            Text(
                              userProvider.name, // Read from provider
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                            ),
                          ],
                        ),
                      ),
                      // FIX LOGOUT BUTTON
                      TextButton.icon(
                        onPressed: () async {
                          // Call the provider's logout method
                          await Provider.of<UserProvider>(context, listen: false).logout();
                          // Navigate to opening screen
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
      ),
    );
  }
}