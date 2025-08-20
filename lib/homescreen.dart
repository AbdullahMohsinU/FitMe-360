// ignore_for_file: dead_code, deprecated_member_use

import 'package:flutter/material.dart';
import 'exercise_plan.dart';
import 'specificdietplan.dart';
import 'alarmworkout.dart';
import 'healthmonitor.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key}); // removed const to fix neonColors issue

  // Neon colors for each card
  final List<Color> neonColors = [
    Colors.cyanAccent,
    Colors.pinkAccent,
    Colors.greenAccent,
    Colors.amberAccent,
  ];

  Widget _buildCard(
      BuildContext context, String imagePath, String label, Widget screen, Color neonColor) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;

        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            margin: const EdgeInsets.symmetric(vertical: 12),
            transform: Matrix4.identity()..scale(isHovered ? 1.07 : 1.0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: isHovered ? neonColor.withOpacity(0.9) : neonColor.withOpacity(0.2),
                  blurRadius: isHovered ? 25 : 8,
                  spreadRadius: isHovered ? 4 : 1,
                  offset: const Offset(0, 0),
                ),
              ],
              border: Border.all(
                color: isHovered ? neonColor : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.vertical(top: Radius.circular(18)),
                          child: Image.asset(
                            imagePath,
                            width: double.infinity,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // ✅ Light Blue Overlay on Hover
                        if (isHovered)
                          Positioned.fill(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(18)),
                                color: Colors.lightBlueAccent.withOpacity(0.4),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isHovered ? neonColor : Colors.white,
                          shadows: [
                            Shadow(
                              color: isHovered ? neonColor : Colors.transparent,
                              blurRadius: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.fitness_center, size: 90, color: Colors.cyanAccent),
              const SizedBox(height: 18),
              const Text(
                'Welcome to FitMe360!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                  shadows: [
                    Shadow(color: Colors.blueAccent, blurRadius: 20),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Track your fitness, diet, and progress with neon energy.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 28),

              // Feature Cards
              _buildCard(context, 'assets/content/image1.jpg', 'Exercise Plan',
                  const ExerciseScreen(), neonColors[0]),
              _buildCard(context, 'assets/content/image2.jpg', 'Diet Plan',
                  const SpecificDietPlan(), neonColors[1]),
              _buildCard(context, 'assets/content/image3.jpg', 'Workout Alarm',
                  const AlarmWorkoutScreen(), neonColors[2]),
              _buildCard(context, 'assets/content/image4.jpg', 'Health Plan',
                  const HealthPlanScreen(), neonColors[3]),
            ],
          ),
        ),
      ),
    );
  }
}
