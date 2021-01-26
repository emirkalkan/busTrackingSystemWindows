import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bus_tracking_system/dataModels/directionDetails.dart';
import 'package:bus_tracking_system/dataModels/driver.dart';
import 'package:bus_tracking_system/dataModels/nearbyDrivers.dart';
import 'package:bus_tracking_system/dataModels/passenger.dart';
import 'package:bus_tracking_system/dataModels/routes.dart';
import 'package:bus_tracking_system/globalVariables.dart';
import 'package:bus_tracking_system/helpers/requestHelper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;



class HelperMethods{

  static double generateRandomNumber(int max){
    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);

    return randInt.toDouble();
  }

  static void getPassengerInfo() {
    DatabaseReference passengerRef = FirebaseDatabase.instance.reference().child('passengers/${user.uid}');
    passengerRef.once().then((DataSnapshot snapshot) {
      if(snapshot.value != null){
        Passenger currentUserInfo = Passenger.fromSnapshot(snapshot);
        email = currentUserInfo.email;
        phonePassenger = currentUserInfo.phone;
        fullNamePassenger = currentUserInfo.fullName;
        isDriver = currentUserInfo.isDriver;
      }
    });
  }

  static void getDriverInfo() {
    DatabaseReference driverRef = FirebaseDatabase.instance.reference().child('drivers').child(user.uid);
    driverRef.once().then((DataSnapshot snapshot) {
      if(snapshot.value != null){
        Driver currentUserInfo = Driver.fromSnapshot(snapshot);
        email = currentUserInfo.email;
        phoneDriver = currentUserInfo.phone;
        fullNameDriver = currentUserInfo.fullName;
        plateNo = currentUserInfo.plateNo;
        isDriver = currentUserInfo.isDriver;

        print('ismim ${fullNameDriver}');
        print('isDriver: ${isDriver}');

      }
    });
  }

  static void soundBusStop(int index) {
    print('selam emir');
    final assetsAudioPlayer = AssetsAudioPlayer();

    switch(index){
      case 0:
        assetsAudioPlayer.open(
          Audio('sounds/first.mp3'),
        );
        assetsAudioPlayer.play();
        break;
      case 1:
        print("case2");
        assetsAudioPlayer.open(
          Audio('sounds/second.mp3'),
        );
        assetsAudioPlayer.play();
        break;
      case 2:
        assetsAudioPlayer.open(
          Audio('sounds/third.mp3'),
        );
        assetsAudioPlayer.play();
        break;
      case 3:
        assetsAudioPlayer.open(
          Audio('sounds/fourth.mp3'),
        );
        assetsAudioPlayer.play();
        break;
      case 4:
        assetsAudioPlayer.open(
          Audio('sounds/fifth.mp3'),
        );
        assetsAudioPlayer.play();
        break;
      case 5:
        assetsAudioPlayer.open(
          Audio('sounds/sixth.mp3'),
        );
        assetsAudioPlayer.play();
        break;
      case 6:
        assetsAudioPlayer.open(
          Audio('sounds/seventh.mp3'),
        );
        assetsAudioPlayer.play();
        break;
      case 7:
        assetsAudioPlayer.open(
          Audio('sounds/eighth.mp3'),
        );
        assetsAudioPlayer.play();
        break;
      case 8:
        assetsAudioPlayer.open(
          Audio('sounds/ninth.mp3'),
        );
        assetsAudioPlayer.play();
        break;
      case 9:
        assetsAudioPlayer.open(
          Audio('sounds/tenth.mp3'),
        );
        assetsAudioPlayer.play();
        break;
      default:
        assetsAudioPlayer.open(
          Audio('sounds/busVoice.mp3'),
        );
        assetsAudioPlayer.play();
    }
  }

  /*static void getBusStopInfo() {
    DatabaseReference passengerRef = FirebaseDatabase.instance.reference().child('busStops/');
    passengerRef.once().then((DataSnapshot snapshot) {
      if(snapshot.value != null){
        Passenger currentUserInfo = Passenger.fromSnapshot(snapshot);
        email = currentUserInfo.email;
        phonePassenger = currentUserInfo.phone;
        fullNamePassenger = currentUserInfo.fullName;
        isDriver = currentUserInfo.isDriver;
      }
    });
  }*/

   static NearbyDriver getRouteInfo(NearbyDriver driver) {
    DatabaseReference routeRef = FirebaseDatabase.instance.reference().child('drivers/${driver.key}');
    routeRef.once().then((DataSnapshot snapshot) {
      print("hehehehe");
      var routeName;

      if(snapshot.value != null){
        routeName = snapshot.value['routeName'];
        print(routeName);
        driver.routeName = routeName;
        print('func içi:  ${driver.routeName}');
      }
    });
    return driver;
  }

  static getStartingTimeRoute () {

    DatabaseReference getTimeRef = FirebaseDatabase.instance.reference().child('routes');
    getTimeRef.once().then((DataSnapshot snapshot) {
      print("hehehehe");
      if(snapshot.value['-MOgGscjxcLKjidV9sPm'] != null){
        startHour = snapshot.value['-MOgGscjxcLKjidV9sPm']['hour'];
        startMinute = snapshot.value['-MOgGscjxcLKjidV9sPm']['minute'];
      }

      print(startHour);
      print(startMinute);
      //Map<dynamic, dynamic> values = snapshot.value;
      //List<Route> route = new List();

      /*values.forEach((key,values) {
        //route = values["driverKey"];
        //route.routeName = values["routeName"];
        //route.routeId = values['routeId'];
        //route.hour = values["hour"];
        //route.minute = values["minute"];
      });*/
    });
  }

  static sendNotification(String token) async{

    //final String serverToken = serverKey;
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': serverKey,
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Your bus has arrived at the bus stop.',
            'title': 'BUS TRACKING SYSTEM APP',
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token,
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
    Completer<Map<String, dynamic>>();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        completer.complete(message);
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        completer.complete(message);
        print("OnResume: $message");
      },
    );
    final assetsAudioPlayer = AssetsAudioPlayer();
    assetsAudioPlayer.open(
      Audio('sounds/busVoice.mp3'),
    );
    assetsAudioPlayer.play();

    return completer.future;

  }

  static Future<DirectionDetails> getDirectionDetails(LatLng startPosition, LatLng endPosition) async {

    String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKey';

    var response = await RequestHelper.getRequest(url);

    if(response == 'failed'){
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.durationText = response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue = response['routes'][0]['legs'][0]['duration']['value'];

    directionDetails.distanceText = response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue = response['routes'][0]['legs'][0]['distance']['value'];

    directionDetails.encodedPoints = response['routes'][0]['overview_polyline']['points'];

    return directionDetails;
  }

  static Future<void> getDistanceBetweenBusStops() async {

    var geoLocator = Geolocator();
    double distanceInMeters, totalDistance = 0;
    double speed = 20;
    double arrivalTime = 0;

    //if(speedInMps == null){
      //speedInMps = 30;
    //}

    List<dynamic> data = [
      {
        'lat': pinPosition1.latitude,
        'lng': pinPosition1.longitude
      },
      {
        'lat': pinPosition2.latitude,
        'lng': pinPosition2.longitude
      },
      {
        'lat': pinPosition3.latitude,
        'lng': pinPosition3.longitude
      },
      {
        'lat': pinPosition4.latitude,
        'lng': pinPosition4.longitude
      },
      {
        'lat': pinPosition5.latitude,
        'lng': pinPosition5.longitude
      },
      {
        'lat': pinPosition6.latitude,
        'lng': pinPosition6.longitude
      },
      {
        'lat': pinPosition7.latitude,
        'lng': pinPosition7.longitude
      },
      {
        'lat': pinPosition8.latitude,
        'lng': pinPosition8.longitude
      },
      {
        'lat': pinPosition9.latitude,
        'lng': pinPosition9.longitude
      },
      {
        'lat': pinPosition10.latitude,
        'lng': pinPosition10.longitude
      },
      /*{
        'lat': pinPosition11.latitude,
        'lng': pinPosition11.longitude
      },*/
    ];

    for(var i = 0; i < data.length-1; i++){
        distanceInMeters = await geoLocator.distanceBetween(data[i]['lat'], data[i]['lng'], data[i+1]['lat'], data[i+1]['lng']);
        print('Distance between ${i+1} and ${i+2} : ${distanceInMeters}');
        totalDistance += distanceInMeters;
        distanceFromFirstBusStop.add(totalDistance);
        print('distance:  ${distanceFromFirstBusStop}');
        print('total distance:  ${totalDistance}');

    }
    //last stop and first
    distanceInMeters = await geoLocator.distanceBetween(data[0]['lat'], data[0]['lng'], data[9]['lat'], data[9]['lng']);
    totalDistance += distanceInMeters;
    distanceFromFirstBusStop.add(totalDistance);

    for(var i = 0; i < distanceFromFirstBusStop.length; i++){
      distanceFromFirstBusStop[i] /= 10;
      print('distance:  ${distanceFromFirstBusStop[i]}');
      arrivalTime = distanceFromFirstBusStop[i]/speed;
      print('arrivalTime:  ${arrivalTime}');
      //arrivalTime *= 100;
      //arrivalTime = arrivalTime.toStringAsFixed(1);
      estimateTimeFromFirstBusStop.add(arrivalTime);
      estimateTimeFromFirstBusStop[i] = double.parse(estimateTimeFromFirstBusStop[i].toStringAsFixed(0));
      print(double.parse(estimateTimeFromFirstBusStop[i].toStringAsFixed(0)));
      print('${estimateTimeFromFirstBusStop}');
    }
  }

  static void timeTable(int thatBusStop , List timeTable){
    var thatTime =  estimateTimeFromFirstBusStop[thatBusStop];

    //estimateTimeFromFirstBusStop.clear();
    for(var j = 0; j < estimateTimeFromFirstBusStop.length; j++){
      print('that time: ${thatTime}');
      estimateTimeFromFirstBusStop[j] -= thatTime;
      //estimateTimeFromFirstBusStop[j] = double.parse(estimateTimeFromFirstBusStop[j].toStringAsFixed(2));
      //print(double.parse(estimateTimeFromFirstBusStop[j].toStringAsFixed(2)));
      print('Stop ${j+1} time : ${estimateTimeFromFirstBusStop[j]}');
    }

    print('estimate time: ${estimateTimeFromFirstBusStop}');

    /*for(var i = 0; i < estimateTimeFromFirstBusStop.length; i++) {
      finalTime.add(estimateTimeFromFirstBusStop[i]);
    }
    print(finalTime);*/
  }

  static void getTime(){
    DatabaseReference getTimeRef = FirebaseDatabase.instance.reference().child('drivers/');
    getTimeRef.once().then((DataSnapshot snapshot) {
      print("hehehehe");
      if(snapshot.value['JQJreQPAa6M5LdKdrDwNh4tNpu03'] != null){
        print(snapshot.value);
        startHour = snapshot.value['JQJreQPAa6M5LdKdrDwNh4tNpu03']['hour'];
        startMinute = snapshot.value['JQJreQPAa6M5LdKdrDwNh4tNpu03']['minute'];
        plateNoDriver = snapshot.value['JQJreQPAa6M5LdKdrDwNh4tNpu03']['plateNo'];
        delayTime = snapshot.value['JQJreQPAa6M5LdKdrDwNh4tNpu03']['delayTime'];
        busStopDelayId = snapshot.value['JQJreQPAa6M5LdKdrDwNh4tNpu03']['busStopDelayId'];
      }

      if(busStopDelayId == null){
        busStopDelayId = 100;
      }
      if(delayTime != null){
        delayTime += delayTime;
      }
      print('Time: ${startHour} : ${startMinute}');
      print('Plate No: ${plateNoDriver}');
      print('Delay Time: ${delayTime}');
      print('Bus Stop Delay Id: ${busStopDelayId}');
      //Map<dynamic, dynamic> values = snapshot.value;
      //List<Route> route = new List();

      /*values.forEach((key,values) {
        //route = values["driverKey"];
        //route.routeName = values["routeName"];
        //route.routeId = values['routeId'];
        //route.hour = values["hour"];
        //route.minute = values["minute"];
      });*/
    });
    addEstimateTimeToStartingTime();
  }

  static void addEstimateTimeToStartingTime() {

     double hour = 0, minute = 0;
     int h = 0, m = 0 ;

    time = [
      {
        'hour': '',
        'minute': '',
      },
      {
        'hour': '',
        'minute': '',
      },
      {
        'hour': '',
        'minute': '',
      },
      {
        'hour': '',
        'minute': '',
      },
      {
        'hour': '',
        'minute': '',
      },
      {
        'hour': '',
        'minute': '',
      },
      {
        'hour': '',
        'minute': '',
      },
      {
        'hour': '',
        'minute': '',
      },
      {
        'hour': '',
        'minute': '',
      },
      {
        'hour': '',
        'minute': '',
      },
    ];

    for(var i = 0; i < estimateTimeFromFirstBusStop.length ; i++){
        minute = startMinute + estimateTimeFromFirstBusStop[i];
        hour = startHour + (minute/60);
        minute = minute % 60;
        m = minute.toInt();
        switch(m){
          case 0:
            time[i]['minute'] = '00';
            break;
          case 1:
            time[i]['minute'] = '01';
            break;
          case 2:
            time[i]['minute'] = '02';
            break;
          case 3:
            time[i]['minute'] = '03';
            break;
          case 4:
            time[i]['minute'] = '04';
            break;
          case 5:
            time[i]['minute'] = '05';
            break;
          case 6:
            time[i]['minute'] = '06';
            break;
          case 7:
            time[i]['minute'] = '07';
            break;
          case 8:
            time[i]['minute'] = '08';
            break;
          case 9:
            time[i]['minute'] = '09';
            break;
          case 60:
            time[i]['minute'] = '00';
            break;
          default:
            time[i]['minute'] = '$m';
        }
        h = hour.toInt();
        time[i]['hour'] = '$h';
        print('Time ${i}: ${time[i]['hour']} : ${time[i]['minute']} ');
    }
  }

}