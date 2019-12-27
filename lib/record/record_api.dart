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
    if(record.name == currentUser)
    _recordList.add(record);
  });

  recordNotifier.recordList = _recordList;
}

uploadRecord(Record record,Function recordUploaded, String name, String type) async{




  CollectionReference recordRef =  await Firestore.instance.collection('Records');

    record.createdAt = Timestamp.now();

    DocumentReference documentRef = await recordRef.add(record.toMap());

    record.id = documentRef.documentID;
    record.name = name ;
    record.type = type;

    print('uploaded record succesfully: $record');

    await documentRef.setData(record.toMap(), merge: true);

    recordUploaded(record);

}