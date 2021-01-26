import 'package:bus_tracking_system/screens/loginPage.dart';
import 'package:bus_tracking_system/screens/mainpage.dart';
import 'package:bus_tracking_system/screens/registrationPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db2',
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
      appId: '1:705663012113:ios:aefcd66e1a4e87152fd0b0',
      apiKey: 'AIzaSyDhMUMgOGCUbJilCety9DDZLMQRGBCf5kQ',
      projectId: 'bustrackingsystem-31e21',
      messagingSenderId: '705663012113',
      databaseURL: 'https://bustrackingsystem-31e21.firebaseio.com',
    )
        : FirebaseOptions(
      appId: '1:705663012113:android:9b3bd569df0473052fd0b0',
      apiKey: 'AIzaSyAsXHq-PBKkDOSJ7BeknY8h17DymdnKXug',
      messagingSenderId: '297855924061',
      projectId: 'bustrackingsystem-31e21',
      databaseURL: 'https://bustrackingsystem-31e21.firebaseio.com',
    ),
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Brand-Regular',
        primarySwatch: Colors.blue,
      ),
      initialRoute: MainPage.id,
      routes: {
        RegistrationPage.id: (context) => RegistrationPage(),
        LoginPage.id: (context) => LoginPage(),
        MainPage.id: (context) => MainPage(),
      },
    );
  }
}


