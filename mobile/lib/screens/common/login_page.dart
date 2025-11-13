import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isSignIn = true;
  
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  bool obscurePassword = true;
  String userRole = 'student'; // Default role
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the role from navigation arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['role'] != null) {
      setState(() {
        userRole = args['role'];
      });
    }
  }

  void toggleAuthMode() {
    setState(() {
      isSignIn = !isSignIn;
      if (isSignIn) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    });
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating, // This makes it float from the bottom
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background (Full Screen)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: isDark 
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1A237E),
                      const Color(0xFF283593),
                      const Color(0xFF3949AB),
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF7AB8F7),
                      const Color(0xFF9EC8FF),
                      const Color(0xFFB8D8FF),
                    ],
                  ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Logo and Title (Top Left) with Back Button
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.headset_mic,
                            color: Color(0xFF6B4FA0),
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'CampusLink',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: isSignIn
                      ? MediaQuery.of(context).size.height * 0.15 // Taller space for the shorter Sign In card
                      : MediaQuery.of(context).size.height * 0.06, // Shorter space for the taller Sign Up card
                    ),

                  // Auth Card (Overlapping)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(math.pi * _animation.value),
                          child: _animation.value < 0.5
                              ? _buildSignInCard()
                              : Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()..rotateY(math.pi),
                                  child: _buildSignUpCard(),
                                ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    
    return Container(
      constraints: const BoxConstraints(maxHeight: 500),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Log in',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              // Role Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: userRole == 'teacher' 
                      ? const Color(0xFF2196F3).withOpacity(0.1)
                      : const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: userRole == 'teacher' 
                        ? const Color(0xFF2196F3)
                        : const Color(0xFF4CAF50),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      userRole == 'teacher' ? Icons.person : Icons.school,
                      color: userRole == 'teacher' 
                          ? const Color(0xFF2196F3)
                          : const Color(0xFF4CAF50),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      userRole == 'teacher' ? 'Faculty' : 'Student',
                      style: TextStyle(
                        color: userRole == 'teacher' 
                            ? const Color(0xFF2196F3)
                            : const Color(0xFF4CAF50),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your account details to Log in',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 30),

          // Email Field
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Email',
              prefixIcon: Icon(Icons.email_outlined, color: Colors.grey.shade600),
              hintStyle: TextStyle(color: Colors.grey.shade400),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Password Field
          TextField(
            controller: passwordController,
            obscureText: obscurePassword,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: Icon(Icons.lock_outline, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
              filled: true,
              fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Forgot Password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // TODO: Navigate to forgot password
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Forgot password?',
                style: TextStyle(
                  color: Color(0xFF2C3E50),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Log In Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : () async {
                setState(() { _isLoading = true; });
                final email = emailController.text.trim();
                final password = passwordController.text;
                try {
                  await Provider.of<UserProvider>(context, listen: false)
                      .login(email: email, password: password);

                  // On success navigate to dashboard
                  Navigator.of(context).pushReplacementNamed(
                    '/dashboard',
                    arguments: {'role': Provider.of<UserProvider>(context, listen: false).role},
                  );
                } catch (e) {
                  String errorMessage = 'Login failed. Please try again.';
                  if (e is AuthApiException) {
                    errorMessage = e.message; // This shows the simple Supabase message
                  }
                  _showErrorSnackBar(context, errorMessage);
                } finally {
                  setState(() { _isLoading = false; });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C3E50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),

          // Don't have account
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: toggleAuthMode,
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    color: Color(0xFF7AB8F7),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    
    return Container(
      constraints: const BoxConstraints(maxHeight: 700),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sign up',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              // Role Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: userRole == 'teacher' 
                      ? const Color(0xFF2196F3).withOpacity(0.1)
                      : const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: userRole == 'teacher' 
                        ? const Color(0xFF2196F3)
                        : const Color(0xFF4CAF50),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      userRole == 'teacher' ? Icons.person : Icons.school,
                      color: userRole == 'teacher' 
                          ? const Color(0xFF2196F3)
                          : const Color(0xFF4CAF50),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      userRole == 'teacher' ? 'Faculty' : 'Student',
                      style: TextStyle(
                        color: userRole == 'teacher' 
                            ? const Color(0xFF2196F3)
                            : const Color(0xFF4CAF50),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Create your account to get started',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20),

          // Name Field
          TextField(
            controller: nameController,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: 'Full Name',
              prefixIcon: Icon(Icons.person_outline, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
              filled: true,
              fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Email Field
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: 'Email',
              prefixIcon: Icon(Icons.email_outlined, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
              filled: true,
              fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Password Field
          TextField(
            controller: passwordController,
            obscureText: obscurePassword,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: Icon(Icons.lock_outline, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
              filled: true,
              fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ID / Roll No or TID Field
          TextField(
            controller: idController,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: userRole == 'teacher' ? 'Teacher ID (TID)' : 'Roll Number',
              prefixIcon: Icon(Icons.badge_outlined, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
              filled: true,
              fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Branch / Department (optional)
          TextField(
            controller: branchController,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: 'Branch / Department (optional)',
              prefixIcon: Icon(Icons.account_tree_outlined, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
              filled: true,
              fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Sign Up Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : () async {
                setState(() { _isLoading = true; });
                final name = nameController.text.trim();
                final email = emailController.text.trim();
                final password = passwordController.text;
                final idNumber = idController.text.trim();
                final branch = branchController.text.trim();

                if (name.isEmpty || email.isEmpty || password.isEmpty || idNumber.isEmpty) {
                  _showErrorSnackBar(context, 'Please fill all required fields');
                  setState(() { _isLoading = false; });
                  return;
                }

                try {
                  await Provider.of<UserProvider>(context, listen: false).signUp(
                    role: userRole,
                    name: name,
                    email: email,
                    password: password,
                    idNumber: idNumber,
                    branch: branch,
                  );

                  Navigator.of(context).pushReplacementNamed(
                    '/dashboard',
                    arguments: {'role': Provider.of<UserProvider>(context, listen: false).role},
                  );
                } catch (e) {
                  String errorMessage = 'Sign up failed. Please try again.';
                  if (e is AuthApiException) {
                    errorMessage = e.message; // This shows the simple Supabase message
                  }
                  _showErrorSnackBar(context, errorMessage);
                } finally {
                  setState(() { _isLoading = false; });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C3E50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),

          // Already have account
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account? ",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: toggleAuthMode,
                child: const Text(
                  'Log in',
                  style: TextStyle(
                    color: Color(0xFF7AB8F7),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    idController.dispose();
    branchController.dispose();
    super.dispose();
  }
}
