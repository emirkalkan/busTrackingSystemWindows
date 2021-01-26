import 'package:firebase_database/firebase_database.dart';

class Passenger{
  String fullName;
  String email;
  String phone;
  String id;
  bool isDriver;

  Passenger({
    this.email,
    this.fullName,
    this.phone,
    this.id,
    this.isDriver,
  });

  Passenger.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    phone = snapshot.value['phone'];
    email = snapshot.value['email'];
    fullName = snapshot.value['fullName'];
    isDriver = snapshot.value['isDriver'];
  }
}