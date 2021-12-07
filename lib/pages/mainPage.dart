import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'dart:async';
import 'package:vibration/vibration.dart';

import '../preferences_service.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> with TickerProviderStateMixin {
  late AudioPlayer player;

  bool ispressed = false; //Нажата ли кнопка
  late bool _isToggledLongPress;
  late bool _needVib; //Нужна ли вибрация
  String _option = '2kHz'; //Выбранный звук
  late double screenWidth;
  late double screenHeight;
  late double buttonSize;
  final _preferencesService = PreferencesService();
  late AnimationController _animationController; //Анимация кнопки
  late Animation<double> buttonAnimation;
  late AnimationController butAnimationController;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    butAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _populateFields();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void setSound() async {
    if (_option == '2kHz') {
      await player.setAsset('lib/sounds/2kHz.mp3');
    } else if (_option == '5kHz') {
      await player.setAsset('lib/sounds/5kHz.mp3');
    } else if (_option == '10kHz') {
      await player.setAsset('lib/sounds/10kHz.mp3');
    } else if (_option == '16kHz') {
      await player.setAsset('lib/sounds/16kHz.mp3');
    } else if (_option == 'Fireworks') {
      await player.setAsset('lib/sounds/Fireworks.mp3');
    } else if (_option == 'Thunder') {
      await player.setAsset('lib/sounds/Thunderx.mp3');
    } else if (_option == 'Wind') {
      await player.setAsset('lib/sounds/Wind.mp3');
    } else if (_option == 'Petard') {
      await player.setAsset('lib/sounds/Petardx.mp3');
    }
  }

  void _populateFields() async {
    //Получение сохраненной информации с диска
    final settings = await _preferencesService.getSettings();
    final option = await _preferencesService.getOptions();

    setState(() {
      _isToggledLongPress = settings.isToggledLongPress;
      _needVib = settings.needVib;
    });
    switch (option.specialSound) {
      case 1:
        setState(() {
          _option = '2kHz';
        });
        break;
      case 2:
        setState(() {
          _option = '5kHz';
        });
        break;
      case 3:
        setState(() {
          _option = '10kHz';
        });
        break;
      case 4:
        setState(() {
          _option = '16kHz';
        });
        break;
      case 5:
        setState(() {
          _option = 'Fireworks';
        });
        break;
      case 6:
        setState(() {
          _option = 'Petard';
        });
        break;
      case 7:
        setState(() {
          _option = 'Thunder';
        });
        break;
      case 8:
        setState(() {
          _option = 'Wind';
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _populateFields();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    buttonSize = 0.5 * screenWidth;
    setButAnimation(buttonSize);

    void playing() async {
      //Функция срабатывает при нажатии и запускает звук
      setSound();
      await player.play();
      await player.setLoopMode(LoopMode.one);
      ispressed = true;
      if (_needVib) {
        Vibration.vibrate();
      }
      _animationController.forward();
      butAnimationController.forward();
    }

    void stopPlaying() async {
      //Остановка звука
      await player.setLoopMode(LoopMode.off);
      await player.stop();
      _animationController.reverse();
      butAnimationController.reset();
      setState(() {
        ispressed = false;
      });
    }

    return Center(
      child: AvatarGlow(
        //Анимация волн от кнопки
        startDelay: Duration(milliseconds: 0),
        glowColor: Colors.blue,
        endRadius: 0.95 * buttonSize,
        duration: Duration(milliseconds: 2000),
        repeat: true,
        showTwoGlows: true,
        child: GestureDetector(
          onLongPressStart: (_) async {
            _isToggledLongPress ? playing() : null;
          },
          onLongPressEnd: (_) async {
            _isToggledLongPress ? stopPlaying() : null;
          },
          child: MaterialButton(
            height: buttonAnimation.value,
            minWidth: buttonAnimation.value,
            child: AnimatedIcon(
                size: 0.4 * screenWidth,
                icon: AnimatedIcons.play_pause,
                color: Colors.indigo,
                progress: _animationController),
            onPressed: () async {
              ispressed = ispressed ? false : true;
              if (ispressed) {
                playing();
              } else {
                stopPlaying();
              }
            },
            color: Colors.blue[100],
            shape: CircleBorder(),
          ),
        ),
      ),
    );
  }

  void setButAnimation(double buttonSize) {
    buttonAnimation = Tween<double>(begin: buttonSize, end: 350)
        .animate(butAnimationController);
  }
}
