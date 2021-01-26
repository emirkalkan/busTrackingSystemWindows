import 'dart:async';

import 'package:bus_tracking_system/brand_colors.dart';
import 'package:bus_tracking_system/globalVariables.dart';
import 'package:bus_tracking_system/helpers/helperMethods.dart';
import 'package:bus_tracking_system/tabs/homeTab.dart';
import 'package:bus_tracking_system/widgets/ConfirmSheet.dart';
import 'package:bus_tracking_system/widgets/TaxiOutlineButton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusStopTimePage extends StatefulWidget {

  final int index;


  BusStopTimePage(this.index);

  @override
  _BusStopTimePageState createState() => _BusStopTimePageState();
}

class _BusStopTimePageState extends State<BusStopTimePage> {

  DatabaseReference timeRef;
  StreamSubscription<Event> rideSubscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BrandColors.colorAccent,
        title: Text('Bus Stop Schedule Time'),
      ),
      body: buildListView(context)
    );
  }

  ListView buildListView(BuildContext context){
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (_, index) {
        return Card(
          child: ListTile(
              title: Text('Bus ${index+1}'),
              subtitle: Text(tripStatusDisplay),
              trailing: IconButton(
                icon:  Icon(Icons.alarm),
                alignment: Alignment.center,
                onPressed: () async{

                  showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    builder: (BuildContext context) => ConfirmSheet(
                      title: 'Set Alarm',
                      subtitle: 'Would you like to set an alarm to No.${index+1} bus for this stop?',

                      onPressed: (){
                        //estimate time fonksiyonu gelecek.
                        //createTimeRequest();
                        Navigator.pop(context);
                      }
                    ),
                  );
                },
              ),
          ),
        );
      },
    );
  }

  /*void createTimeRequest(){
    timeRef = FirebaseDatabase.instance.reference().child('timeRequest').push();

    Map busMap = {
      'latitudeBus': driverLat,
      'longitudeBus': driverLong,
    };

    Map destinationMap = {
      'latitude': pinPosition1.latitude,
      'longitude': pinPosition1.longitude,
    };

    Map rideMap = {
      'driverId': driverKey,
      'location': busMap,
      'destination': destinationMap,
    };
    
    timeRef.set(rideMap);

    rideSubscription = timeRef.onValue.listen((event) async {

      //check for null snapshot
      if(event.snapshot.value == null){
        return;
      }

      //get and use driver location updates
      if(event.snapshot.value['location'] != null){
        print('as');
        double driverLat = double.parse(event.snapshot.value['location']['latitudeBus'].toString());
        double driverLng = double.parse(event.snapshot.value['location']['longitudeBus'].toString());
        LatLng driverLocation = LatLng(driverLat, driverLng);
        print(driverLat);
        print(driverLng);
        updateToPickUp(driverLocation);
      }

    });

  }*/

  Future<void> updateToPickUp(LatLng driverLocation) async {

    var positionLatLng = LatLng(pinPosition1.latitude, pinPosition1.longitude);

    var thisDetails = await HelperMethods.getDirectionDetails(driverLocation, positionLatLng);

    if(thisDetails == null){
      print('üzgünüm babalık :(');
      return;
    }

    setState(() {
      tripStatusDisplay = 'Driver is Arriving - ${thisDetails.durationText}';
    });

  }
}
