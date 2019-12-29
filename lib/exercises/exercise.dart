import 'package:cloud_firestore/cloud_firestore.dart';


class Exercise {

  String user;
  String userEmail;
  String id;
  String name;
  String type;
  String set1;
  String set2;
  String set3;
  String set4;
  String set5;
  Timestamp createdAt;
  Timestamp updatedAt;

  Exercise();

  Exercise.fromMap(Map<String, dynamic> data){

    user = data['user'];
    userEmail = data['userEmail'];
    id = data['id'];
    name = data['name'];
    type = data['type'];
    set1 = data['set1'];
    set2 = data['set2'];
    set3 = data['set3'];
    set4 = data['set4'];
    set5 = data['set5'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];


  }

  Map<String,dynamic> toMap(){
    return{
      'user':user,
      'userEmail':userEmail,
      'id':id,
      'name':name,
      'type':type,
      'set1':set1,
      'set2':set2,
      'set3':set3,
      'set4':set4,
      'set5':set5,
      'createdAt':createdAt,
      'updatedAt':updatedAt,
    };
  }

}