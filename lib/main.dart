import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanandroid/common/GlobalConfig.dart';
import 'package:wanandroid/pages/Application.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '玩安卓',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          // TRY THIS: Change to "Brightness.light"
          //           and see that all colors change
          //           to better contrast a light background.
          brightness: Brightness.light,
        ),
        fontFamily: "noto",
        primaryColor: GlobalConfig.colorPrimary,
      ),
      home: ApplicationPage(),
    );
  }
}
