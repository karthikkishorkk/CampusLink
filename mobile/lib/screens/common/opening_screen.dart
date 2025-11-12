import 'package:flutter/material.dart';
import '../../widgets/button.dart';

class OpeningScreen extends StatelessWidget {
  const OpeningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    
    return Scaffold(
      backgroundColor: const Color(0xFF2F2D52),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              const Text(
                'CampusLink',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Our classroom is large, clean and bright.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFB8C1D9),
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: 'Log in as Faculty',
                backgroundColor: const Color(0xFF2196F3),
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/login',
                    arguments: {'role': 'teacher'},
                  );
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Log in as Student',
                backgroundColor: const Color(0xFF4CAF50),
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/login',
                    arguments: {'role': 'student'},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
