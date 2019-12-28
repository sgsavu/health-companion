import 'package:cloud_firestore/cloud_firestore.dart';


class Medicine {

    String user;
    String userEmail;
    String id;
    String name;
    String image;
    String intake;
    String category;
    String description;
    Timestamp createdAt;
    Timestamp updatedAt;

    Medicine();

    Medicine.fromMap(Map<String, dynamic> data){

      user = data['user'];
      userEmail = data['userEmail'];
      id = data['id'];
      name = data['name'];
      image = data['image'];
      intake = data['intake'];
      category = data['category'];
      description = data['description'];
      createdAt = data['createdAt'];
      updatedAt = data['updatedAt'];


    }

    Map<String,dynamic> toMap(){
      return{
        'user':user,
        'userEmail':userEmail,
        'id':id,
        'name':name,
        'category': category,
        'image':image,
        'intake':intake,
        'description':description,
        'createdAt':createdAt,
        'updatedAt':updatedAt,

      };
    }

}