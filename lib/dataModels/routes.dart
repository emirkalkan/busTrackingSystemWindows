import 'package:bus_tracking_system/dataModels/busStops.dart';
import 'package:firebase_database/firebase_database.dart';

class Route {
  int routeId;
  String routeName;
  int hour;
  int minute;
  String driverKey;


  Route({
    this.routeId,
    this.routeName,
    this.hour,
    this.minute,
    this.driverKey
  });

}