import 'dart:async';
import 'dart:math';
import 'package:bus_tracking_system/globalVariables.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  //markers
  BitmapDescriptor busStopLocationIcon;
  Map<MarkerId,Marker> markers = {};
  List listMarkerIds=List();

  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'images/stopMarker3.png').then((onValue) {
          busStopLocationIcon = onValue;
        });
  }

  Widget build(BuildContext context) {

    LatLng pinPosition1 = LatLng(40.9747, 29.1531);
    LatLng pinPosition2 = LatLng(40.9734, 29.1517);
    LatLng pinPosition3 = LatLng(40.9726, 29.1508);
    LatLng pinPosition4 = LatLng(40.9721, 29.1505);
    LatLng pinPosition5 = LatLng(40.9707, 29.1527);
    LatLng pinPosition6 = LatLng(40.9699, 29.1543);
    LatLng pinPosition7 = LatLng(40.9708, 29.1544);
    LatLng pinPosition8 = LatLng(40.9717, 29.1537);
    LatLng pinPosition9 = LatLng(40.9725, 29.1521);
    LatLng pinPosition10 = LatLng(40.9748, 29.1533);

    return Stack(
      children: <Widget>[
        GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.satellite,
          initialCameraPosition: googlePlex,
          markers: Set.of(markers.values),
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
            mapController = controller;

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

            listMarkerIds.add(markerId1);
            listMarkerIds.add(markerId2);
            listMarkerIds.add(markerId3);
            listMarkerIds.add(markerId4);
            listMarkerIds.add(markerId5);
            listMarkerIds.add(markerId6);
            listMarkerIds.add(markerId7);
            listMarkerIds.add(markerId8);
            listMarkerIds.add(markerId9);
            listMarkerIds.add(markerId10);

            Marker marker1=Marker(markerId: markerId1,
              position: LatLng(40.9748, 29.1532),
              icon: busStopLocationIcon,
              infoWindow: InfoWindow(
                title: "1. Stop",
              )
            );
            Marker marker2=Marker(markerId: markerId2,
                position: pinPosition2,
                icon: busStopLocationIcon
            );
            Marker marker3=Marker(markerId: markerId3,
              position: pinPosition3,
              icon: busStopLocationIcon,
            );
            Marker marker4=Marker(markerId: markerId4,
              position: pinPosition4,
              icon: busStopLocationIcon,
            );
            Marker marker5=Marker(markerId: markerId5,
              position: pinPosition5,
              icon: busStopLocationIcon,
            );
            Marker marker6=Marker(markerId: markerId6,
              position: pinPosition6,
              icon: busStopLocationIcon,
            );
            Marker marker7=Marker(markerId: markerId7,
              position: pinPosition7,
              icon: busStopLocationIcon,
            );
            Marker marker8=Marker(markerId: markerId8,
              position: pinPosition8,
              icon: busStopLocationIcon,
            );
            Marker marker9=Marker(markerId: markerId9,
              position: pinPosition9,
              icon: busStopLocationIcon,
            );
            Marker marker10=Marker(markerId: markerId10,
              position: pinPosition10,
              icon: busStopLocationIcon,
              infoWindow: InfoWindow(
                title: 'Last Stop'
              )
            );

            setState(() {
              markers[markerId1]=marker1;
              markers[markerId2]=marker2;
              markers[markerId3]=marker3;
              markers[markerId4]=marker4;
              markers[markerId5]=marker5;
              markers[markerId6]=marker6;
              markers[markerId7]=marker7;
              markers[markerId8]=marker8;
              markers[markerId9]=marker9;
              markers[markerId10]=marker10;
            });
          },
        )
      ],
    );
  }
}
