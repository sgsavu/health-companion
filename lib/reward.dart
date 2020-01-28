import 'package:cloud_firestore/cloud_firestore.dart';


class Reward {

  String id;
  String userName;
  String userEmail;
  String rewardName;
  Timestamp createdAt;

  Reward();

  Reward.fromMap(Map<String, dynamic> data){

    id = data['id'];
    userName = data['userName'];
    userEmail = data['userEmail'];
    rewardName = data['rewardName'];
    createdAt = data['createdAt'];


  }

  Map<String,dynamic> toMap(){
    return{
      'id':id,
      'userName':userName,
      'userEmail':userEmail,
      'rewardName':rewardName,
      'createdAt':createdAt,

    };
  }

}