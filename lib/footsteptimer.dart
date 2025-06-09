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
  String _displayTime = "00";

  // Track hovered buttons
  final Map<String, bool> _isHovering = {
    "Start": false,
    "Stop": false,
    "Reset": false,
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
      _displayTime = "00";
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
      case "Start":
        return Colors.green.shade100; // light green
      case "Stop":
        return Colors.red.shade100; // light red
      case "Reset":
        return Colors.grey.shade300; // light grey
      default:
        return Colors.grey.shade200;
    }
  }

  Color _getHoverColor(String label) {
    switch (label) {
      case "Start":
        return Colors.green.shade300;
      case "Stop":
        return Colors.red.shade300;
      case "Reset":
        return Colors.grey.shade500;
      default:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Footstep Timer', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey[200],
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Smaller footstep circle
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade100, // very light grey for subtle contrast
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.network(
                  'https://cdn3.iconfinder.com/data/icons/basic-mobile-part-2/512/footprints-512.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              _displayTime,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ["Start", "Stop", "Reset"].map((label) {
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
                      color: _isHovering[label]!
                          ? _getHoverColor(label)
                          : _getButtonColor(label),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (label == "Start") _startStopwatch();
                        if (label == "Stop") _stopStopwatch();
                        if (label == "Reset") _resetStopwatch();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        foregroundColor: Colors.black87,
                        textStyle: const TextStyle(fontSize: 14),
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
