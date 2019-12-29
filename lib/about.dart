import 'dart:async';
import 'dart:io';
import 'package:diabetes_app/exercises/exercise.dart';
import 'package:diabetes_app/exercises/exercise_api.dart';
import 'package:diabetes_app/exercises/exercise_notifier.dart';
import 'package:diabetes_app/loading.dart';
import 'package:diabetes_app/login/auth_notifier.dart';
import 'package:diabetes_app/login/login_api.dart';
import 'package:diabetes_app/medicine/medicine.dart';
import 'package:diabetes_app/medicine/medicine_api.dart';
import 'package:diabetes_app/medicine/medicine_notifier.dart';
import 'package:diabetes_app/profile.dart';
import 'package:diabetes_app/profile_api.dart';
import 'package:diabetes_app/profile_notifier.dart';
import 'package:diabetes_app/record/record.dart';
import 'package:diabetes_app/record/record_api.dart';
import 'package:diabetes_app/record/record_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  File _imageFile;
  String newPassword = "";
  String currentPassword = "";
  bool loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();

  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    ProfileNotifier profileNotifier =
        Provider.of<ProfileNotifier>(context, listen: false);
    getProfile(profileNotifier, authNotifier.user.email);

    MedicineNotifier medicineNotifier =
        Provider.of<MedicineNotifier>(context, listen: false);
    getMedicine(medicineNotifier, authNotifier.user.email);

    ExerciseNotifier exerciseNotifier =
        Provider.of<ExerciseNotifier>(context, listen: false);
    getExerciseForUpdate(exerciseNotifier, authNotifier.user.email);

    RecordNotifier recordNotifier =
        Provider.of<RecordNotifier>(context, listen: false);
    getRecord(recordNotifier, authNotifier.user.email);

    super.initState();
  }

  _onProfileUploaded(Profile profile, bool hmm) {
    ProfileNotifier profileNotifier = Provider.of<ProfileNotifier>(context);
    if (hmm == false) {
      profileNotifier.addProfile(profile);
    }

    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    getProfile(profileNotifier, authNotifier.user.email);
  }

  _getLocalImage() async {
    ProfileNotifier profileNotifier = Provider.of<ProfileNotifier>(context);

    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }

    setState(() {
      loading = true;
    });

    await uploadProfileAndImage(
        profileNotifier.profileList[0], true, _imageFile, _onProfileUploaded);

    setState(() {
      loading = false;
    });
  }

  _saveProfile() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    ProfileNotifier profileNotifier = Provider.of<ProfileNotifier>(context);
    MedicineNotifier medicineNotifier = Provider.of<MedicineNotifier>(context);
    ExerciseNotifier exerciseNotifier = Provider.of<ExerciseNotifier>(context);
    RecordNotifier recordNotifier = Provider.of<RecordNotifier>(context);

    String oldName = profileNotifier.profileList.elementAt(0)?.name;

    _formKey.currentState.save();

    if (newPassword != "" &&
        oldName != profileNotifier.profileList.elementAt(0)?.name) {


      currentPassword="";

      await createAlertDialog4(context, 'Validate',
          'Please type in your current password to validate.');

      if(currentPassword!=""){
        setState(() {
          loading = true;
        });

        try {

          UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
          userUpdateInfo.displayName =
              profileNotifier.profileList.elementAt(0)?.name;

          authNotifier.user.updateProfile(userUpdateInfo);

          await authNotifier.user.reauthenticateWithCredential(
              EmailAuthProvider.getCredential(
                  email: authNotifier.user.email, password: currentPassword));
          authNotifier.user.updatePassword(newPassword);


          uploadProfile(
              profileNotifier.profileList.elementAt(0), true, _onProfileUploaded,
              imageUrl: null);


          for (Medicine medicine in medicineNotifier.medicineList) {
            medicine.user = profileNotifier.profileList.elementAt(0)?.name;
            uploadMedicine(medicine, true, _onMedicineUploaded);
          }

          for (Exercise exercise in exerciseNotifier.exerciseList) {
            exercise.user = profileNotifier.profileList.elementAt(0)?.name;
            updateExercise(exercise);
          }

          for (Record record in recordNotifier.recordList) {
            record.name = profileNotifier.profileList.elementAt(0)?.name;
            updateRecord(record);
          }


          createAlertDialog2(
              context, 'Success', 'Your password and name have been sucessfully updated.');

        } catch (error) {
          profileNotifier.profileList.elementAt(0)?.name=oldName;
          await createAlertDialog2(context, 'Error', error.toString());
        }
      }


    } else if (oldName != profileNotifier.profileList.elementAt(0)?.name) {
      setState(() {
        loading = true;
      });

      Timer(Duration(seconds: 1), () {
        setState(() {
          loading = false;
        });
        Navigator.pop(context);
      });
      UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
      userUpdateInfo.displayName =
          profileNotifier.profileList.elementAt(0)?.name;
      authNotifier.user.updateProfile(userUpdateInfo);
      authNotifier.user.reload();

      uploadProfile(
          profileNotifier.profileList.elementAt(0), true, _onProfileUploaded,
          imageUrl: null);

      for (Medicine medicine in medicineNotifier.medicineList) {
        medicine.user = profileNotifier.profileList.elementAt(0)?.name;
        uploadMedicine(medicine, true, _onMedicineUploaded);
      }

      for (Exercise exercise in exerciseNotifier.exerciseList) {
        exercise.user = profileNotifier.profileList.elementAt(0)?.name;
        updateExercise(exercise);
      }

      for (Record record in recordNotifier.recordList) {
        record.name = profileNotifier.profileList.elementAt(0)?.name;
        updateRecord(record);
      }

    } else if (newPassword != "") {
      currentPassword="";

      await createAlertDialog4(context, 'Validate',
          'Please type in your current password to validate.');
      if(currentPassword!=""){
        setState(() {
          loading = true;
        });

        try {
          await authNotifier.user.reauthenticateWithCredential(
              EmailAuthProvider.getCredential(
                  email: authNotifier.user.email, password: currentPassword));
          authNotifier.user.updatePassword(newPassword);
          createAlertDialog2(
              context, 'Success', 'Your password has been sucessfully updated.');
        } catch (error) {
          await createAlertDialog2(context, 'Error', error.toString());
        }
      }
    }
  }

  createAlertDialog4(BuildContext context, String title, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Form(
              key: _formKey2,
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  Text(message),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                    ),
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 15),
                    obscureText: true,
                    validator: (String value) {
                      return null;
                    },
                    onSaved: (String value) {
                      currentPassword = value;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Return'),
                onPressed: () {
                  setState(() {
                    loading = false;
                  });
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Submit'),
                onPressed: () {
                  _formKey2.currentState.save();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  createAlertDialog(BuildContext context, String title, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Container(
              child: Text(message),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  createAlertDialog2(BuildContext context, String title, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Container(
              child: Text(message),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  setState(() {
                    loading = false;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _onMedicineUploaded(Medicine medicine, bool hmm) {
    MedicineNotifier medicineNotifier = Provider.of<MedicineNotifier>(context);
    if (hmm == false) {
      medicineNotifier.addMedicine(medicine);
    }
  }

  @override
  Widget build(BuildContext context) {
    ProfileNotifier profileNotifier = Provider.of<ProfileNotifier>(context);

    return loading
        ? Loading()
        : Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(35.0),
                child: AppBar(
                  backgroundColor: Colors.white.withOpacity(0.0),
                  iconTheme: IconThemeData(color: Colors.black),
                  elevation: 0.0,
                )),
            body: SingleChildScrollView(
                child: Center(
                    child: Container(
              height: MediaQuery.of(context).size.height * 0.90,
              child: Column(children: <Widget>[
                CircleAvatar(
                  maxRadius: 90,
                  backgroundImage: NetworkImage(profileNotifier
                          .profileList.isEmpty
                      ? 'wow'
                      : profileNotifier.profileList.elementAt(0)?.image != ""
                          ? profileNotifier.profileList.elementAt(0)?.image
                          : 'https://www.sackettwaconia.com/wp-content/uploads/default-profile.png'),
                ),
                OutlineButton(
                  onPressed: _getLocalImage,
                  child: Text('Change Image'),
                ),
                Form(
                  key: _formKey,
                  autovalidate: true,
                  child: Container(
                      padding: EdgeInsets.only(
                          left: 20, top: 0, bottom: 20, right: 20),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Name'),
                            initialValue:
                                profileNotifier.profileList.elementAt(0)?.name,
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 15),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              profileNotifier.profileList.elementAt(0)?.name =
                                  value;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Create new password'),
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 15),
                            obscureText: true,
                            controller: _passwordController,
                            validator: (String value) {
                              if (!value.isEmpty) {
                                if (value.length < 5 || value.length > 20) {
                                  return 'Password must be betweem 5 and 20 characters';
                                }
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              newPassword = value;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Confirm new password'),
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 15),
                            obscureText: true,
                            validator: (String value) {
                              if (_passwordController.text != value) {
                                return 'Passwords do not match';
                              }

                              return null;
                            },
                          ),
                        ],
                      )),
                ),
                FloatingActionButton.extended(
                    onPressed: _saveProfile,
                    label: Text('Save profile'),
                    backgroundColor: Colors.blueAccent,
                    icon: Icon(Icons.done_outline))
              ]),
            ))));
  }
}
