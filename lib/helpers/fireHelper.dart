import 'package:bus_tracking_system/dataModels/busStops.dart';
import 'package:bus_tracking_system/dataModels/nearbyDrivers.dart';
import 'package:bus_tracking_system/dataModels/routes.dart';
import 'package:bus_tracking_system/globalVariables.dart';

class FireHelper{
  static List<NearbyDriver> nearbyDriverList = [];

  static void removeFromList(String key){

    int index = nearbyDriverList.indexWhere((element) => element.key == key);
    nearbyDriverList.removeAt(index);
  }

  static void updateNearbyLocation(NearbyDriver driver){

    int index = nearbyDriverList.indexWhere((element) => element.key == driver.key);

    nearbyDriverList[index].latitude = driver.latitude;
    nearbyDriverList[index].longitude = driver.longitude;
  }
  static void updateRoute(NearbyDriver driver, String selectedRoute){

    int index = nearbyDriverList.indexWhere((element) => element.key == driver.key);
    print(index);
    nearbyDriverList[index].routeName = selectedRoute;
    print(nearbyDriverList[index].routeName);
  }


}