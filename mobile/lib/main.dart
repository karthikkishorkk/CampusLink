import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'routes/app_routes.dart';
import 'providers/user_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/classroom_provider.dart';
import 'providers/event_provider.dart';
import 'providers/theme_provider.dart';
import 'config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  
  runApp(const ClassroomApp());
}

class ClassroomApp extends StatelessWidget {
  const ClassroomApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ClassroomProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // Set system UI overlay style globally
          final isDark = themeProvider.themeMode == ThemeMode.dark ||
              (themeProvider.themeMode == ThemeMode.system &&
                  WidgetsBinding.instance.window.platformBrightness == Brightness.dark);
          
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
              statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
              systemNavigationBarColor: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE8D5C4),
              systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
            ),
          );
          
          return MaterialApp(
            title: 'CampusLink',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              // Use a single global serif-like font family throughout the app.
              // If you add custom fonts later, update this to the font family name.
              fontFamily: 'serif',
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: const Color(0xFFF8F9FA),
              appBarTheme: const AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                  statusBarBrightness: Brightness.light,
                ),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              fontFamily: 'serif',
              primaryColor: const Color(0xFF7AB8F7),
              scaffoldBackgroundColor: const Color(0xFF121212),
              cardColor: const Color(0xFF1E1E1E),
              appBarTheme: const AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.dark,
                ),
              ),
            ),
            themeMode: themeProvider.themeMode,
            home: const AuthChecker(), // Check auth status on startup
            routes: appRoutes,
          );
        },
      ),
    );
  }
}

// Widget to check authentication status on app startup
class AuthChecker extends StatefulWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;
    
    // Wait a brief moment for the UI to render
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;
    
    if (session != null) {
      // User is logged in, fetch their role and navigate to dashboard
      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.loadUserFromSession();
        
        if (!mounted) return;
        
        Navigator.of(context).pushReplacementNamed(
          '/dashboard',
          arguments: {'role': userProvider.role},
        );
      } catch (e) {
        // If error loading user data, go to login
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/opening');
      }
    } else {
      // No session, go to opening screen
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/opening');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading screen while checking auth
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF9F0),
              Color(0xFFF5E6D3),
              Color(0xFFE8D5C4),
            ],
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF8B1538),
          ),
        ),
      ),
    );
  }
}
