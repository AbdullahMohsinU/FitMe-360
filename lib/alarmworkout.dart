import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart'; //alarm

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

  int _convertTo24Hour(int hour, String ampm) {
    if (ampm == 'AM') {
      return hour == 12 ? 0 : hour;
    } else {
      return hour == 12 ? 12 : hour + 12;
    }
  }

  Future<void> _setAlarmFromFinalTime() async {
    final final24Hour = _convertTo24Hour(_finalHour ?? 9, _finalAmPm);
    final finalTimeOfDay = TimeOfDay(hour: final24Hour, minute: _finalMinute ?? 0);

    final now = DateTime.now();
    DateTime alarmDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      finalTimeOfDay.hour,
      finalTimeOfDay.minute,
    );

    if (alarmDateTime.isBefore(now)) {
      alarmDateTime = alarmDateTime.add(const Duration(days: 1));
    }

    final difference = alarmDateTime.difference(now);

    setState(() {
      _selectedTime = finalTimeOfDay;
      _timer?.cancel();
      _timer = Timer(difference, _triggerAlarm);
    });

    _showSnackBar("Alarm set for ${_selectedTime!.format(context)}");
  }

  Future<void> _triggerAlarm() async {
    setState(() {
      _isAlarmPlaying = true;
    });
    _showSnackBar("⏰ Alarm ringing!");

    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.play(AssetSource('sounds/$_selectedTone'));
    } catch (e) {
      debugPrint("Error playing alarm sound: $e");
      _showSnackBar("Error playing alarm sound.");
      setState(() {
        _isAlarmPlaying = false;
      });
    }
  }

  Future<void> _stopAlarm() async {
    await _audioPlayer.stop();
    setState(() {
      _isAlarmPlaying = false;
    });
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

  List<DropdownMenuItem<int>> _buildHourItems() {
    return List.generate(12, (index) {
      final hour = index + 1;
      return DropdownMenuItem(value: hour, child: Text(hour.toString()));
    });
  }

  List<DropdownMenuItem<int>> _buildMinuteItems() {
    return List.generate(60, (index) {
      final text = index.toString().padLeft(2, '0');
      return DropdownMenuItem(value: index, child: Text(text));
    });
  }

  List<DropdownMenuItem<String>> _buildAmPmItems() {
    return ['AM', 'PM'].map((period) {
      return DropdownMenuItem(value: period, child: Text(period));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final timeText = _selectedTime == null
        ? "No alarm set"
        : "Alarm set for: ${_selectedTime!.format(context)}";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Workout Alarm"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(Icons.alarm, size: 100, color: Colors.red),
                const SizedBox(height: 20),
                Text(timeText, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 30),

                const Text('Set Alarm Time:', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<int>(
                      value: _finalHour,
                      items: _buildHourItems(),
                      onChanged: (val) => setState(() => _finalHour = val),
                    ),
                    const Text(' : '),
                    DropdownButton<int>(
                      value: _finalMinute,
                      items: _buildMinuteItems(),
                      onChanged: (val) => setState(() => _finalMinute = val),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: _finalAmPm,
                      items: _buildAmPmItems(),
                      onChanged: (val) => setState(() => _finalAmPm = val!),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                ElevatedButton.icon(
                  icon: const Icon(Icons.alarm_add),
                  label: const Text("Set Alarm"),
                  onPressed: _setAlarmFromFinalTime,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Test Sound"),
                  onPressed: _playTestSound,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  icon: const Icon(Icons.stop_circle_outlined),
                  label: const Text("Stop Sound"),
                  onPressed: _stopAlarm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),

                const SizedBox(height: 30),

                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text("🎵 Select Alarm Tone", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        DropdownButton<String>(
                          value: _selectedTone,
                          isExpanded: true,
                          items: _tones.map((tone) {
                            return DropdownMenuItem(
                              value: tone,
                              child: Text(tone.replaceAll('.mp3', '').toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedTone = value;
                              });
                            }
                          },
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
  }
}