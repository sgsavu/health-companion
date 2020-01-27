import 'package:cloud_firestore/cloud_firestore.dart';


class FeedbackModel {

  String id;
  String userName;
  String userEmail;
  String message;
  Timestamp createdAt;

  FeedbackModel();

  FeedbackModel.fromMap(Map<String, dynamic> data){


    id = data['id'];
    userName = data['userName'];
    userEmail = data['userEmail'];
    message = data['message'];
    createdAt = data['createdAt'];


  }

  Map<String,dynamic> toMap(){
    return{
      'id':id,
      'userName':userName,
      'userEmail':userEmail,
      'message':message,
      'createdAt':createdAt,

    };
  }

}