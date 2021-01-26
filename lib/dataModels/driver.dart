import 'package:firebase_database/firebase_database.dart';

class Driver{
  String fullName;
  String email;
  String phone;
  String id;
  bool isDriver;
  String plateNo;

  Driver({
    this.email,
    this.fullName,
    this.phone,
    this.id,
    this.isDriver,
    this.plateNo,
  });

  Driver.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    phone = snapshot.value['phone'];
    email = snapshot.value['email'];
    fullName = snapshot.value['fullName'];
    isDriver = snapshot.value['isDriver'];
    plateNo = snapshot.value['plateNo'];
  }
}