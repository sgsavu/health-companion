import 'dart:io';
import 'package:diabetes_app/login/auth_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:diabetes_app/medicine/medicine.dart';
import 'package:diabetes_app/medicine/medicine_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:diabetes_app/login/user.dart';


login(User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    FirebaseUser firebaseUser = authResult.user;

    if (firebaseUser != null) {
      print("Log In: $firebaseUser");
      authNotifier.setUser(firebaseUser);
    }
  }
}

signup(User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = user.displayName;

    FirebaseUser firebaseUser = authResult.user;

    if (firebaseUser != null) {
      await firebaseUser.updateProfile(updateInfo);

      await firebaseUser.reload();

      print("Sign up: $firebaseUser");

      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
      authNotifier.setUser(currentUser);
    }
  }
}

signout(AuthNotifier authNotifier) async {
  await FirebaseAuth.instance.signOut().catchError((error) => print(error.code));

  authNotifier.setUser(null);
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  if (firebaseUser != null) {
    print(firebaseUser);
    authNotifier.setUser(firebaseUser);
  }
}


getMedicine(MedicineNotifier medicineNotifier)async{
  QuerySnapshot snapshot =  await Firestore.instance
      .collection('Medicine')
      .orderBy("createdAt", descending: true)
      .getDocuments();

  List<Medicine> _medicineList = [];


  snapshot.documents.forEach((document) {
    Medicine medicine = Medicine.fromMap(document.data);
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
    _uploadMedicine(medicine, isUpdating, medicineUploaded, imageUrl: url);

  }else{
    print('...skipping image upload');
    _uploadMedicine(medicine, isUpdating, medicineUploaded);
  }

}

_uploadMedicine(Medicine medicine, bool isUpdating,Function medicineUploaded, {String imageUrl}) async{
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