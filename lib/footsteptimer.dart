import 'dart:async';
import 'package:flutter/material.dart';

class FootstepTimer extends StatefulWidget {
  const FootstepTimer({super.key});

  @override
  State<FootstepTimer> createState() => _FootstepTimerState();
}

class _FootstepTimerState extends State<FootstepTimer> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String _displayTime = '00';

  final Map<String, bool> _isHovering = {
    'Start': false,
    'Stop': false,
    'Reset': false,
  };

  void _startStopwatch() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          final elapsed = _stopwatch.elapsed;
          _displayTime = elapsed.inSeconds.toString().padLeft(2, '0');
        });
      });
    }
  }

  void _stopStopwatch() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _timer?.cancel();
    }
  }

  void _resetStopwatch() {
    _stopwatch.reset();
    _stopwatch.stop();
    _timer?.cancel();
    setState(() {
      _displayTime = '00';
    });
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _timer?.cancel();
    super.dispose();
  }

  Color _getButtonColor(String label) {
    switch (label) {
      case 'Start':
        return Colors.greenAccent.shade400;
      case 'Stop':
        return Colors.redAccent.shade400;
      case 'Reset':
        return Colors.blueAccent.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  Color _getHoverColor(String label) {
    switch (label) {
      case 'Start':
        return Colors.greenAccent.shade700;
      case 'Stop':
        return Colors.redAccent.shade700;
      case 'Reset':
        return Colors.blueAccent.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // dark for neon glow
      appBar: AppBar(
        title: const Text(
          'Footstep Timer',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Neon glowing footstep circle
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.8),
                    blurRadius: 30,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Image.network(
                  'https://cdn3.iconfinder.com/data/icons/basic-mobile-part-2/512/footprints-512.png',
                  width: 80,
                  height: 80,
                  color: Colors.cyanAccent,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Timer text with neon effect
            Text(
              _displayTime,
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.purpleAccent.shade100,
                shadows: [
                  Shadow(
                    blurRadius: 20,
                    color: Colors.purpleAccent,
                    offset: const Offset(0, 0),
                  )
                ],
              ),
            ),

            const SizedBox(height: 50),

            // Buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['Start', 'Stop', 'Reset'].map((label) {
                return MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _isHovering[label] = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isHovering[label] = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: _isHovering[label]!
                              ? _getHoverColor(label)
                              : _getButtonColor(label),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (label == 'Start') _startStopwatch();
                        if (label == 'Stop') _stopStopwatch();
                        if (label == 'Reset') _resetStopwatch();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      child: Text(label),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
