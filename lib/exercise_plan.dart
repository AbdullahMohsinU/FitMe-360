// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// Import your drawer function from dashboard.dart or just copy it here
import 'dashboard.dart';  // Make sure this import path is correct

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final List<String> videoUrls = [
    'https://youtu.be/U3HlEF_E9fo?si=5wd8JD6GgZyw-dCn',
    'https://youtu.be/i9sTjhN4Z3M?si=VrKPGIF_Hxw26u1T',
    'https://youtu.be/wrwwXE_x-pQ?si=GB1JY1UR6XnKZ19U',
    'https://youtube.com/shorts/7vVMxbFPLhA?si=Vp5CZaXAnRq3vpZA',
    'https://youtu.be/uLVt6u15L98?si=wEBy1f1n1diF66ve',
    'https://youtu.be/sQKT1bHRrg4?si=gup8dmwTVllHdWyZ',
  ];

  final List<String> exerciseTitles = [
    'Squats',
    'Push-Ups',
    'Lunges',
    'Plank',
    'Jumping Jacks',
    'Burpees',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Exercise Plan Videos'),
        // Do NOT set automaticallyImplyLeading to false here
        // Flutter will show the hamburger menu automatically because drawer is set
      ),
      drawer: buildAppDrawer(context), // Add the drawer here
      body: ListView.builder(
        itemCount: videoUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exerciseTitles[index],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  YoutubePlayer(
                    controller: YoutubePlayerController(
                      initialVideoId:
                          YoutubePlayer.convertUrlToId(videoUrls[index])!,
                      flags: const YoutubePlayerFlags(
                          autoPlay: false, mute: false),
                    ),
                    showVideoProgressIndicator: true,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
