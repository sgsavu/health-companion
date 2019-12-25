import 'package:cloud_firestore/cloud_firestore.dart';


class Exercise {

  String id;
  String name;
  String type;
  Timestamp createdAt;

  Exercise();

  Exercise.fromMap(Map<String, dynamic> data){


    id = data['id'];
    name = data['name'];
    type = data['type'];
    createdAt = data['createdAt'];


  }

  Map<String,dynamic> toMap(){
    return{
      'id':id,
      'name':name,
      'type':type,
      'createdAt':createdAt,

    };
  }

}