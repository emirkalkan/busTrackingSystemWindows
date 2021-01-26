import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dataModels/nearbyDrivers.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
User user = auth.currentUser;
var currentUser;

var index = -1;

Map<dynamic, dynamic> driverRouteInfo;

//time Info
int startHour = 0, startMinute = 0;
List<dynamic> time;

var plateNoDriver;
var delayTime = 0;
var busStopDelayId;

//user
var isDriver = false;
var email;
var phoneDriver;
var phonePassenger;
var fullNameDriver;
var fullNamePassenger;
var plateNo;

NearbyDriver globalDriver = NearbyDriver();

//Arrival Time
//var speedInMps;
List<NearbyDriver> driverList = [];

var estimateTime;
List<dynamic> driverKeyList = [];
List<dynamic> driverLat = [];
List<dynamic> driverLng = [];
List<dynamic> estimateTimeBusStop = [];
List<dynamic> finalTime = [];
List<dynamic> distanceBusStop = [];
List<dynamic> distanceFromFirstBusStop = [];
List<dynamic> estimateTimeFromFirstBusStop = [];

String tripStatusDisplay = 'Driver is Arriving';
//Arrival Time

final CameraPosition googlePlex = CameraPosition(
    target: LatLng(40.9731, 29.1530),
    zoom: 16.4746,
);

StreamSubscription<Position> homeTabPositionStream;

String serverKey = 'key=AAAApEzLDRE:APA91bFDbx9T6yewkIDwYUR_rCBvDNsS6VftycZabQxVKm7j6yiFEOSKs4secmNYeQTHDd_dd6QV5nP0nAkt4VK_RQ6wYspkiI5i155cy0JJMESASoejlJHF_1aldOdn9u3wIzY_P5fq';

String mapKey = 'AIzaSyAsXHq-PBKkDOSJ7BeknY8h17DymdnKXug';
String mapKeyiOS = 'AIzaSyDhMUMgOGCUbJilCety9DDZLMQRGBCf5kQ';

//https://maps.googleapis.com/maps/api/directions/json?origin=40.972209,29.1530489&destination=40.9747,29.1531&mode=driving&key=AIzaSyAsXHq-PBKkDOSJ7BeknY8h17DymdnKXug

Set<Marker> tempMarkers = Set<Marker>();
//Bus stop data

BitmapDescriptor busStopLocationIcon;

LatLng pinPosition1 = LatLng(40.9747, 29.1531);
LatLng pinPosition2 = LatLng(40.9734, 29.1517);
LatLng pinPosition3 = LatLng(40.9726, 29.1508);
LatLng pinPosition4 = LatLng(40.9721, 29.1505);
LatLng pinPosition5 = LatLng(40.9707, 29.1527);
LatLng pinPosition6 = LatLng(40.9699, 29.1543);
LatLng pinPosition7 = LatLng(40.9708, 29.1544);
LatLng pinPosition8 = LatLng(40.9717, 29.1537);
LatLng pinPosition9 = LatLng(40.9729, 29.1521);
LatLng pinPosition10 = LatLng(40.9748, 29.1533);

LatLng pinPosition11 = LatLng(40.9732, 29.1518);

MarkerId markerId1 = MarkerId("1");
MarkerId markerId2 = MarkerId("2");
MarkerId markerId3 = MarkerId("3");
MarkerId markerId4 = MarkerId("4");
MarkerId markerId5 = MarkerId("5");
MarkerId markerId6 = MarkerId("6");
MarkerId markerId7 = MarkerId("7");
MarkerId markerId8 = MarkerId("8");
MarkerId markerId9 = MarkerId("9");
MarkerId markerId10 = MarkerId("10");
MarkerId markerId11 = MarkerId("11");

Marker marker1=Marker(markerId: markerId1,
    position: LatLng(40.9748, 29.1532),
    icon: busStopLocationIcon,
    infoWindow: InfoWindow(
        title: "1. Stop",
    )
);
Marker marker2=Marker(markerId: markerId2,
    position: pinPosition2,
    icon: busStopLocationIcon,
    infoWindow: InfoWindow(
        title: "2. Stop",
    )
);
Marker marker3=Marker(markerId: markerId3,
    position: pinPosition3,
    icon: busStopLocationIcon,
    infoWindow: InfoWindow(
        title: "3. Stop",
    )
);
Marker marker4=Marker(markerId: markerId4,
    position: pinPosition4,
    icon: busStopLocationIcon,
    infoWindow: InfoWindow(
        title: "4. Stop",
    )
);
Marker marker5=Marker(markerId: markerId5,
    position: pinPosition5,
    icon: busStopLocationIcon,
    infoWindow: InfoWindow(
        title: "5. Stop",
    )
);
Marker marker6=Marker(markerId: markerId6,
    position: pinPosition6,
    icon: busStopLocationIcon,
    infoWindow: InfoWindow(
        title: "6. Stop",
    )
);
Marker marker7=Marker(markerId: markerId7,
    position: pinPosition7,
    icon: busStopLocationIcon,
    infoWindow: InfoWindow(
        title: "7. Stop",
    )
);
Marker marker8=Marker(markerId: markerId8,
    position: pinPosition8,
    icon: busStopLocationIcon,
    infoWindow: InfoWindow(
        title: "8. Stop",
    )
);
Marker marker9=Marker(markerId: markerId9,
    position: pinPosition9,
    icon: busStopLocationIcon,
    infoWindow: InfoWindow(
        title: "9. Stop",
    )
);
Marker marker10=Marker(markerId: markerId10,
    position: pinPosition10,
    icon: busStopLocationIcon,
    infoWindow: InfoWindow(
        title: 'Last Stop'
    )
);
Marker marker11=Marker(markerId: markerId11,
    position: pinPosition11,
    icon: busStopLocationIcon,
    infoWindow: InfoWindow(
        title: '10. Stop'
    )
);

//Bus stop data ends