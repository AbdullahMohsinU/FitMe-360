// ignore_for_file: prefer_const_declarations

import 'dart:math';
import 'package:flutter/material.dart';
import 'dashboard.dart'; // Optional: Replace this with your actual dashboard.dart if needed

void main() {
  runApp(const HealthMonitorscreen());
}

class HealthMonitorscreen extends StatelessWidget {
  const HealthMonitorscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Monitor - BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const BMICalculatorScreen(),
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const BMICalculatorScreen({Key? key}) : super(key: key);

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightCmController = TextEditingController();
  final TextEditingController _heightFeetController = TextEditingController();
  final TextEditingController _heightInchController = TextEditingController();

  String _weightUnit = 'kg';
  String _heightUnit = 'cm';

  double? _bmiResult;
  String _bmiCategory = '';
  String _diseasePrediction = '';

  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  final List<String> _emojis = ['😟', '😊', '😐', '⚠️'];

  double _angleForCategory(int index) {
    return (2 * pi / _emojis.length) * index;
  }

  void _calculateBMI() {
    final weight = double.tryParse(_weightController.text);
    double? heightCm;

    if (weight == null || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid weight')),
      );
      return;
    }

    if (_heightUnit == 'cm') {
      heightCm = double.tryParse(_heightCmController.text);
      if (heightCm == null || heightCm <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter valid height in cm')),
        );
        return;
      }
    } else {
      final feet = double.tryParse(_heightFeetController.text);
      final inches = double.tryParse(_heightInchController.text) ?? 0;
      if (feet == null || feet <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter valid height in feet')),
        );
        return;
      }
      heightCm = (feet * 30.48) + (inches * 2.54);
    }

    double weightKg = _weightUnit == 'lbs' ? weight * 0.453592 : weight;
    final heightM = heightCm / 100;
    final bmi = weightKg / (heightM * heightM);

    String category;
    String prediction;
    int categoryIndex;

    if (bmi < 18.5) {
      category = 'Underweight';
      prediction = 'Risk: Nutritional deficiencies, osteoporosis.';
      categoryIndex = 0;
    } else if (bmi < 24.9) {
      category = 'Normal weight';
      prediction = 'Great! Keep maintaining your healthy lifestyle.';
      categoryIndex = 1;
    } else if (bmi < 29.9) {
      category = 'Overweight';
      prediction = 'Risk: High blood pressure, diabetes, heart disease.';
      categoryIndex = 2;
    } else {
      category = 'Obesity';
      prediction = 'Risk: Severe heart disease, diabetes, stroke.';
      categoryIndex = 3;
    }

    setState(() {
      _bmiResult = bmi;
      _bmiCategory = category;
      _diseasePrediction = prediction;
    });

    _animateNeedle(categoryIndex);
  }

  void _animateNeedle(int categoryIndex) {
    final targetAngle = _angleForCategory(categoryIndex);
    _rotationAnimation = Tween<double>(
      begin: _rotationAnimation.value,
      end: targetAngle,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController
      ..reset()
      ..forward();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightCmController.dispose();
    _heightFeetController.dispose();
    _heightInchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const compassSize = 250.0;

    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator')),
      drawer: buildAppDrawer(context), // If you have one
      body: Center(
        child: SingleChildScrollView( ///
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Weight',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: _weightUnit,
                        items: ['kg', 'lbs']
                            .map((unit) => DropdownMenuItem(value: unit, child: Text(unit)))
                            .toList(),
                        onChanged: (val) => setState(() => _weightUnit = val!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text("Height in: "),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: _heightUnit,
                        items: ['cm', 'ft/in']
                            .map((unit) => DropdownMenuItem(value: unit, child: Text(unit)))
                            .toList(),
                        onChanged: (val) => setState(() => _heightUnit = val!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_heightUnit == 'cm')
                    TextField(
                      controller: _heightCmController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Height (cm)',
                        border: OutlineInputBorder(),
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _heightFeetController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Feet',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _heightInchController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Inches',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _calculateBMI,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Calculate BMI'),
                  ),
                  const SizedBox(height: 24),
                  if (_bmiResult != null)
                    Column(
                      children: [
                        Text(
                          'Your BMI: ${_bmiResult!.toStringAsFixed(2)} ($_bmiCategory)',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _diseasePrediction,
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        Divider(thickness: 1, color: Colors.grey[400]),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: compassSize,
                          height: compassSize,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: compassSize,
                                height: compassSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue.shade50,
                                  border: Border.all(color: Colors.blue.shade700, width: 3),
                                ),
                              ),
                              ...List.generate(_emojis.length, (index) {
                                final angle = _angleForCategory(index);
                                final radius = compassSize / 2 - 30;
                                final dx = radius * cos(angle);
                                final dy = radius * sin(angle);
                                return Positioned(
                                  left: (compassSize / 2) + dx - 12,
                                  top: (compassSize / 2) + dy - 12,
                                  child: Text(_emojis[index], style: const TextStyle(fontSize: 24)),
                                );
                              }),
                              AnimatedBuilder(
                                animation: _rotationAnimation,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _rotationAnimation.value,
                                    child: child,
                                  );
                                },
                                child: Container(
                                  width: 4,
                                  height: compassSize / 2 - 30,
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  alignment: Alignment.topCenter,
                                  child: const Text('🧭', style: TextStyle(fontSize: 24)),
                                ),
                              ),
                              Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
