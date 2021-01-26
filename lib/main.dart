import 'package:bus_tracking_system/admin/createBusStop.dart';
import 'package:bus_tracking_system/globalVariables.dart';
import 'package:bus_tracking_system/helpers/fireHelper.dart';
import 'package:bus_tracking_system/helpers/helperMethods.dart';
import 'package:bus_tracking_system/screens/loginPage.dart';
import 'package:bus_tracking_system/screens/mainPageDriver.dart';
import 'package:bus_tracking_system/screens/mainpage.dart';
import 'package:bus_tracking_system/screens/registrationPage.dart';
import 'package:bus_tracking_system/screens/startPage.dart';
import 'package:bus_tracking_system/tabs/busStopTab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'admin/adminPage.dart';


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

  HelperMethods.getDistanceBetweenBusStops();
  //getUpdateLocationDriver();
  //HelperMethods.getStartingTime();
  //HelperMethods.addEstimateTimeToStartingTime();
  print('isDriver: ${isDriver}');
  print('current User: ${currentUser}');

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
      initialRoute:  (currentUser == null) ? LoginPage.id : (isDriver) ? MainPageDriver.id : MainPage.id,
      //initialRoute: AdminBusStopPage.id,
      routes: {
        RegistrationPage.id: (context) => RegistrationPage(),
        LoginPage.id: (context) => LoginPage(),
        MainPage.id: (context) => MainPage(),
        MainPageDriver.id: (context) => MainPageDriver(),
        AdminPage.id: (context) => AdminPage(),
        BusStopTab.id: (context) => BusStopTab(),
        AdminBusStopPage.id: (context) => AdminBusStopPage(),
        StartPage.id: (context) => StartPage(),
      },
    );
  }
}


