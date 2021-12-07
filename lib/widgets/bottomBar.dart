import 'package:dog2/models.dart';
import 'package:flutter/material.dart';

import '../preferences_service.dart';

class BottomBar extends StatefulWidget {
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selectedIndex = 1;

  final _preferencesService = PreferencesService();

  @override
  void initState() {
    super.initState();

    _populateFields();
  }

  void _populateFields() async {
    final option = await _preferencesService.getOptions();
    setState(() {
      selectedIndex = option.specialSound;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    _populateFields();

    return (Container(
      height: 0.15 * screenHeight,
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          customRadio('Фейер-\nверк', 5, screenWidth),
          customRadio('Петар-\nды', 6, screenWidth),
          customRadio('Гром', 7, screenWidth),
          customRadio('Ветер', 8, screenWidth),
        ],
      ),
    ));
  }

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget customRadio(String txt, int index, double screenWidth) {
    return Container(
      width: 0.2 * screenWidth,
      height: 0.2 * screenWidth,
      child: (MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          color: selectedIndex == index ? Colors.amber : Colors.grey,
          child: Text(
            txt,
            style: TextStyle(fontSize: 14),
          ),
          onPressed: () {
            changeIndex(index);
            _saveOption();
            print(selectedIndex == index);
          })),
    );
  }

  void _saveOption() {
    final options = RadioOption(specialSound: selectedIndex);
    _preferencesService.setRadioOption(options);
  }
}
