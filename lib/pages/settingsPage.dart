import 'package:dog2/models.dart';
import 'package:dog2/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  bool _isToggledLongPress = false;
  bool _needVib = true;
  final _preferencesService = PreferencesService();

  @override
  void initState() {
    super.initState();
    _populateFields();
  }

  void _populateFields() async {
    //Получение сохраненной информации с диска
    final settings = await _preferencesService.getSettings();
    setState(() {
      _isToggledLongPress = settings.isToggledLongPress;
      _needVib = settings.needVib;
    });
  }

  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: screenHeight * 0.05,
          ),
          SwitchListTile(
            onChanged: (val) {
              setState(() {
                _isToggledLongPress = val;
              });
              _saveSettings();
            },
            value: _isToggledLongPress,
            tileColor: Colors.cyan,
            title: Text('Запуск звука только при удержании кнопки'),
          ),
          SizedBox(
            height: screenWidth * 0.03,
          ),
          SwitchListTile(
            onChanged: (val) {
              setState(() {
                _needVib = val;
              });
              _saveSettings();
            },
            value: _needVib,
            tileColor: Colors.cyan,
            title: Text('Вибрация при нажатии'),
          ),
          SizedBox(
            height: screenWidth * 0.05,
          ),
          IconButton(
            iconSize: 50,
            onPressed: () => {},
            icon: Icon(Icons.info),
            color: Colors.cyan,
          )
        ],
      ),
    );
  }

  void _saveSettings() {
    final newSettings =
        Settings(isToggledLongPress: _isToggledLongPress, needVib: _needVib);
    _preferencesService.saveSettings(newSettings);
  }
}
