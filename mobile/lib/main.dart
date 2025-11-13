import 'package:flutter/material.dart';
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
          return MaterialApp(
            title: 'CampusLink',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              fontFamily: 'Poppins',
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: const Color(0xFFF8F9FA),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              fontFamily: 'Poppins',
              primaryColor: const Color(0xFF7AB8F7),
              scaffoldBackgroundColor: const Color(0xFF121212),
              cardColor: const Color(0xFF1E1E1E),
            ),
            themeMode: themeProvider.themeMode,
            initialRoute: '/opening',
            routes: appRoutes,
          );
        },
      ),
    );
  }
}
