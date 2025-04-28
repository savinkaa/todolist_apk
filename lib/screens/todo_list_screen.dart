import 'package:flutter/material.dart';
import '../widgets/date_selector.dart';
import '../widgets/task_item.dart';
import 'add_task_screen.dart';
import 'profile_screen.dart';
import 'my_tasks_screen.dart'; // Import MyTasksScreen

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Map<String, dynamic>> tasks = [
    {'title': 'Belanja', 'done': true, 'date': DateTime.now()},
    {'title': 'Mencuci Piring', 'done': false, 'date': DateTime.now()},
    {'title': 'Belajar Kelompok', 'done': false, 'date': DateTime.now()},
    {'title': 'Olahraga', 'done': false, 'date': DateTime.now()},
    {'title': 'Membersihkan Dapur', 'done': false, 'date': DateTime.now().add(Duration(days: 1))},
  ];

  DateTime selectedDate = DateTime.now(); // tanggal yang dipilih di DateSelector

  void _addTask(String title) {
    setState(() {
      tasks.add({'title': title, 'done': false, 'date': selectedDate});
    });
  }

  void _toggleTask(int index, bool? value) {
    setState(() {
      tasks[index]['done'] = value ?? false;
    });
  }

  List<Map<String, dynamic>> get filteredTasks {
    return tasks.where((task) {
      return task['date'].day == selectedDate.day &&
             task['date'].month == selectedDate.month &&
             task['date'].year == selectedDate.year;
    }).toList();
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'To-do list',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundImage: AssetImage('assets/avatar.png'),
            ),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const ProfileScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0); // Transisi dari kanan ke kiri
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(position: offsetAnimation, child: child);
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          DateSelector(onDateSelected: _onDateSelected),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'All tasks',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => const MyTasksScreen(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0); // Transisi dari kanan ke kiri
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(position: offsetAnimation, child: child);
                        },
                      ),
                    );
                  },
                  child: const Text(
                    'My tasks',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredTasks.isEmpty
                ? const Center(child: Text('No tasks found for this date.'))
                : ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (ctx, i) => Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        title: Text(
                          filteredTasks[i]['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: filteredTasks[i]['done'] ? Colors.green : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          'Due: ${filteredTasks[i]['date'].toLocal()}'.split(' ')[0], // Menampilkan tanggal lokal
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: Checkbox(
                          value: filteredTasks[i]['done'],
                          onChanged: (value) {
                            final originalIndex = tasks.indexOf(filteredTasks[i]);
                            _toggleTask(originalIndex, value);
                          },
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[900],
        onPressed: () async {
          final newTaskTitle = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
          if (newTaskTitle != null && newTaskTitle is String) {
            _addTask(newTaskTitle);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
