import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:bus_tracking_system/dataModels/nearbyDrivers.dart';
import 'package:bus_tracking_system/globalVariables.dart';
import 'package:bus_tracking_system/helpers/fireHelper.dart';
import 'package:bus_tracking_system/helpers/helperMethods.dart';
import 'package:bus_tracking_system/helpers/pushNotificationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  //markers
  //BitmapDescriptor busStopLocationIcon;
  //Map<MarkerId,Marker> markers = {};
  //List listMarkerIds=List();
  Set<Marker> markersDriver = {};
  BitmapDescriptor nearbyIcon;

  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  var geoLocator = Geolocator();
  Position currentPosition;

  bool nearbyDriversKeysLoaded = false;

  void setupPositionLocator() async {
    Position position = await geoLocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    //zoom to user's location
    mapController.animateCamera(CameraUpdate.newLatLng(pos));
    //CameraPosition cp = new CameraPosition(target: pos, zoom: 16);
    //mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    startGeofireListener();
  }

  void createMarker(){
    if(nearbyIcon == null){
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(1, 1));
      BitmapDescriptor.fromAssetImage(
          imageConfiguration, (Platform.isIOS)
          ? 'images/busLocationMarker.png'
          : 'images/busLocationMarker5.png'
      ).then((icon){
        nearbyIcon = icon;
      });
    }
  }

  void getCurrentPassengerInfo() async{
    user = auth.currentUser;
    PushNotificationService pushNotificationService = PushNotificationService();

    pushNotificationService.initialize();
    pushNotificationService.getToken();
  }

  @override
  void initState() {
    // TODO: implement initState
    //HelperMethods.getRouteInfo(globalDriver);
    getCurrentPassengerInfo();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant HomeTab oldWidget) {
    // TODO: implement didUpdateWidget
    //HelperMethods.getRouteInfo(globalDriver);
    super.didUpdateWidget(oldWidget);
  }
  /*void createBusStopMarker(){
    if(busStopLocationIcon == null){
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(1, 1));
      BitmapDescriptor.fromAssetImage(
          imageConfiguration,
          'images/stopMarker3.png'
      ).then((icon){
        busStopLocationIcon = icon;
      });
    }
  }*/

  Widget build(BuildContext context) {

    createMarker();
    //createBusStopMarker();

    return Stack(
      children: <Widget>[
        GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
          initialCameraPosition: googlePlex,
          markers: markersDriver,
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
            mapController = controller;
            setState(() {
              /*tempMarkers.add(marker1);
              tempMarkers.add(marker2);
              tempMarkers.add(marker3);
              tempMarkers.add(marker4);
              tempMarkers.add(marker5);
              tempMarkers.add(marker6);
              tempMarkers.add(marker7);
              tempMarkers.add(marker8);
              tempMarkers.add(marker9);
              tempMarkers.add(marker10);*/
            });

            setupPositionLocator();
          },
        )
      ],
    );
  }

  void startGeofireListener(){

    Geofire.initialize('driversAvailable');
    Geofire.queryAtLocation(currentPosition.latitude, currentPosition.longitude, 20).listen((map) {

      if(map != null){
        var callBack = map['callBack'];

        switch(callBack){
          case Geofire.onKeyEntered:

            NearbyDriver nearbyDriver = NearbyDriver();
            nearbyDriver.key = map['key'];
            nearbyDriver.latitude = map['latitude'];
            nearbyDriver.longitude = map['longitude'];
            //nearbyDriver.routeName = routeName;
            FireHelper.nearbyDriverList.add(nearbyDriver);
            if(nearbyDriversKeysLoaded){
              updateDriversOnMap();
            }
            break;

          case Geofire.onKeyExited:

            FireHelper.removeFromList(map['key']);
            updateDriversOnMap();
            break;

          case Geofire.onKeyMoved:
            //update key's location
            NearbyDriver nearbyDriver = NearbyDriver();
            nearbyDriver.key = map['key'];
            nearbyDriver.latitude = map['latitude'];
            nearbyDriver.longitude = map['longitude'];
            //nearbyDriver.routeName = map['routeName'];

            FireHelper.updateNearbyLocation(nearbyDriver);
            updateDriversOnMap();
            break;

          case Geofire.onGeoQueryReady:
            //All initial Data is loaded
            print('Firehelper length: ${FireHelper.nearbyDriverList.length}');
            nearbyDriversKeysLoaded = true;
            updateDriversOnMap();
            break;
        }
      }
    });
  }

  void updateDriversOnMap(){
    setState(() {
      markersDriver.clear();
    });

    Set<Marker> tempMarkers = Set<Marker>();
    for (NearbyDriver driver in FireHelper.nearbyDriverList){
      LatLng driverPosition = LatLng(driver.latitude, driver.longitude);

      driver = HelperMethods.getRouteInfo(driver);
      //globalDriver = driver;
      print('homeTab:  ${driver.routeName}');

      Marker thisMarker = Marker(
        markerId: MarkerId('driver${driver.key}'),
        position: driverPosition,
        icon: nearbyIcon,
        infoWindow: InfoWindow(
          title: (driver.routeName != null) ? 'Route: ${driver.routeName}' : 'No route!',
        ),
        //rotation: HelperMethods.generateRandomNumber(360),
      );
      tempMarkers.add(thisMarker);
    }

    setState(() {
      markersDriver = tempMarkers;
    });
  }
}
