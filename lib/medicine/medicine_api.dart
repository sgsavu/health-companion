import 'dart:io';
import 'package:diabetes_app/login/auth_notifier.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:diabetes_app/medicine/medicine.dart';
import 'package:diabetes_app/medicine/medicine_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:diabetes_app/profile.dart';



getMedicine(MedicineNotifier medicineNotifier, String currentUser)async{
  QuerySnapshot snapshot =  await Firestore.instance
      .collection('Medicine')
      .orderBy("createdAt", descending: true)
      .getDocuments();

  List<Medicine> _medicineList = [];


  snapshot.documents.forEach((document) {
    Medicine medicine = Medicine.fromMap(document.data);
    if(medicine.userEmail==currentUser)
    _medicineList.add(medicine);
  });

  medicineNotifier.medicineList = _medicineList;
}



uploadMedicineAndImage(Medicine medicine, bool isUpdating, File localFile, Function medicineUploaded) async{

  if (localFile != null){
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('medicine/images/$uuid%fileExtension');

    await firebaseStorageRef.putFile(localFile).onComplete.catchError(
        (onError){
          print(onError);
          return false;
        }
    );

    String url = await firebaseStorageRef.getDownloadURL();
    print("download url: $url");
    uploadMedicine(medicine, isUpdating, medicineUploaded, imageUrl: url);

  }else{
    print('...skipping image upload');
    uploadMedicine(medicine, isUpdating, medicineUploaded);
  }

}

uploadMedicine(Medicine medicine, bool isUpdating,Function medicineUploaded, {String imageUrl}) async{
  CollectionReference medicineRef =  await Firestore.instance.collection('Medicine');

  if (imageUrl!= null){
    medicine.image = imageUrl;
  }

  if (isUpdating){
    medicine.updatedAt = Timestamp.now();
    await medicineRef.document(medicine.id).updateData(medicine.toMap());

    medicineUploaded(medicine, true);

    print('updated medicine with id: ${medicine.id}');
  }else{

    medicine.createdAt = Timestamp.now();

    DocumentReference documentRef = await medicineRef.add(medicine.toMap());
    medicine.id = documentRef.documentID;
    
    print('uploaded medicine succesfully: ${medicine.toString()}');

    await documentRef.setData(medicine.toMap(), merge: true);

    medicineUploaded(medicine, false);

  }
}


deleteMedicine(Medicine medicine, Function medicineDeleted) async{
  if(medicine.image != null){
    StorageReference storageReference = await FirebaseStorage.instance.getReferenceFromUrl(medicine.image);

    print(storageReference.path);

    await storageReference.delete();
    
    print('image deleted');

  }

  await Firestore.instance.collection('Medicine').document(medicine.id).delete();
  medicineDeleted(medicine);
}
