import 'package:cloud_firestore/cloud_firestore.dart';


class Record {

  String id;
  String name;
  Timestamp createdAt;

  Record();

  Record.fromMap(Map<String, dynamic> data){


    id = data['id'];
    name = data['name'];
    createdAt = data['createdAt'];


  }

  Map<String,dynamic> toMap(){
    return{
      'id':id,
      'name':name,
      'createdAt':createdAt,

    };
  }

}