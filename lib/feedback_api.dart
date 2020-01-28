import 'package:diabetes_app/feedback.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


uploadFeedback(FeedbackModel feedback) async{




  CollectionReference feedbackRef =  await Firestore.instance.collection('Feedback');

    feedback.createdAt = Timestamp.now();

    DocumentReference documentRef = await feedbackRef.add(feedback.toMap());

    feedback.id = documentRef.documentID;

    print('uploaded record succesfully: $feedback');

    await documentRef.setData(feedback.toMap(), merge: true);


}

updateFeedback(FeedbackModel feedback) async{

  CollectionReference medicineRef =  await Firestore.instance.collection('Feedback');
  await medicineRef.document(feedback.id).updateData(feedback.toMap());

  print('updated record with id: ${feedback.id}');

}
