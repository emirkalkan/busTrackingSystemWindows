import 'dart:async';

import 'package:bus_tracking_system/brand_colors.dart';
import 'package:bus_tracking_system/dataModels/nearbyDrivers.dart';
import 'package:bus_tracking_system/globalVariables.dart';
import 'package:bus_tracking_system/helpers/pushNotificationService.dart';
import 'package:bus_tracking_system/widgets/ConfirmSheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTabDriver extends StatefulWidget {
  @override
  _HomeTabDriverState createState() => _HomeTabDriverState();
}

class _HomeTabDriverState extends State<HomeTabDriver> {

  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  Position currentPosition;
  DatabaseReference tripRequestRef;

  var geoLocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 4);

  String availabilityTitle = 'GO ONLINE';
  Color availabilityColor = BrandColors.colorOrange;

  bool isAvailable = false;

  void getCurrentPosition() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    //alttaki speed bulma
    var options = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    geoLocator.getPositionStream(options).listen((position) {
      var speedInMps = position.speed;
      speedInMps *= 1.609344;
      print(speedInMps);
    });
    //LatLng pos = LatLng(position.latitude, position.longitude);
    //mapController.animateCamera(CameraUpdate.newLatLng(pos));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          padding: EdgeInsets.only(top: 150),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: googlePlex,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
            mapController = controller;

            getCurrentPosition();
          },
        ),
        Container(
          height: 135,
          width: double.infinity,
          color: BrandColors.colorPrimary,
        ),

        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: () async{
                  //GoOnline();
                  //getLocationUpdates();
                  showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    builder: (BuildContext context) => ConfirmSheet(
                      title: (!isAvailable) ? 'GO ONLINE' : 'GO OFFLINE',
                      subtitle: (!isAvailable) ? 'You are about to available for Yeditepe University Ring Bus trips as a driver.' : 'You will stop sharing your location and finish the trip.',

                      onPressed: (){
                        if(!isAvailable){
                          GoOnline();
                          getLocationUpdates();
                          Navigator.pop(context);

                          setState(() {
                            availabilityColor = BrandColors.colorGreen;
                            availabilityTitle = 'GO OFFLINE';
                            isAvailable = true;
                          });
                        }else{

                          GoOffline();
                          Navigator.pop(context);

                          setState(() {
                            availabilityColor = BrandColors.colorOrange;
                            availabilityTitle = 'GO ONLINE';
                            isAvailable = false;
                          });
                        }
                      },
                    ),
                  );
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25)
                ),
                color: availabilityColor,
                textColor: Colors.white,
                child: Container(
                  height: 50,
                  width: 300,
                  child: Center(
                    child: Text(
                      availabilityTitle,
                      style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )

      ],
    );
  }

  void GoOnline(){
    Geofire.initialize('driversAvailable');
    Geofire.setLocation(user.uid, currentPosition.latitude, currentPosition.longitude);
    
    tripRequestRef = FirebaseDatabase.instance.reference().child('drivers/${user.uid}/newtrip');
    tripRequestRef.set('waiting');
    
    tripRequestRef.onValue.listen((event) {

    });
  }

  void GoOffline() {

    Geofire.removeLocation(user.uid);
    tripRequestRef.onDisconnect();
    tripRequestRef.remove();
    tripRequestRef = null;
  }

  void getLocationUpdates(){

    homeTabPositionStream = geoLocator.getPositionStream(locationOptions).listen((Position position) {
      currentPosition = position;

      if(isAvailable){
        Geofire.setLocation(user.uid, position.latitude, position.longitude);
        /*NearbyDriver driver = NearbyDriver();
        driver.key = user.uid;
        driver.latitude = position.latitude;
        driver.longitude = position.longitude;
        driverList.add(driver);
        //print(driverList.length);
        print(driverList[0].key);
        print(driverList[0].latitude);
        print(driverList[0].longitude);*/
      }

      LatLng pos = LatLng(position.latitude, position.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(pos));
    });
  }
}
