import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/todo_list_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/completed_tasks_screen.dart';
import 'screens/my_tasks_screen.dart';
import 'utils/preferences_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isDarkMode = await PreferencesHelper.getDarkMode();
  runApp(RoommateTodoApp(isDarkMode: isDarkMode));
}

class RoommateTodoApp extends StatelessWidget {
  final bool isDarkMode;

  const RoommateTodoApp({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Roommate To-do App',
      theme: ThemeData(
        fontFamily: 'DMSerifText',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/todo': (context) => const TodoListScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/completed': (context) => const CompletedTasksScreen(),
        '/mytasks': (context) => const MyTasksScreen(),
      },
    );
  }
}
