import 'package:flutter/material.dart';

import '../models.dart';
import '../preferences_service.dart';

class CeilingBar extends StatefulWidget {
  @override
  State<CeilingBar> createState() => _CeilingBarState();
}

class _CeilingBarState extends State<CeilingBar> {
  int selectedRadio = 1;
  final _preferencesService = PreferencesService();

  @override
  void initState() {
    super.initState();
    _populateFields();
  }

  void setSelectedRadio(val) {
    setState(() {
      selectedRadio = val;
    });
    _saveOption();
  }

  void _populateFields() async {
    //Получение сохраненной информации с диска
    final option = await _preferencesService.getOptions();
    setState(() {
      selectedRadio = option.specialSound;
    });
  }

  @override
  Widget build(BuildContext context) {
    _populateFields();
    return Positioned(
      child: Container(
        alignment: Alignment.topCenter,
        color: Colors.blue,
        height:
            0.15 * MediaQuery.of(context).size.height, //занимает 15/100 экрана
        child: Stack(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Transform.scale(
                scale: 1.8,
                child: Radio(
                  value: 1,
                  groupValue: selectedRadio,
                  onChanged: (val) {
                    setSelectedRadio(val);
                  },
                  fillColor:
                      MaterialStateProperty.all<Color>(Colors.teal.shade50),
                ),
              ),
              Transform.scale(
                scale: 1.8,
                child: Radio(
                  value: 2,
                  groupValue: selectedRadio,
                  onChanged: (val) => setSelectedRadio(val),
                  fillColor:
                      MaterialStateProperty.all<Color>(Colors.teal.shade50),
                ),
              ),
              Transform.scale(
                scale: 1.8,
                child: Radio(
                  value: 3,
                  groupValue: selectedRadio,
                  onChanged: (val) => setSelectedRadio(val),
                  fillColor:
                      MaterialStateProperty.all<Color>(Colors.teal.shade50),
                ),
              ),
              Transform.scale(
                scale: 1.8,
                child: Radio(
                  value: 4,
                  groupValue: selectedRadio,
                  onChanged: (val) => setSelectedRadio(val),
                  fillColor:
                      MaterialStateProperty.all<Color>(Colors.teal.shade50),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '2kHz',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  '5kHz',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  '10kHz',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  '16kHz',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }

  void _saveOption() {
    final options = RadioOption(specialSound: selectedRadio);
    _preferencesService.setRadioOption(options);
  }
}
