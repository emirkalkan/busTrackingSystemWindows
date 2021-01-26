import 'package:bus_tracking_system/brand_colors.dart';
import 'package:bus_tracking_system/screens/loginPage.dart';
import 'package:bus_tracking_system/screens/mainpage.dart';
import 'package:bus_tracking_system/widgets/ProgressDialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminBusRoutePage extends StatefulWidget {

  static const String id = 'adminBusRoute';

  @override
  _AdminBusRoutePageState createState() => _AdminBusRoutePageState();
}

class _AdminBusRoutePageState extends State<AdminBusRoutePage> {

  final GlobalKey<ScaffoldState> scaffoldKey= new GlobalKey<ScaffoldState>();

  void showSnackBar(String title){
    final snackbar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var routeController = TextEditingController();
  var stopNumberController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var plateController = TextEditingController();
  var emailController = TextEditingController();

  void createRoute() async {

    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Logging you in..',),
    );


        DatabaseReference newPassengerRef = FirebaseDatabase.instance.reference().child('busRoutes/$routeController');
        //Prepare data to be saved on users  table
        Map userMap = {
          'stopNmber': stopNumberController.text,
          'phone': phoneController.text,
          'isDriver': true,
          'plateNo': plateController.text,
        };
        newPassengerRef.set(userMap);
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => ProgressDialog(status: 'Driver successfully created.',),
        );
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

                Text('-Admin- Create bus routes -Admin-',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[

                      //Route Name/No
                      TextField(
                        controller: routeController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Route Name/No',
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
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email Address',
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
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: 'Phone Number',
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

                      //Password
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
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

                      SizedBox(height: 10,),

                      TextField(
                        controller: plateController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Plate No',
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
                              'CREATE BUS ROUTE',
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

