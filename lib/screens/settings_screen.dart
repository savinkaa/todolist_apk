import 'package:flutter/material.dart';
import 'package:your_app/utils/preferences_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadDarkMode();
  }

  // Load Dark Mode preference saat halaman dibuka
  _loadDarkMode() async {
    bool darkMode = await PreferencesHelper.getDarkMode();
    setState(() {
      _isDarkMode = darkMode;
    });
  }

  // Mengubah status Dark Mode dan simpan ke SharedPreferences
  _toggleDarkMode(bool value) {
    PreferencesHelper.setDarkMode(value);
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListTile(
        title: const Text('Dark Mode'),
        trailing: Switch(
          value: _isDarkMode,
          onChanged: _toggleDarkMode,
        ),
      ),
    );
  }
}
