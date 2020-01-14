import 'dart:collection';
import 'package:diabetes_app/profile.dart';
import 'package:flutter/cupertino.dart';

class ProfileNotifier with ChangeNotifier{
  List<Profile> _profileList = [];
  Profile _currentProfile;

  Profile get currentProfile => _currentProfile;


  set currentProfile(Profile profile){
    _currentProfile = profile;
    notifyListeners();
  }

  addProfile(Profile profile){

    _profileList.insert(0, profile);
    notifyListeners();
  }

  deleteProfile(Profile profile){
    _profileList.removeWhere((_profile) => _profile.id == profile.id );
    notifyListeners();

  }


}