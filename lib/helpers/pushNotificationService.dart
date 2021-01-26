import 'dart:io';

import 'package:bus_tracking_system/globalVariables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {

  final FirebaseMessaging fcm = FirebaseMessaging();

  Future initialize() async {

    if(Platform.isIOS) {
      fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

  }

  Future<String> getToken() async{
    String token = await fcm.getToken();
    print('token: $token');
    
    //DatabaseReference tokenRef = FirebaseDatabase.instance.reference().child('drivers/${user.uid}/token');
    //tokenRef.set(token);
    DatabaseReference tokenRef = FirebaseDatabase.instance.reference().child('passengers/${user.uid}/token');
    tokenRef.set(token);

    fcm.subscribeToTopic('allpassengers');
    //fcm.subscribeToTopic('allUsers');
  }

}