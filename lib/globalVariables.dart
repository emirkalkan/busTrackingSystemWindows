import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

FirebaseUser currentFirebaseUser;

final CameraPosition googlePlex = CameraPosition(
    target: LatLng(40.9721, 29.1524),
    zoom: 16.4746,
);

String mapKey = 'AIzaSyAsXHq-PBKkDOSJ7BeknY8h17DymdnKXug';
String mapKeyiOS = 'AIzaSyDhMUMgOGCUbJilCety9DDZLMQRGBCf5kQ';