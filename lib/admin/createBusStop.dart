import 'package:bus_tracking_system/brand_colors.dart';
import 'package:bus_tracking_system/widgets/ProgressDialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class AdminBusStopPage extends StatefulWidget {

  static const String id = 'adminBusStop';

  @override
  _AdminBusStopPageState createState() => _AdminBusStopPageState();
}

class _AdminBusStopPageState extends State<AdminBusStopPage> {

  final GlobalKey<ScaffoldState> scaffoldKey= new GlobalKey<ScaffoldState>();

  void showSnackBar(String title){
    final snackbar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  var stopController = TextEditingController();
  var latitudeController = TextEditingController();
  var longitudeController = TextEditingController();
  var uuid = Uuid();

  void createRoute() async {

    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Creating Bus Stop..',),
    );


    DatabaseReference newBusStopRef = FirebaseDatabase.instance.reference().child('busStops/${stopController.text}');
    //Prepare data to be saved on users  table
    Map userMap = {
      'busStopId': uuid,
      'latitude': latitudeController.text,
      'longitude': longitudeController.text,
    };
    newBusStopRef.set(userMap);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 50,),
                Image(
                  alignment: Alignment.center,
                  height: 150.0,
                  width: 150,
                  image: AssetImage('images/logoBus.png'),
                ),

                SizedBox(height: 20,),

                Text('Create Bus Stops',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[

                      //Route Name/No
                      TextField(
                        controller: stopController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Bus Stop Name/No',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 10.0,),

                      //Email
                      TextField(
                        controller: latitudeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Latitude',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 10.0,),

                      //Phone
                      TextField(
                        controller: longitudeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Longitude',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 40,),

                      RaisedButton(
                        onPressed: () async{

                          //check network availability

                          var connectivityResult = await Connectivity().checkConnectivity();
                          if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
                            showSnackBar('No internet connection!');
                            return;
                          }
                          createRoute();

                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(25)
                        ),
                        color: BrandColors.colorAccent,
                        textColor: Colors.white,
                        child: Container(
                          height: 50,
                          child: Center(
                            child: Text(
                              'CREATE BUS STOP',
                              style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
                            ),
                          ),
                        ),
                      )

                    ],
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

