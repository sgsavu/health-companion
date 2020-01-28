import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_app/reward.dart';


uploadReward(Reward reward) async{




  CollectionReference rewardRef =  await Firestore.instance.collection('Reward');

    reward.createdAt = Timestamp.now();

    DocumentReference documentRef = await rewardRef.add(reward.toMap());

    reward.id = documentRef.documentID;

    print('uploaded record succesfully: $reward');

    await documentRef.setData(reward.toMap(), merge: true);


}

updateReward(Reward reward) async{

  CollectionReference medicineRef =  await Firestore.instance.collection('Reward');
  await medicineRef.document(reward.id).updateData(reward.toMap());

  print('updated record with id: ${reward.id}');

}
