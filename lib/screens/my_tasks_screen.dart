import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTasksScreen extends StatefulWidget {
  const MyTasksScreen({Key? key}) : super(key: key);

  @override
  State<MyTasksScreen> createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> {
  List<Map<String, dynamic>> myTasks = [];
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('my_tasks');
    if (tasksJson != null) {
      final List<dynamic> taskList = json.decode(tasksJson);
      setState(() {
        myTasks = taskList.cast<Map<String, dynamic>>();
      });
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(myTasks);
    await prefs.setString('my_tasks', encodedData);
  }

  void _addTask(String title) {
    setState(() {
      myTasks.add({'title': title, 'done': false});
      _saveTasks();
      _taskController.clear();
    });
  }

  void _toggleTask(int index, bool? value) {
    setState(() {
      myTasks[index]['done'] = value ?? false;
      _saveTasks();
    });
  }

  void _deleteTask(int index) {
    setState(() {
      myTasks.removeAt(index);
      _saveTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final unfinishedTasks = myTasks.where((task) => task['done'] == false).toList();
    final completedTasks = myTasks.where((task) => task['done'] == true).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        backgroundColor: Colors.blue[800],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      hintText: 'Tambah tugas baru',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_taskController.text.isNotEmpty) {
                      _addTask(_taskController.text);
                    }
                  },
                  child: const Text('Tambah'),
                ),
              ],
            ),
          ),
          Expanded(
            child: myTasks.isEmpty
                ? const Center(child: Text('Belum ada tugas.'))
                : ListView(
                    children: [
                      if (unfinishedTasks.isNotEmpty)
                        _buildTaskSection('Belum Dikerjakan', unfinishedTasks),
                      if (completedTasks.isNotEmpty)
                        _buildTaskSection('Sudah Dikerjakan', completedTasks),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskSection(String title, List<Map<String, dynamic>> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        ...tasks.map((task) {
          final index = myTasks.indexOf(task);
          return ListTile(
            leading: Checkbox(
              value: task['done'],
              onChanged: (value) => _toggleTask(index, value),
            ),
            title: Text(
              task['title'],
              style: TextStyle(
                decoration: task['done'] ? TextDecoration.lineThrough : null,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteTask(index),
            ),
          );
        }).toList(),
      ],
    );
  }
}
