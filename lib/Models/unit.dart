import 'package:cloud_firestore/cloud_firestore.dart';

class Unit{
  String unit;
  
  Unit({this.unit});

  factory Unit.fromFirebase(DocumentSnapshot doc){
    return Unit(unit: doc.data['description']);
  }
}