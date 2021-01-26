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

class AdminPage extends StatefulWidget {

  static const String id = 'admin';

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  final GlobalKey<ScaffoldState> scaffoldKey= new GlobalKey<ScaffoldState>();

  void showSnackBar(String title){
    final snackbar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var fullNameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var plateController = TextEditingController();

  void registerUser() async {

    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Logging you in..',),
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if(userCredential.user != null){

        DatabaseReference newPassengerRef = FirebaseDatabase.instance.reference().child('drivers/${userCredential.user.uid}');
        //Prepare data to be saved on users  table
        Map userMap = {
          'fullName': fullNameController.text,
          'email': emailController.text,
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
        print('Registration successful');
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'weak-password') {
        showSnackBar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSnackBar('The account already exists for that email.');
      }
    }

    /*UserCredential userCredential;
      userCredential = (await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ).catchError((ex){

        //check error and display message
        Navigator.pop(context);
        PlatformException thisEx = ex;
        showSnackBar(thisEx.message);
      }));

    Navigator.pop(context);
    if(userCredential.user != null){
      DatabaseReference newUserRef = FirebaseDatabase.instance.reference().child('users/passengers/${userCredential.user.uid}');

      //Prepare data to be saved on users  table
      Map userMap = {
        'fullName': fullNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        //'password': passwordController.text,
        'isDriver': false,
      };
      newUserRef.set(userMap);

      //Take the user to the mainpage
      Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);

      print('Registration successful');
    }*/

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

                Text(' Create a driver account \n-Admin-',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[

                      //Full name
                      TextField(
                        controller: fullNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Full Name',
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

                          if(fullNameController.text.length < 3){
                            showSnackBar('Please provide a valid full name.');
                            return;
                          }

                          if(phoneController.text.length < 10){
                            showSnackBar('Please provide a valid phone number.');
                            return;
                          }

                          if(!emailController.text.contains('@')){
                            showSnackBar('Please provide a valid email address.');
                            return;
                          }

                          if(passwordController.text.length < 5){
                            showSnackBar('Password must be at least 5 characters.');
                            return;
                          }

                          registerUser();
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
                              'CREATE DRIVER',
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

