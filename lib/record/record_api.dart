import 'package:diabetes_app/record/record_notifier.dart';
import 'package:diabetes_app/record/record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



getRecord(RecordNotifier recordNotifier,String currentUser)async{

  QuerySnapshot snapshot =  await Firestore.instance
      .collection('Records')
      .orderBy("createdAt", descending: true)
      .getDocuments();

  List<Record> _recordList = [];


  snapshot.documents.forEach((document) {
    Record record = Record.fromMap(document.data);
    if(record.email == currentUser)
    _recordList.add(record);
  });

  recordNotifier.recordList = _recordList;
}

uploadRecord(Record record,Function recordUploaded, String name, String type, String email) async{




  CollectionReference recordRef =  await Firestore.instance.collection('Records');

    record.createdAt = Timestamp.now();

    DocumentReference documentRef = await recordRef.add(record.toMap());

    record.id = documentRef.documentID;
    record.name = name ;
    record.type = type;
    record.email = email;

    print('uploaded record succesfully: $record');

    await documentRef.setData(record.toMap(), merge: true);

    recordUploaded(record);

}

updateRecord(Record record) async{

  CollectionReference medicineRef =  await Firestore.instance.collection('Records');
  await medicineRef.document(record.id).updateData(record.toMap());

  print('updated record with id: ${record.id}');

}

deleteRecord(Record record) async{

  await Firestore.instance.collection('Records').document(record.id).delete();
}