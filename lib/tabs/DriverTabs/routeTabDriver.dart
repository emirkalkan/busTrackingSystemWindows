import 'package:bus_tracking_system/brand_colors.dart';
import 'package:bus_tracking_system/dataModels/busStops.dart';
import 'package:bus_tracking_system/dataModels/nearbyDrivers.dart';
import 'package:bus_tracking_system/globalVariables.dart';
import 'package:bus_tracking_system/helpers/fireHelper.dart';
import 'package:bus_tracking_system/helpers/helperMethods.dart';
import 'package:bus_tracking_system/tabs/DriverTabs/homeTabDriver.dart';
import 'package:bus_tracking_system/widgets/ConfirmSheet.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RouteTabDriver extends StatefulWidget {

  @override
  _RouteTabDriverState createState() => _RouteTabDriverState();
}

class _RouteTabDriverState extends State<RouteTabDriver> {
  List<Route> _routes = Route.getRoutes();
  List<BusStop> _busStops = BusStop.getBusStops();

  List<DropdownMenuItem<Route>> _dropdownMenuItems;
  List<DropdownMenuItem<BusStop>> _dropdownMenuItemsBusStop;

  Route _selectedRoute;
  BusStop _selectedBusStop;

  DatabaseReference delayTimeRef;
  DatabaseReference busStopIdRef;

  @override
  void initState() {
    _dropdownMenuItemsBusStop = buildDropdownMenuItemsBusStop(_busStops);
    _selectedBusStop = _dropdownMenuItemsBusStop[0].value;

    _dropdownMenuItems = buildDropdownMenuItems(_routes);
    _selectedRoute = _dropdownMenuItems[0].value;

    super.initState();
  }

  List<DropdownMenuItem<Route>> buildDropdownMenuItems(List routes) {
    List<DropdownMenuItem<Route>> items = List();
    for (Route route in routes) {
      items.add(
        DropdownMenuItem(
          value: route,
          child: Text(route.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<BusStop>> buildDropdownMenuItemsBusStop(List busStops) {
    List<DropdownMenuItem<BusStop>> itemsBusStop = List();
    for (BusStop busStop in busStops) {
      itemsBusStop.add(
        DropdownMenuItem(
          value: busStop,
          child: Text(busStop.name),
        ),
      );
    }
    return itemsBusStop;
  }

  onChangeDropdownItem(Route selectedRoute) {
    setState(() {
      _selectedRoute = selectedRoute;
    });
  }

  onChangeDropdownItemBusStop(BusStop selectedBusStop) {
    setState(() {
      _selectedBusStop = selectedBusStop;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Routes List For Drivers"),
          backgroundColor: BrandColors.colorAccent,
        ),
        body: new Container(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Select a route", style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),),
                SizedBox(
                  height: 10.0,
                ),
                DropdownButton(
                  value: _selectedRoute,
                  items: _dropdownMenuItems,
                  onChanged: onChangeDropdownItem,
                  iconEnabledColor: BrandColors.colorAccent,
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Selected: ${_selectedRoute.name}', style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () async{
                    showModalBottomSheet(
                      isDismissible: false,
                      context: context,
                      builder: (BuildContext context) => ConfirmSheet(
                          title: 'Start Route',
                          subtitle: 'Would you like to start the ${_selectedRoute.name} ?',

                          onPressed: () {
                            var driverId = user.uid;
                            driverKeyList.add(driverId);
                            print(driverKeyList);
                            print(driverId);
                            print(_selectedRoute.name);
                            DatabaseReference driverRouteRef = FirebaseDatabase.instance.reference().child('drivers/${driverId}/routeName');
                            driverRouteRef.set(_selectedRoute.name);

                            DateTime now = new DateTime.now();
                            int hour = now.hour;
                            int minute = now.minute;
                            DatabaseReference routeRef = FirebaseDatabase.instance.reference().child('routes').push();
                            Map delayMap = {
                              'driverKey': driverId,
                              'hour': hour,
                              'minute': minute,
                              'routeName': _selectedRoute.name,
                              'routeId': _selectedRoute.id,
                            };
                            routeRef.set(delayMap);
                            //HelperMethods.getStartingTimeRoute();
                            DatabaseReference hourRef = FirebaseDatabase.instance.reference().child('drivers/${driverId}/hour');
                            hourRef.set(hour);
                            DatabaseReference minuteRef = FirebaseDatabase.instance.reference().child('drivers/${driverId}/minute');
                            minuteRef.set(minute);
                            _showDialog(context, _selectedRoute.name);
                          }
                      ),
                    );
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(25)
                  ),
                  color: BrandColors.colorAccent,
                  textColor: Colors.white,
                  child: Container(
                    height: 30,
                    width: 150,
                    child: Center(
                      child: Text(
                        'Start Route',
                        style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () async{
                    showModalBottomSheet(
                      isDismissible: false,
                      context: context,
                      builder: (BuildContext context) => ConfirmSheet(
                          title: 'End Route',
                          subtitle: 'Would you like to end the ${_selectedRoute.name} ?',
                          onPressed: () {
                            delayTimeRef = FirebaseDatabase.instance.reference().child('drivers/${user.uid}/delayTime');
                            delayTimeRef.remove();
                            busStopIdRef = FirebaseDatabase.instance.reference().child('drivers/${user.uid}/busStopDelayId');
                            busStopIdRef.remove();
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: new Text('${_selectedRoute.name} has ended!'),
                                    actions: <Widget>[
                                      new FlatButton(
                                        child: new Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                }
                            );
                          }
                      ),
                    );
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(25)
                  ),
                  color: BrandColors.colorAccent,
                  textColor: Colors.white,
                  child: Container(
                    height: 30,
                    width: 150,
                    child: Center(
                      child: Text(
                        'End Route',
                        style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Select a bus stop for a delay", style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),),
                SizedBox(
                  height: 10.0,
                ),
                DropdownButton(
                  value: _selectedBusStop,
                  items: _dropdownMenuItemsBusStop,
                  onChanged: onChangeDropdownItemBusStop,
                  iconEnabledColor: BrandColors.colorAccent,
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Selected: ${_selectedBusStop.name}', style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () async{
                    showModalBottomSheet(
                      isDismissible: false,
                      context: context,
                      builder: (BuildContext context) => ConfirmSheet(
                          title: 'Inform a Delay',
                          subtitle: 'Would you like to inform a delay for the ${_selectedBusStop.name} ?',
                          onPressed: () {

                            DatabaseReference delayRef = FirebaseDatabase.instance.reference().child('delayTimeOfBuses').push();
                            Map delayMap = {
                              'delayTime': 2,
                              'busStopName': _selectedBusStop.name,
                              'busStopId': _selectedBusStop.id,
                            };
                            delayRef.set(delayMap);
                            var delayTime = 2;
                            DatabaseReference delayTimeRef = FirebaseDatabase.instance.reference().child('drivers/${user.uid}/delayTime');
                            delayTimeRef.set(delayTime);
                            DatabaseReference busStopIdRef = FirebaseDatabase.instance.reference().child('drivers/${user.uid}/busStopDelayId');
                            busStopIdRef.set(_selectedBusStop.id);

                            _showDialog(context, _selectedBusStop.name);

                          }
                      ),
                    );
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(25)
                  ),
                  color: BrandColors.colorAccent,
                  textColor: Colors.white,
                  child: Container(
                    height: 30,
                    width: 150,
                    child: Center(
                      child: Text(
                        'Inform a Delay',
                        style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () async{
                    showModalBottomSheet(
                      isDismissible: false,
                      context: context,
                      builder: (BuildContext context) => ConfirmSheet(
                          title: 'Delete a Delay',
                          subtitle: 'Would you like to delete a delay for the ${_selectedBusStop.name} ?',
                          onPressed: () {
                            delayTimeRef = FirebaseDatabase.instance.reference().child('drivers/${user.uid}/delayTime');
                            delayTimeRef.remove();
                            busStopIdRef = FirebaseDatabase.instance.reference().child('drivers/${user.uid}/busStopDelayId');
                            busStopIdRef.remove();
                            _showDialog(context, _selectedBusStop.name);

                          }
                      ),
                    );
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(25)
                  ),
                  color: BrandColors.colorAccent,
                  textColor: Colors.white,
                  child: Container(
                    height: 30,
                    width: 150,
                    child: Center(
                      child: Text(
                        'Delete a Delay',
                        style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Route {
  int id;
  String name;

  Route(this.id, this.name);

  static List<Route> getRoutes() {
    return <Route>[
      Route(1, 'Route 1'),
      Route(2, 'Route 2'),
      Route(3, 'Route 3'),
    ];
  }
}

class BusStop {
  int id;
  String name;

  BusStop(this.id, this.name);

  static List<BusStop> getBusStops() {
    return <BusStop>[
      BusStop(1, 'Bus Stop 1'),
      BusStop(2, 'Bus Stop 2'),
      BusStop(3, 'Bus Stop 3'),
      BusStop(4, 'Bus Stop 4'),
      BusStop(5, 'Bus Stop 5'),
      BusStop(6, 'Bus Stop 6'),
      BusStop(7, 'Bus Stop 7'),
      BusStop(8, 'Bus Stop 8'),
      BusStop(9, 'Bus Stop 9'),
      BusStop(10, 'Bus Stop 10'),

    ];
  }
}

void _showDialog(BuildContext context, String selectedRouteName) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('$selectedRouteName has started!'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
  );
}

