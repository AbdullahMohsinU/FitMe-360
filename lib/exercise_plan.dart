// ignore_for_file: library_private_types_in_public_api

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dashboard.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen>
    with SingleTickerProviderStateMixin {
  final List<String> exerciseTitles = [
    'Squats',
    'Push-Ups',
    'Lunges',
    'Plank',
    'Jumping Jacks',
    'Burpees',
  ];

  final List<String> gifUrls = [
    'https://i0.wp.com/www.strengthlog.com/wp-content/uploads/2020/02/Air-squat.gif?resize=600%2C600&ssl=1',
    'https://i.gifer.com/756z.gif',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyoInjJYqRkemmktdkhoNo48ysoiKl3FE9AQ&s',
    'https://flabfix.com/wp-content/uploads/2019/08/Plank-with-Arm-Reach.gif',
    'https://hips.hearstapps.com/hmg-prod/images/workouts/2016/03/jumpingjack-1457045563.gif',
    'https://hips.hearstapps.com/menshealth-uk/main/assets/burpees.gif',
  ];

  final List<String> infoUrls = [
    'https://en.wikipedia.org/wiki/Squat_(exercise)',
    'https://en.wikipedia.org/wiki/Push-up',
    'https://en.wikipedia.org/wiki/Lunge_(exercise)',
    'https://en.wikipedia.org/wiki/Plank_(exercise)',
    'https://youtu.be/7vVMxbFPLhA?si=Vp5CZaXAnRq3vpZA',
    'https://en.wikipedia.org/wiki/Burpee_(exercise)',
  ];

  late AnimationController _clockController;

  @override
  void initState() {
    super.initState();
    _clockController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();
  }

  @override
  void dispose() {
    _clockController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showExerciseOverlay(int index) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(colors: [Colors.cyan, Colors.purple]),
                boxShadow: [
                  BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 2)
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    exerciseTitles[index],
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                              blurRadius: 8,
                              color: Colors.cyanAccent,
                              offset: Offset(0, 0))
                        ]),
                  ),
                  const SizedBox(height: 16),
                  Image.network(
                    gifUrls[index],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: AnimatedBuilder(
                      animation: _clockController,
                      builder: (_, child) {
                        return CustomPaint(
                          painter: MiniClockPainter(_clockController.value),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _launchUrl(infoUrls[index]),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        ),
                        child: const Text('Learn More'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color(0xFF0A0F1C),
          scrimColor: Colors.black54,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0F1C),
          foregroundColor: Colors.white,
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0F1C),
        appBar: AppBar(
          title: const Text('Exercise Plan'),
        ),
        drawer: buildAppDrawer(context),
        body: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: exerciseTitles.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _showExerciseOverlay(index),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.cyan, Colors.purple]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 1,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image.network(
                      gifUrls[index],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        exerciseTitles[index],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(blurRadius: 5, color: Colors.black, offset: Offset(0, 1))
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _launchUrl(infoUrls[index]),
                      icon: const Icon(Icons.info, color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MiniClockPainter extends CustomPainter {
  final double progress; // 0.0 - 1.0

  MiniClockPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paintCircle = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final paintHand = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, paintCircle);

    final angle = 2 * pi * progress - pi / 2;
    final handEnd = Offset(center.dx + radius * 0.7 * cos(angle),
        center.dy + radius * 0.7 * sin(angle));
    canvas.drawLine(center, handEnd, paintHand);
  }

  @override
  bool shouldRepaint(covariant MiniClockPainter oldDelegate) => true;
}