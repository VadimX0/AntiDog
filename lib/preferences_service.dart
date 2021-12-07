import 'package:dog2/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<void> saveSettings(Settings settings) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(
        'isToggledLongPress', settings.isToggledLongPress);
    await preferences.setBool('needVib', settings.needVib);
  }

  Future<void> accept(bool accepted) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('accepted', accepted);
  }

  Future<bool> getAcception() async {
    final preferences = await SharedPreferences.getInstance();
    final accepted = preferences.getBool('accepted');
    return accepted ?? false;
  }

  Future<Settings> getSettings() async {
    final preferences = await SharedPreferences.getInstance();
    final isToggledLongPress = preferences.getBool('isToggledLongPress');
    final needVib = preferences.getBool('needVib');

    return Settings(
        isToggledLongPress: isToggledLongPress ?? false,
        needVib: needVib ?? true);
  }

  Future<void> setRadioOption(RadioOption option) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt('specialSound', option.specialSound);
  }

  Future<RadioOption> getOptions() async {
    final preferences = await SharedPreferences.getInstance();
    final specialSound = preferences.getInt('specialSound');
    return RadioOption(specialSound: specialSound!);
  }
}
