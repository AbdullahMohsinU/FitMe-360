// ignore_for_file: dead_code, deprecated_member_use

import 'package:flutter/material.dart';
import 'exercise_plan.dart';
import 'specificdietplan.dart';
import 'alarmworkout.dart';
import 'healthmonitor.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _buildCard(BuildContext context, String imagePath, String label, Widget screen) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;

        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isHovered ? Colors.white70 : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: isHovered ? Colors.blue.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
                  blurRadius: isHovered ? 10 : 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
                },
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        imagePath,
                        width: double.infinity,
                        height: 80, // ✅ Smaller image
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
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
      color: Colors.grey[100],
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.fitness_center, size: 90, color: Colors.blueAccent),
              const SizedBox(height: 18),
              const Text(
                'Welcome to FitMe360!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              const Text(
                'Track your fitness, diet, and progress with ease.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),
              const SizedBox(height: 25),

              // Feature Cards
              _buildCard(context, 'assets/content/image1.jpg', 'Exercise Plan', const ExerciseScreen()),
              _buildCard(context, 'assets/content/image2.jpg', 'Diet Plan', const SpecificDietPlan()),
              _buildCard(context, 'assets/content/image3.jpg', 'Workout Alarm', const AlarmWorkoutScreen()),
              _buildCard(context, 'assets/content/image4.jpg', 'Health Monitor', const HealthMonitorscreen()),
            ],
          ),
        ),
      ),
    );
  }
}
