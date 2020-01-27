import 'package:cloud_firestore/cloud_firestore.dart';


class Profile {

  String id;
  String image;
  String email;
  String name;
  int quizScore;
  Timestamp createdAt;
  Timestamp updatedAt;

  Profile();

  Profile.fromMap(Map<String, dynamic> data){


    id = data['id'];
    image = data['image'];
    email = data['email'];
    name = data['name'];
    quizScore = data['quizScore'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];

  }

  Map<String,dynamic> toMap(){
    return{
      'id':id,
      'image':image,
      'email':email,
      'name':name,
      'quizScore':quizScore,
      'createdAt':createdAt,
      'updatedAt':updatedAt,

    };
  }

}