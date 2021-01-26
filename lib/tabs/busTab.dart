import 'dart:async';
import 'dart:io';
import 'package:bus_tracking_system/screens/routeDetailsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../globalVariables.dart';

class BusTab extends StatefulWidget {

  static const String id = 'bus';

  @override
  _BusTabState createState() => _BusTabState();
}

class _BusTabState extends State<BusTab> {

  Set<Marker> markersBusTab = {};
  Set<Polyline> _polyline = {};

  // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
  // this is the key object - the PolylinePoints
  // which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();

  List<LatLng> latlngSegment1 = List();
  List<LatLng> latlngSegment2 = List();
  List<LatLng> latlngSegment3 = List();

  double mapBottomPadding = 0;

  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  final CameraPosition googlePlex = CameraPosition(
    target: LatLng(40.9708, 29.1530),
    zoom: 16.4746,
  );

  void createBusStopMarker(){
    if(busStopLocationIcon == null){
      //ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(1, 1));
      BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 2.5),
          (Platform.isAndroid) ? 'images/stopMarker3.png' : 'images/stopMarker.png'
      ).then((icon){
        busStopLocationIcon = icon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    createBusStopMarker();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapBottomPadding),
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: googlePlex,
            markers: markersBusTab,
            polylines: _polyline,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              mapController = controller;

              setPolylines();

              setState(() {
                //mapBottomPadding = (Platform.isAndroid) ? 280 : 270;

                markersBusTab.add(marker1);
                markersBusTab.add(marker2);
                markersBusTab.add(marker3);
                markersBusTab.add(marker4);
                markersBusTab.add(marker5);
                markersBusTab.add(marker6);
                markersBusTab.add(marker7);
                markersBusTab.add(marker8);
                markersBusTab.add(marker9);
                markersBusTab.add(marker10);
                markersBusTab.add(marker11);
              });
            },
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: (Platform.isAndroid) ? 420 : 550,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15.0,
                    spreadRadius: 0.5,
                    offset: Offset(
                      0.7,
                      0.7,
                    )
                  )
                ]
              ),
              child: buildListView(context)
              ),
            )
        ],
      ),
    );
  }

  ListView buildListView(BuildContext context){
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (_, indexRoute) {
        return Card(
          child: ListTile(
              title: Text('Route ${indexRoute+1}'),
              /*trailing: IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RouteDetailsPage(indexRoute)));
                },
              ),*/
                onTap: () {
                 switchRoutes(indexRoute);
                },
          ),
        );
      },
    );
  }

  void switchRoutes(int indexRoute) {
    if(indexRoute == 0){
      setPolylines();
      latlngSegment2.clear();
      latlngSegment3.clear();
      latlngSegment1.add(pinPosition1);
      latlngSegment1.add(pinPosition2);
      latlngSegment1.add(pinPosition3);
      latlngSegment1.add(pinPosition4);
      latlngSegment1.add(pinPosition5);
      latlngSegment1.add(pinPosition6);
      latlngSegment1.add(pinPosition7);
      latlngSegment1.add(pinPosition8);
      latlngSegment1.add(pinPosition9);
      latlngSegment1.add(pinPosition11);
      latlngSegment1.add(pinPosition10);
    } else if(indexRoute == 1){
      setPolylines();
      latlngSegment1.clear();
      latlngSegment3.clear();
      latlngSegment2.add(pinPosition1);
      latlngSegment2.add(pinPosition2);
      latlngSegment2.add(pinPosition9);
      latlngSegment2.add(pinPosition8);
      latlngSegment2.add(pinPosition5);
      latlngSegment2.add(pinPosition6);
      latlngSegment2.add(pinPosition7);
      latlngSegment2.add(pinPosition8);
      latlngSegment2.add(pinPosition9);
      latlngSegment2.add(pinPosition10);
    } else {
      setPolylines();
      latlngSegment1.clear();
      latlngSegment2.clear();
      latlngSegment3.add(pinPosition1);
      latlngSegment3.add(pinPosition2);
      latlngSegment3.add(pinPosition3);
      latlngSegment3.add(pinPosition4);
      latlngSegment3.add(pinPosition5);
      latlngSegment3.add(pinPosition8);
      latlngSegment3.add(pinPosition9);
      latlngSegment3.add(pinPosition11);
      latlngSegment3.add(pinPosition10);
    }
  }

  void setPolylines() {

    setState(() {

      _polyline.add(Polyline(
        polylineId: PolylineId('line1'),
        visible: true,
        //latlng is List<LatLng>
        points: latlngSegment1,
        width: 5,
        color: Colors.blueAccent,
      ));

      //different sections of polyline can have different colors
      _polyline.add(Polyline(
        polylineId: PolylineId('line2'),
        visible: true,
        points: latlngSegment2,
        width: 5,
        color: Colors.redAccent,
      ));

      _polyline.add(Polyline(
        polylineId: PolylineId('line3'),
        visible: true,
        points: latlngSegment3,
        width: 5,
        color: Colors.greenAccent,
        geodesic: true,
      ));
    });
  }

  /*setPolylines() async {
    /*List<PointLatLng> result = await polylinePoints.getRouteBetweenCoordinates(
        mapKey,
        pinPosition1.latitude,
        pinPosition1.longitude,
        pinPosition2.latitude,
        pinPosition2.longitude
    );*/

    print(pinPosition1.latitude);
    print(pinPosition1.longitude);
    if(result.isNotEmpty){
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.forEach((PointLatLng point){
        polylineCoordinates.add(
            LatLng(point.latitude, point.longitude));
        });
    }

    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId('poly'),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates
      );

        // add the constructed polyline as a set of points
        // to the polyline set, which will eventually
        // end up showing up on the map
        polyLines.add(polyline);
    });
  }*/
}
