// @dart=2.9
//Автор Акатов Вадим vadimov901@mail.ru
import 'dart:async';

import 'package:dog2/models.dart';
import 'package:dog2/pages/settingsPage.dart';
import 'package:dog2/pages/mainPage.dart';
import 'package:dog2/preferences_service.dart';
import 'package:dog2/widgets/bottomBar.dart';
import 'package:dog2/widgets/ceilingBar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]); //Вертикальная ориентация экрана
  runApp(MaterialApp(home: DogApp()));
}

class DogApp extends StatefulWidget {
  @override
  State<DogApp> createState() => _DogAppState();
}

class _DogAppState extends State<DogApp> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Animation<double> animation;
  AnimationController controller; //Контроллер анимации шестеренки
  int selectedRadio; //Выбранный звук
  bool accepted; //Приняты ли условия пользователя
  final _preferencesService =
      PreferencesService(); //Для сохранения настроект в памяти устройства

  @override
  void initState() {
    super.initState();
    accept();
    controller = AnimationController(
        vsync: this,
        duration:
            Duration(milliseconds: 300)); //Анимация для шестеренки настроек
    setRotation(180);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void accept() async {
    final acception = await _preferencesService.getAcception();
    setState(() {
      accepted = acception;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    if (accepted == false) {
      showAlertDialog(context);
    } //Если условия не приняты показывает всплывающее окно

    return MaterialApp(
      title: 'AntiDog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        key: _scaffoldKey,
        endDrawer: SettingsPage(),
        onEndDrawerChanged: (isOpen) {
          if (isOpen == false) {
            controller.reverse();
          }
        },
        body: Stack(
          children: [
            CeilingBar(), //Звуки на верхней панели
            MainPage(), //Кнопка запуска
            Positioned(
                //Шестеренка
                right: 0.05 * screenWidth,
                top: 0.18 * screenHeight,
                child: Container(
                  child: Transform.scale(
                    scale: 2,
                    child: AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) => Transform.rotate(
                        angle: animation.value,
                        child: IconButton(
                            icon: Icon(Icons.settings),
                            onPressed: () {
                              controller.forward().then((value) =>
                                  _scaffoldKey.currentState.openEndDrawer());
                            }),
                      ),
                    ),
                  ),
                  width: 0.1 * screenWidth,
                  height: 0.1 * screenWidth,
                )),
            Align(
                alignment: Alignment.bottomCenter,
                child: BottomBar()) //Звуки на нижней панели
          ],
        ),
      ),
    );
  }

  void setRotation(int degrees) {
    final angle = degrees * math.pi / 180;
    animation = Tween<double>(begin: 0, end: angle).animate(controller);
  }

  void showAlertDialog(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      showDialog(
          barrierDismissible: false, //Необходимо принять условия
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                  "Внимание!\nДанное программное обеспечение не является профессиональным средством защиты и не гарантирует эффективность результатов действия. \nРабота данного программного обеспечения происходит с использованием звуковых колебаний высокой частоты, которые способны воздействовать на организм человека. \nАвтор не несет отвестственность за последствия действий пользователей данного программного обеспечения."),
              actions: [
                TextButton(
                    onPressed: () {
                      _preferencesService.accept(true);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Принять",
                      style: TextStyle(fontSize: 20),
                    ))
              ],
            );
          });
    });
  }
}



//Автор Акатов Вадим vadimov901@mail.ru