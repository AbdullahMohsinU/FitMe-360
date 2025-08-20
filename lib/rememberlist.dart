// ignore_for_file: sort_child_properties_last, prefer_single_quotes

import 'package:flutter/material.dart';
import 'database_helper.dart';

class RememberList extends StatefulWidget {
  const RememberList({super.key});

  @override
  State<RememberList> createState() => _RememberListState();
}

class _RememberListState extends State<RememberList> {
  final List<TextEditingController> _controllers = [];
  final List<int> _todoIds = [];

  // For BMI Calculator
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double? _bmi;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadTodos() async {
    final db = DatabaseHelper();
    final todos = await db.getTodos();
    _controllers.clear();
    _todoIds.clear();
    for (var todo in todos) {
      _controllers.add(TextEditingController(text: todo['task']));
      _todoIds.add(todo['id']);
    }
  }

  Future<void> _addTextField() async {
    final db = DatabaseHelper();
    int id = await db.insertTodo('New Task'); // Placeholder task
    setState(() {
      _controllers.add(TextEditingController(text: 'New Task'));
      _todoIds.add(id);
    });
  }

  Future<void> _deleteTask(int index) async {
    final db = DatabaseHelper();
    await db.deleteTodo(_todoIds[index]);
    setState(() {
      _controllers.removeAt(index);
      _todoIds.removeAt(index);
    });
  }

  Future<void> _updateTask(int index) async {
    final db = DatabaseHelper();
    String updatedTask = _controllers[index].text.trim();
    if (updatedTask.isNotEmpty) {
      await db.updateTodo(_todoIds[index], updatedTask);
    }
  }

  void _calculateBMI() {
    double? height = double.tryParse(_heightController.text);
    double? weight = double.tryParse(_weightController.text);
    if (height != null && weight != null && height > 0) {
      setState(() {
        _bmi = weight / ((height / 100) * (height / 100));
      });
    }
  }

  @override
  void dispose() {
    for (var i = 0; i < _controllers.length; i++) {
      if (_controllers[i].text.trim().isNotEmpty) {
        _updateTask(i);
      }
      _controllers[i].dispose();
    }
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117), // Dark mode neon theme
      appBar: AppBar(
        title: const Text(
          '✨ To-Do & Health ✨',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent,
            shadows: [
              Shadow(blurRadius: 20, color: Colors.cyan, offset: Offset(0, 0))
            ],
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.cyan));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          _loadTodos();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // BMI Calculator Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161B22),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "🍎 Diet & BMI Checker",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                          shadows: [
                            Shadow(blurRadius: 15, color: Colors.cyan)
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Height (cm)",
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white10,
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Weight (kg)",
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white10,
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _calculateBMI,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyanAccent,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text("Check BMI"),
                      ),
                      if (_bmi != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          "Your BMI: ${_bmi!.toStringAsFixed(1)}",
                          style: TextStyle(
                            fontSize: 16,
                            color: _bmi! < 18.5
                                ? Colors.orangeAccent
                                : _bmi! < 25
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // To-Do Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161B22),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purpleAccent.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '📝 To-Do List',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purpleAccent,
                          shadows: [
                            Shadow(blurRadius: 15, color: Colors.purple),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildTodoItem('Health Workout Plan'),
                      for (int i = 0; i < _controllers.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _controllers[i],
                                  onChanged: (value) => _updateTask(i),
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    hintText: 'Add your task...',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white10,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () => _deleteTask(i),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _addTextField,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: const Text("➕ Add Task"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTodoItem(String title) {
    return Row(
      children: [
        const Icon(Icons.check_circle_outline, color: Colors.cyanAccent),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ],
    );
  }
}
