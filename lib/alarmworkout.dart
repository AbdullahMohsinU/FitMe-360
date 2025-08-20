// ignore_for_file: prefer_single_quotes, deprecated_member_use, dead_code, curly_braces_in_flow_control_structures

import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'dashboard.dart'; // to access buildAppDrawer

class AlarmWorkoutScreen extends StatefulWidget {
  const AlarmWorkoutScreen({super.key});

  @override
  State<AlarmWorkoutScreen> createState() => _AlarmWorkoutScreenState();
}

class _AlarmWorkoutScreenState extends State<AlarmWorkoutScreen> {
  TimeOfDay? _selectedTime;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isAlarmPlaying = false;

  final List<String> _tones = ['alarm.mp3', 'beep.mp3', 'ringtone.mp3'];
  String _selectedTone = 'alarm.mp3';

  int? _finalHour = 9;
  int? _finalMinute = 0;
  String _finalAmPm = 'AM';

  int _convertTo24Hour(int hour, String ampm) =>
      ampm == 'AM' ? (hour == 12 ? 0 : hour) : (hour == 12 ? 12 : hour + 12);

  Future<void> _setAlarmFromFinalTime() async {
    final final24Hour = _convertTo24Hour(_finalHour ?? 9, _finalAmPm);
    final finalTimeOfDay =
        TimeOfDay(hour: final24Hour, minute: _finalMinute ?? 0);
    final now = DateTime.now();
    DateTime alarmDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      finalTimeOfDay.hour,
      finalTimeOfDay.minute,
    );
    if (alarmDateTime.isBefore(now))
      alarmDateTime = alarmDateTime.add(const Duration(days: 1));
    final difference = alarmDateTime.difference(now);

    setState(() {
      _selectedTime = finalTimeOfDay;
      _timer?.cancel();
      _timer = Timer(difference, _triggerAlarm);
    });

    _showSnackBar("Alarm set for ${_selectedTime!.format(context)}");
  }

  Future<void> _triggerAlarm() async {
    setState(() => _isAlarmPlaying = true);
    _showSnackBar("⏰ Alarm ringing!");
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.play(AssetSource('sounds/$_selectedTone'));
    } catch (e) {
      debugPrint("Error playing alarm sound: $e");
      _showSnackBar("Error playing alarm sound.");
      setState(() => _isAlarmPlaying = false);
    }
  }

  Future<void> _stopAlarm() async {
    await _audioPlayer.stop();
    setState(() => _isAlarmPlaying = false);
    _showSnackBar("Alarm stopped.");
  }

  Future<void> _playTestSound() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.play(AssetSource('sounds/$_selectedTone'));
      _showSnackBar("Playing test sound...");
    } catch (e) {
      debugPrint("Error playing sound: $e");
      _showSnackBar("Failed to play sound.");
    }
  }

  void _showSnackBar(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<int>> _buildHourItems() =>
      List.generate(
          12,
          (index) => DropdownMenuItem(
                value: index + 1,
                child: Text('${index + 1}',
                    style: const TextStyle(color: Colors.cyanAccent)),
              ));

  List<DropdownMenuItem<int>> _buildMinuteItems() =>
      List.generate(
          60,
          (index) => DropdownMenuItem(
                value: index,
                child: Text(index.toString().padLeft(2, '0'),
                    style: const TextStyle(color: Colors.cyanAccent)),
              ));

  List<DropdownMenuItem<String>> _buildAmPmItems() =>
      ['AM', 'PM']
          .map((p) => DropdownMenuItem(
                value: p,
                child: Text(p, style: const TextStyle(color: Colors.cyanAccent)),
              ))
          .toList();

  @override
  Widget build(BuildContext context) {
    final timeText = _selectedTime == null
        ? "No alarm set"
        : "Alarm set for: ${_selectedTime!.format(context)}";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Workout Alarm",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Theme(
  data: Theme.of(context).copyWith(
    canvasColor: Colors.black, // Fallback
      drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.black, // Explicitly set drawer background
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  ),
  child: buildAppDrawer(context),
),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            Icon(Icons.alarm, size: 100, color: Colors.cyanAccent.withOpacity(0.8)),
            const SizedBox(height: 20),
            Text(timeText,
                style: const TextStyle(
                    fontSize: 22,
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 10, color: Colors.cyanAccent)])),
            const SizedBox(height: 30),
            const Text('Set Alarm Time:',
                style: TextStyle(fontSize: 16, color: Colors.white)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<int>(
                  dropdownColor: Colors.black,
                  value: _finalHour,
                  items: _buildHourItems(),
                  onChanged: (val) => setState(() => _finalHour = val),
                ),
                const Text(' : ', style: TextStyle(color: Colors.cyanAccent)),
                DropdownButton<int>(
                  dropdownColor: Colors.black,
                  value: _finalMinute,
                  items: _buildMinuteItems(),
                  onChanged: (val) => setState(() => _finalMinute = val),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  dropdownColor: Colors.black,
                  value: _finalAmPm,
                  items: _buildAmPmItems(),
                  onChanged: (val) => setState(() => _finalAmPm = val!),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _neonButton(Icons.alarm_add, "Set Alarm", _setAlarmFromFinalTime),
            const SizedBox(height: 20),
            _neonButton(Icons.play_arrow, "Test Sound", _playTestSound),
            const SizedBox(height: 20),
            _neonButton(Icons.stop_circle_outlined, "Stop Sound", _stopAlarm,
                color: Colors.redAccent),
            const SizedBox(height: 30),
            Card(
              color: const Color(0xFF121826),
              elevation: 6,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text("Select Alarm Tone",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                            shadows: [Shadow(blurRadius: 8, color: Colors.cyanAccent)])),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      value: _selectedTone,
                      dropdownColor: Colors.black,
                      isExpanded: true,
                      items: _tones.map((tone) {
                        return DropdownMenuItem(
                          value: tone,
                          child: Text(tone.replaceAll('.mp3', '').toUpperCase(),
                              style: const TextStyle(color: Colors.cyanAccent)),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedTone = value!),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _neonButton(IconData icon, String label, VoidCallback onPressed,
      {Color color = Colors.cyanAccent}) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: color),
      label: Text(label,
          style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(blurRadius: 10, color: color, offset: const Offset(0, 0))
              ])),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 50),
        side: BorderSide(color: color, width: 2),
        elevation: 8,
      ),
    );
  }
}
