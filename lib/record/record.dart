import 'package:cloud_firestore/cloud_firestore.dart';


class Record {

  String id;
  String name;
  String type;
  String email;
  Timestamp createdAt;

  Record();

  Record.fromMap(Map<String, dynamic> data){


    id = data['id'];
    name = data['name'];
    type = data['type'];
    email = data['email'];
    createdAt = data['createdAt'];


  }

  Map<String,dynamic> toMap(){
    return{
      'id':id,
      'name':name,
      'type':type,
      'email':email,
      'createdAt':createdAt,

    };
  }

}