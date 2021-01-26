import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bus_tracking_system/brand_colors.dart';
import 'package:bus_tracking_system/globalVariables.dart';
import 'package:bus_tracking_system/helpers/helperMethods.dart';
import 'package:bus_tracking_system/helpers/pushNotificationService.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class BusStopTab extends StatefulWidget {

  static const String id = 'busStop';

  @override
  _BusStopTabState createState() => _BusStopTabState();
}

class _BusStopTabState extends State<BusStopTab> {

  Random random = new Random();
  var a;

  Future<Null> refreshList() async {
    setState(() {
      a = random.nextInt(100);
      //Future.delayed(Duration(seconds: 2));
      HelperMethods.getTime();
      Future.delayed(Duration(seconds: 2));
      getUpdateLocationDriver(-2);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUpdateLocationDriver(-1);
    HelperMethods.addEstimateTimeToStartingTime();
    Future.delayed(Duration(seconds: 2));
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BusStopTab oldWidget) {
    // TODO: implement didUpdateWidget
    //getUpdateLocationDriver(index);
    //HelperMethods.getTime();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BrandColors.colorAccent,
        title: Text(
        'Bus Stops',
        ),
      ),
      //body: buildListView(context),
      body: RefreshIndicator(
        onRefresh: refreshList,
        child: buildListView(context),
      ),
      /*body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) =>
          EntryItem(data[index]),*/
    );
  }

  ListView buildListView(BuildContext context){
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (_, index) {
        return Card(
          child: ExpansionTile(
            title: Text(
              //"Bus Stops ${a}",
                "Bus Stops",
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
              ),
            ),
            leading: Icon(Icons.account_balance),
            children: <Widget>[
              for(var i  = 0; i < 10; i++)
                ExpansionTile(
                  title: Text(
                    'Bus Stop ${i+1}',
                  ),
                  leading: Icon(Icons.account_balance),
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.airport_shuttle_outlined),
                      title: (delayTime != 0 && (busStopDelayId--) <= i) ? Text(
                        'Plate No: ${plateNoDriver} - ${time[i]['hour']} : ${time[i]['minute']}\n Delayed ${delayTime} minutes..',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ) : Text(
                          'Plate No: ${plateNoDriver} - ${time[i]['hour']} : ${time[i]['minute']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: (estimateTimeFromFirstBusStop[i] > 0) ? Text('Arrival Time: ${estimateTimeFromFirstBusStop[i]} minute') : (estimateTimeFromFirstBusStop[i] == 0) ? Text('Bus arrived..') : Text(''), //eksi mi diye bakarsın o datayı paylaşmazsın!
                      trailing: IconButton(
                        icon: Icon(Icons.alarm),
                        onPressed: (){
                          _showDialog(context, 'Bus Stop ${i+1}');
                          index = i;
                          getUpdateLocationDriver(i);
                        },
                      ),
                    ),
                  ],
                ),
              /*ExpansionTile(
                title: Text(
                  'Bus Stop 1',
                ),
                leading: Icon(Icons.account_balance),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.airport_shuttle_outlined),
                    title: Text(
                      'Plate No: ${plateNoDriver} - ${time[0]['hour']} : ${time[0]['minute']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: (estimateTimeFromFirstBusStop[0] > 0) ? Text('Arrival Time: ${estimateTimeFromFirstBusStop[0]} minute ') : (estimateTimeFromFirstBusStop[0] == 0) ? Text('Bus arrived..') : Text('No info.'), //eksi mi diye bakarsın o datayı paylaşmazsın!
                    trailing: IconButton(
                      icon: Icon(Icons.alarm),
                      onPressed: (){
                        _showDialog(context, 'Bus Stop 1');
                        index = 0;
                        getUpdateLocationDriver(0);
                      },
                    ),
                  )
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Bus Stop 2',
                ),
                leading: Icon(Icons.account_balance),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.airport_shuttle_outlined),
                    title: Text(
                      'Plate No: ${plateNoDriver} - ${time[1]['hour']} : ${time[1]['minute']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: (estimateTimeFromFirstBusStop[1] > 0) ? Text('Arrival Time: ${estimateTimeFromFirstBusStop[1]} minute ') : (estimateTimeFromFirstBusStop[1] == 0) ? Text('Bus arrived..') : Text('No info.'), //eksi mi diye bakarsın o datayı paylaşmazsın!

                    trailing: IconButton(
                      icon: Icon(Icons.alarm),
                      onPressed: (){
                        _showDialog(context, 'Bus Stop 2');
                        index = 1;
                        getUpdateLocationDriver(1);
                      },
                    ),
                  )
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Bus Stop 3',
                ),
                leading: Icon(Icons.account_balance),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.airport_shuttle_outlined),
                    title: Text(
                      'Plate No: ${plateNoDriver} - ${time[2]['hour']} : ${time[2]['minute']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: (estimateTimeFromFirstBusStop[2] > 0) ? Text('Arrival Time: ${estimateTimeFromFirstBusStop[2]} minute ') : (estimateTimeFromFirstBusStop[2] == 0) ? Text('Bus arrived..') : Text('No info.'), //eksi mi diye bakarsın o datayı paylaşmazsın!

                    trailing: IconButton(
                      icon: Icon(Icons.alarm),
                      onPressed: (){
                        _showDialog(context, 'Bus Stop 3');
                        index = 2;
                        getUpdateLocationDriver(2);
                      },
                    ),
                  )
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Bus Stop 4',
                ),
                leading: Icon(Icons.account_balance),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.airport_shuttle_outlined),
                    title: Text(
                      'Plate No: ${plateNoDriver} - ${time[0]['hour']} : ${time[0]['minute']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: (estimateTimeFromFirstBusStop[3] > 0) ? Text('Arrival Time: ${estimateTimeFromFirstBusStop[3]} minute ') : (estimateTimeFromFirstBusStop[3] == 0) ? Text('Bus arrived..') : Text('No info.'), //eksi mi diye bakarsın o datayı paylaşmazsın!
                    trailing: IconButton(
                      icon: Icon(Icons.alarm),
                      onPressed: (){
                        _showDialog(context, 'Bus Stop 4');
                        index = 3;
                        getUpdateLocationDriver(3);
                      },
                    ),
                  )
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Bus Stop 5',
                ),
                leading: Icon(Icons.account_balance),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.airport_shuttle_outlined),
                    title: Text(
                      'Plate No: ${plateNoDriver} - ${time[0]['hour']} : ${time[0]['minute']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: (estimateTimeFromFirstBusStop[4] > 0) ? Text('Arrival Time: ${estimateTimeFromFirstBusStop[4]} minute ') : (estimateTimeFromFirstBusStop[4] == 0) ? Text('Bus arrived..') : Text('No info.'), //eksi mi diye bakarsın o datayı paylaşmazsın!
                    trailing: IconButton(
                      icon: Icon(Icons.alarm),
                      onPressed: (){
                        _showDialog(context, 'Bus Stop 5');
                        index = 4;
                        getUpdateLocationDriver(4);
                      },
                    ),
                  )
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Bus Stop 6',
                ),
                leading: Icon(Icons.account_balance),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.airport_shuttle_outlined),
                    title: Text(
                      'Plate No: ${plateNoDriver} - ${time[0]['hour']} : ${time[0]['minute']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: (estimateTimeFromFirstBusStop[5] > 0) ? Text('Arrival Time: ${estimateTimeFromFirstBusStop[5]} minute ') : (estimateTimeFromFirstBusStop[5] == 0) ? Text('Bus arrived..') : Text('No info.'), //eksi mi diye bakarsın o datayı paylaşmazsın!
                    trailing: IconButton(
                      icon: Icon(Icons.alarm),
                      onPressed: (){
                        _showDialog(context, 'Bus Stop 6');
                        index = 5;
                        getUpdateLocationDriver(5);
                      },
                    ),
                  )
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Bus Stop 7',
                ),
                leading: Icon(Icons.account_balance),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.airport_shuttle_outlined),
                    title: Text(
                      'Plate No: ${plateNoDriver} - ${time[0]['hour']} : ${time[0]['minute']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: (estimateTimeFromFirstBusStop[6] > 0) ? Text('Arrival Time: ${estimateTimeFromFirstBusStop[6]} minute ') : (estimateTimeFromFirstBusStop[6] == 0) ? Text('Bus arrived..') : Text('No info.'), //eksi mi diye bakarsın o datayı paylaşmazsın!
                    trailing: IconButton(
                      icon: Icon(Icons.alarm),
                      onPressed: (){
                        _showDialog(context, 'Bus Stop 7');
                        index = 6;
                        getUpdateLocationDriver(6);
                      },
                    ),
                  )
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Bus Stop 8',
                ),
                leading: Icon(Icons.account_balance),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.airport_shuttle_outlined),
                    title: Text(
                      'Plate No: ${plateNoDriver} - ${time[0]['hour']} : ${time[0]['minute']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: (estimateTimeFromFirstBusStop[7] > 0) ? Text('Arrival Time: ${estimateTimeFromFirstBusStop[7]} minute ') : (estimateTimeFromFirstBusStop[7] == 0) ? Text('Bus arrived..') : Text('No info.'), //eksi mi diye bakarsın o datayı paylaşmazsın!
                    trailing: IconButton(
                      icon: Icon(Icons.alarm),
                      onPressed: (){
                        _showDialog(context, 'Bus Stop 8');
                        index = 7;
                        getUpdateLocationDriver(7);
                      },
                    ),
                  )
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Bus Stop 9',
                ),
                leading: Icon(Icons.account_balance),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.airport_shuttle_outlined),
                    title: Text(
                      'Plate No: ${plateNoDriver} - ${time[0]['hour']} : ${time[0]['minute']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: (estimateTimeFromFirstBusStop[8] > 0) ? Text('Arrival Time: ${estimateTimeFromFirstBusStop[8]} minute ') : (estimateTimeFromFirstBusStop[8] == 0) ? Text('Bus arrived..') : Text('No info.'), //eksi mi diye bakarsın o datayı paylaşmazsın!
                    trailing: IconButton(
                      icon: Icon(Icons.alarm),
                      onPressed: (){
                        _showDialog(context, 'Bus Stop 9');
                        index = 8;
                        getUpdateLocationDriver(8);
                      },
                    ),
                  )
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Bus Stop 10',
                ),
                leading: Icon(Icons.account_balance),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.airport_shuttle_outlined),
                    title: Text(
                      'Plate No: ${plateNoDriver} - ${time[0]['hour']} : ${time[0]['minute']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: (estimateTimeFromFirstBusStop[9] > 0) ? Text('Arrival Time: ${estimateTimeFromFirstBusStop[9]} minute ') : (estimateTimeFromFirstBusStop[9] == 0) ? Text('Bus arrived..') : Text('No info.'), //eksi mi diye bakarsın o datayı paylaşmazsın!
                    trailing: IconButton(
                      icon: Icon(Icons.alarm),
                      onPressed: (){
                        _showDialog(context, 'Bus Stop 10');
                        index = 9;
                        getUpdateLocationDriver(9);
                      },
                    ),
                  )
                ],
              ),*/
            ],
          ),
        );
      },
    );
  }

  void getUpdateLocationDriver(int index) async {

    FirebaseDatabase.instance.reference().child('driversAvailable').onValue.listen((event) async {
      print(event.snapshot.value);
      //check for null snapshot
      if(event.snapshot.value == null){
        return;
      }/* else{
      for(var i = 0; i < driverKeyList.length; i++) {
        print('driver key: ${driverKeyList[i]}');
        if(event.snapshot.value[driverKeyList[i]] != null){
          var data = event.snapshot.value[driverKeyList[i]]['g'];
          //print(event.snapshot.value['JQJreQPAa6M5LdKdrDwNh4tNpu03']['g']);
          //print(event.snapshot.value['JQJreQPAa6M5LdKdrDwNh4tNpu03']['l'][0]);
          double driverLat = event.snapshot.value[driverKeyList[i]]['l'][0];
          double driverLng = double.parse(event.snapshot.value[driverKeyList[i]]['l'][1].toString());
          //LatLng driverLocation = LatLng(driverLat, driverLng);
          print(driverLat);
          print(driverLng);
          print(data);
          getEstimateTime(driverLat, driverLng, driverKeyList[i]);
        }
      }
    }*/
      //print(driverId);
      //get and use driver location updates
      if(event.snapshot.value['JQJreQPAa6M5LdKdrDwNh4tNpu03'] != null){
        var data = event.snapshot.value['JQJreQPAa6M5LdKdrDwNh4tNpu03']['g'];
        //print(event.snapshot.value['JQJreQPAa6M5LdKdrDwNh4tNpu03']['g']);
        //print(event.snapshot.value['JQJreQPAa6M5LdKdrDwNh4tNpu03']['l'][0]);
         double driverLat = event.snapshot.value['JQJreQPAa6M5LdKdrDwNh4tNpu03']['l'][0];
         double driverLng = double.parse(event.snapshot.value['JQJreQPAa6M5LdKdrDwNh4tNpu03']['l'][1].toString());
        //Yukarıyı bi dene farklılar!!!!!!!!!!!
        //LatLng driverLocation = LatLng(driverLat, driverLng);
        print(driverLat);
        print(driverLng);
        print(data);
        //await Future.delayed(Duration(seconds: 3));
        getEstimateTime(driverLat, driverLng, index);
      }
    });
  }

  Future<void> getEstimateTime(double driverLat, double driverLng, int index) async {
    print('index : ${index}');

    if(index != -1){
      var geoLocator = Geolocator();
      double distanceInMeters;

      List<dynamic> data = [
        {
          'lat': pinPosition1.latitude,
          'lng': pinPosition1.longitude
        },
        {
          'lat': pinPosition2.latitude,
          'lng': pinPosition2.longitude
        },
        {
          'lat': pinPosition3.latitude,
          'lng': pinPosition3.longitude
        },
        {
          'lat': pinPosition4.latitude,
          'lng': pinPosition4.longitude
        },
        {
          'lat': pinPosition5.latitude,
          'lng': pinPosition5.longitude
        },
        {
          'lat': pinPosition6.latitude,
          'lng': pinPosition6.longitude
        },
        {
          'lat': pinPosition7.latitude,
          'lng': pinPosition7.longitude
        },
        {
          'lat': pinPosition8.latitude,
          'lng': pinPosition8.longitude
        },
        {
          'lat': pinPosition9.latitude,
          'lng': pinPosition9.longitude
        },
        {
          'lat': pinPosition10.latitude,
          'lng': pinPosition10.longitude
        },
      ];

      estimateTimeBusStop.clear();
      //distanceBusStop.clear();
      var thatBusStop = 0;
      var busStopId, busStopName, delayTime;

      for(var i = 0; i < data.length; i++){
        distanceInMeters = await geoLocator.distanceBetween(driverLat, driverLng, data[i]['lat'], data[i]['lng']);
        print('Stop ${i+1} and driver : ${distanceInMeters}');
        if(distanceInMeters <= 10){
          thatBusStop = i ;

          //HelperMethods.soundBusStop(i);
          HelperMethods.timeTable(thatBusStop , estimateTimeFromFirstBusStop);
          print('index: ${index} that: ${thatBusStop}');

          if(index == i){
            print('sasasa');
            pushNotification(index);
          }




        }
        //HelperMethods.timeTable(thatBusStop , estimateTimeFromFirstBusStop);
      }

      /*var thatTime =  estimateTimeFromFirstBusStop[thatBusStop];

      for(var j = 0; j < estimateTimeFromFirstBusStop.length; j++){
        print('that time: ${thatTime}');
        estimateTimeFromFirstBusStop[j] -= thatTime;
        //estimateTimeFromFirstBusStop[j] = double.parse(estimateTimeFromFirstBusStop[j].toStringAsFixed(2));
        //print(double.parse(estimateTimeFromFirstBusStop[j].toStringAsFixed(2)));
        print('Stop ${j+1} time : ${estimateTimeFromFirstBusStop[j]}');
      }

      print('estimate time: ${estimateTimeFromFirstBusStop}');*/

    }


    /*DatabaseReference delayRef = FirebaseDatabase.instance.reference().child('delayTimeOfBuses/-MOSyYP1j3nZpxMS6-2V');
    delayRef.once().then((DataSnapshot snapshot){

      if(snapshot.value != null){
        print('eheheheheeheheheheheeheheeeeeeee');
        busStopId = snapshot.value['busStopId'];
        busStopName = snapshot.value['busStopName'];
        delayTime = snapshot.value['delayTime'];
      }
    });

    for(var i = busStopId; i < estimateTimeFromFirstBusStop.length; i++){
      estimateTimeFromFirstBusStop[i] += delayTime ;
      estimateTimeFromFirstBusStop[i] = double.parse(estimateTimeFromFirstBusStop[j].toStringAsFixed(2));
      print(double.parse(estimateTimeFromFirstBusStop[j].toStringAsFixed(2)));
      print('Stop ${j+1} time : ${estimateTimeFromFirstBusStop[j]}');
    }*/

  }
}

/*void getUpdateLocationDriver() async {

  FirebaseDatabase.instance.reference().child('driversAvailable').onValue.listen((event) async {
    print(event.snapshot.value);
    //check for null snapshot
    if(event.snapshot.value == null){
      return;
    }/* else{
      for(var i = 0; i < driverKeyList.length; i++) {
        print('driver key: ${driverKeyList[i]}');
        if(event.snapshot.value[driverKeyList[i]] != null){
          var data = event.snapshot.value[driverKeyList[i]]['g'];
          //print(event.snapshot.value['JQJreQPAa6M5LdKdrDwNh4tNpu03']['g']);
          //print(event.snapshot.value['JQJreQPAa6M5LdKdrDwNh4tNpu03']['l'][0]);
          double driverLat = event.snapshot.value[driverKeyList[i]]['l'][0];
          double driverLng = double.parse(event.snapshot.value[driverKeyList[i]]['l'][1].toString());
          //LatLng driverLocation = LatLng(driverLat, driverLng);
          print(driverLat);
          print(driverLng);
          print(data);
          getEstimateTime(driverLat, driverLng, driverKeyList[i]);
        }
      }
    }*/
    //print(driverId);
    //get and use driver location updates
    if(event.snapshot.value['JQJreQPAa6M5LdKdrDwNh4tNpu03'] != null){
      var data = event.snapshot.value['JQJreQPAa6M5LdKdrDwNh4tNpu03']['g'];
      //print(event.snapshot.value['JQJreQPAa6M5LdKdrDwNh4tNpu03']['g']);
      //print(event.snapshot.value['JQJreQPAa6M5LdKdrDwNh4tNpu03']['l'][0]);
      double driverLat = event.snapshot.value['JQJreQPAa6M5LdKdrDwNh4tNpu03']['l'][0];
      double driverLng = double.parse(event.snapshot.value['JQJreQPAa6M5LdKdrDwNh4tNpu03']['l'][1].toString());
      //Yukarıyı bi dene farklılar!!!!!!!!!!!
      //LatLng driverLocation = LatLng(driverLat, driverLng);
      print(driverLat);
      print(driverLng);
      print(data);
      //await Future.delayed(Duration(seconds: 5));
      getEstimateTime(driverLat, driverLng);
    }

  });
}*/
//Future<void> getEstimateTime(double driverLat, double driverLng, String driverKey) async {
/*Future<void> getEstimateTime(double driverLat, double driverLng) async {

  var geoLocator = Geolocator();
  double distanceInMeters;

  List<dynamic> data = [
    {
      'lat': pinPosition1.latitude,
      'lng': pinPosition1.longitude
    },
    {
      'lat': pinPosition2.latitude,
      'lng': pinPosition2.longitude
    },
    {
      'lat': pinPosition3.latitude,
      'lng': pinPosition3.longitude
    },
    {
      'lat': pinPosition4.latitude,
      'lng': pinPosition4.longitude
    },
    {
      'lat': pinPosition5.latitude,
      'lng': pinPosition5.longitude
    },
    {
      'lat': pinPosition6.latitude,
      'lng': pinPosition6.longitude
    },
    {
      'lat': pinPosition7.latitude,
      'lng': pinPosition7.longitude
    },
    {
      'lat': pinPosition8.latitude,
      'lng': pinPosition8.longitude
    },
    {
      'lat': pinPosition9.latitude,
      'lng': pinPosition9.longitude
    },
    {
      'lat': pinPosition10.latitude,
      'lng': pinPosition10.longitude
    },
  ];

  //estimateTimeBusStop.clear();
  //distanceBusStop.clear();
  var thatBusStop = 0;

  for(var i = 0; i < data.length; i++){
    distanceInMeters = await geoLocator.distanceBetween(driverLat, driverLng, data[i]['lat'], data[i]['lng']);
    print('Stop ${i+1} and driver : ${distanceInMeters}');
    if(distanceInMeters <= 10){
      thatBusStop = i ;
    }

  }

  var thatTime =  estimateTimeFromFirstBusStop[thatBusStop];

  for(var j = 0; j < estimateTimeFromFirstBusStop.length; j++){
    print('that time: ${thatTime}');
    estimateTimeFromFirstBusStop[j] -= thatTime;
    estimateTimeFromFirstBusStop[j] = double.parse(estimateTimeFromFirstBusStop[j].toStringAsFixed(2));
    print(double.parse(estimateTimeFromFirstBusStop[j].toStringAsFixed(2)));
    print('Stop ${j+1} time : ${estimateTimeFromFirstBusStop[j]}');
  }

  print('estimate time: ${estimateTimeFromFirstBusStop}');

}*/

Future<void> pushNotification(int index) async {

  //for(var i = 0; i < estimateTimeFromFirstBusStop.length; i++){
    //if(estimateTimeFromFirstBusStop[index] == 0){
      //Send notification!
      DatabaseReference tokenRef = FirebaseDatabase.instance.reference().child('passengers/${user.uid}/token');
      tokenRef.once().then((DataSnapshot snapshot){

        if(snapshot.value != null){
          print('eheheheheeheheheheheeheheeeeeeee');
          String token = snapshot.value.toString();
          print(token);
          HelperMethods.sendNotification(token);
        }
      });
    //}
  //}
}

void _showDialog(BuildContext context, String selectedName) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Alarm for $selectedName has started!'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
  );
}
