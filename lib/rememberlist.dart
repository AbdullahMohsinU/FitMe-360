import 'package:flutter/material.dart';
import 'database_helper.dart'; // Your custom database helper file

class RememberList extends StatefulWidget {
  const RememberList({super.key});

  @override
  State<RememberList> createState() => _RememberListState();
}

class _RememberListState extends State<RememberList> {
  final List<TextEditingController> _controllers = [];
  final List<int> _todoIds = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final db = DatabaseHelper();
    await db.createTodoTable(); // Ensures table exists
    final todos = await db.getTodos();

    setState(() {
      _controllers.clear();
      _todoIds.clear();

      for (var todo in todos) {
        _controllers.add(TextEditingController(text: todo['task']));
        _todoIds.add(todo['id']);
      }
    });
  }

  Future<void> _addTextField() async {
    final db = DatabaseHelper();
    int id = await db.insertTodo(''); // Insert an empty task
    setState(() {
      _controllers.add(TextEditingController());
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
    String updatedTask = _controllers[index].text;
    await db.updateTodo(_todoIds[index], updatedTask);
  }

  @override
  void dispose() {
    for (var i = 0; i < _controllers.length; i++) {
      _updateTask(i); // Save task when exiting
      _controllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // <<< Background color set here
      appBar: AppBar(
        title: const Text('To-Do List'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              const Text(
                'To-Do List:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white, // Container background color
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                decoration: const InputDecoration(
                                  hintText: 'Add your task...',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTask(i),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addTextField,
                // ignore: sort_child_properties_last
                child: const Text("Add Task"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodoItem(String title) {
    return Row(
      children: [
        const Icon(Icons.check_box_outline_blank, color: Colors.blue),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
