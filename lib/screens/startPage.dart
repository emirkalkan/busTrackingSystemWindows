import 'package:bus_tracking_system/brand_colors.dart';
import 'package:bus_tracking_system/globalVariables.dart';
import 'package:bus_tracking_system/screens/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:bus_tracking_system/widgets/ProgressDialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'mainpage.dart';

class StartPage extends StatefulWidget {

  static const String id = 'startPage';

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  final GlobalKey<ScaffoldState> scaffoldKey= new GlobalKey<ScaffoldState>();

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
                SizedBox(height: 80,),
                Image(
                  alignment: Alignment.center,
                  height: 150.0,
                  width: 150,
                  image: AssetImage('images/logoBus.png'),
                ),

                SizedBox(height: 30,),

                Text('Bus Tracking System App',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0,),

                      RaisedButton(
                        onPressed: () async{
                          Navigator.pushNamedAndRemoveUntil(
                              context, LoginPage.id, (route) => false);
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
                              'LOGIN TO SYSTEM',
                              style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 40.0,),

                      RaisedButton(
                        onPressed: () async{
                          Navigator.pushNamedAndRemoveUntil(
                              context, MainPage.id, (route) => false);
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
                              'ENTER SYSTEM WITHOUT LOGIN',
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
