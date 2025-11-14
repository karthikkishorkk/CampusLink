import 'package:flutter/material.dart';
import '../../widgets/button.dart';

class OpeningScreen extends StatelessWidget {
  const OpeningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Always use light mode colors for opening screen
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF9F0), // #FFF9F0
              Color(0xFFF5E6D3), // #F5E6D3
              Color(0xFFE8D5C4), // #E8D5C4
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 1),
              Image.asset(
                'assets/images/logowithout.png',
                width: MediaQuery.of(context).size.width * 0.6,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
                'CampusLink',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B1538),
                  fontFamily: 'serif',
                ),
              ),
              const Spacer(flex: 1),
              CustomButton(
                text: 'Log in as Faculty',
                backgroundColor: const Color(0xFFD4AF37),
                textColor: const Color(0xFF2C3E50),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/login',
                    arguments: {'role': 'teacher'},
                  );
                },
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Log in as Student',
                backgroundColor: const Color(0xFF8B1538).withOpacity(0.5),
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/login',
                    arguments: {'role': 'student'},
                  );
                },
              ),
              const Spacer(flex: 1),
            ],
            ),
          ),
        ),
      ),
    );
  }
}
