import 'dart:io';
import 'package:diabetes_app/profile_notifier.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:diabetes_app/profile.dart';



getProfile(ProfileNotifier profileNotifier, String currentUser)async{
  QuerySnapshot snapshot =  await Firestore.instance
      .collection('Profile')
      .orderBy("createdAt", descending: true)
      .getDocuments();

  List<Profile> _profileList = [];


  snapshot.documents.forEach((document) {
    Profile profile = Profile.fromMap(document.data);
    if(profile.email==currentUser)
      _profileList.add(profile);
  });

  profileNotifier.profileList = _profileList;
}



uploadProfileAndImage(Profile profile, bool isUpdating, File localFile, Function profileUploaded) async{

  if (localFile != null){
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    if(profile.image!=""){
      StorageReference storageReference = await FirebaseStorage.instance.getReferenceFromUrl(profile.image);

      print(storageReference.path);

      await storageReference.delete();

      print('old image deleted');
    }



    final StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('profile/images/$uuid%fileExtension');

    await firebaseStorageRef.putFile(localFile).onComplete.catchError(
            (onError){
          print(onError);
          return false;
        }
    );

    String url = await firebaseStorageRef.getDownloadURL();
    print("download url: $url");
    uploadProfile(profile, isUpdating, profileUploaded, imageUrl: url);

  }else{
    print('...skipping image upload');
    uploadProfile(profile, isUpdating, profileUploaded);
  }

}

uploadProfile(Profile profile, bool isUpdating,Function profileUploaded, {String imageUrl}) async{
  CollectionReference profileRef =  await Firestore.instance.collection('Profile');

  if (imageUrl!= null){
    profile.image = imageUrl;
  }

  if (isUpdating){
    profile.updatedAt = Timestamp.now();
    print (profile.id);
    await profileRef.document(profile.id).updateData(profile.toMap());

    profileUploaded(profile, true);

    print('updated profile with id: ${profile.id}');
  }else{

    profile.createdAt = Timestamp.now();

    DocumentReference documentRef = await profileRef.add(profile.toMap());
    profile.id = documentRef.documentID;

    print('uploaded profile succesfully: ${profile.toString()}');

    await documentRef.setData(profile.toMap(), merge: true);

    profileUploaded(profile, false);

  }
}