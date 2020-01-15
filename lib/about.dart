import 'dart:async';
import 'dart:io';
import 'package:diabetes_app/exercises/exercise.dart';
import 'package:diabetes_app/exercises/exercise_api.dart';
import 'package:diabetes_app/exercises/exercise_notifier.dart';
import 'package:diabetes_app/global_api.dart';
import 'package:diabetes_app/loading.dart';
import 'package:diabetes_app/login/auth_notifier.dart';
import 'package:diabetes_app/medicine/medicine.dart';
import 'package:diabetes_app/medicine/medicine_api.dart';
import 'package:diabetes_app/medicine/medicine_notifier.dart';
import 'package:diabetes_app/profile/profile.dart';
import 'package:diabetes_app/profile/profile_api.dart';
import 'package:diabetes_app/profile/profile_notifier.dart';
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
        profileNotifier.currentProfile, true, _imageFile, _onProfileUploaded);

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

    String oldName = profileNotifier.currentProfile?.name;

    _formKey.currentState.save();

    if (newPassword != "" &&
        oldName != profileNotifier.currentProfile?.name) {
      currentPassword = "";

      await createAlertDialogCustomForm(context);

      if (currentPassword != "") {
        setState(() {
          loading = true;
        });

        try {
          UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
          userUpdateInfo.displayName =
              profileNotifier.currentProfile?.name;

          authNotifier.user.updateProfile(userUpdateInfo);

          await authNotifier.user.reauthenticateWithCredential(
              EmailAuthProvider.getCredential(
                  email: authNotifier.user.email, password: currentPassword));
          authNotifier.user.updatePassword(newPassword);

          uploadProfile(profileNotifier.currentProfile, true,
              _onProfileUploaded,
              imageUrl: null);

          for (Medicine medicine in medicineNotifier.medicineList) {
            medicine.user = profileNotifier.currentProfile?.name;
            uploadMedicine(medicine, true, _onMedicineUploaded);
          }

          for (Exercise exercise in exerciseNotifier.exerciseList) {
            exercise.user = profileNotifier.currentProfile?.name;
            updateExercise(exercise);
          }

          for (Record record in recordNotifier.recordList) {
            record.name = profileNotifier.currentProfile?.name;
            updateRecord(record);
          }

          createAlertDialogCustom(context, 'Success',
              'Your password and name have been sucessfully updated.','https://static.wixstatic.com/media/6387f1_04ed003331da4d0193f3e47d597389a1~mv2.png/v1/fill/w_300,h_297/6387f1_04ed003331da4d0193f3e47d597389a1~mv2.png');
        } catch (error) {
          profileNotifier.currentProfile?.name = oldName;
          await createAlertDialogCustom(context, 'Error', error.toString(),'https://www.elegantthemes.com/blog/wp-content/uploads/2016/03/500-internal-server-error-featured-image-1.png');
        }


        setState(() {
          loading = false;
        });

      }
    } else if (oldName != profileNotifier.currentProfile?.name) {
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
          profileNotifier.currentProfile?.name;
      authNotifier.user.updateProfile(userUpdateInfo);
      authNotifier.user.reload();

      uploadProfile(
          profileNotifier.currentProfile, true, _onProfileUploaded,
          imageUrl: null);

      for (Medicine medicine in medicineNotifier.medicineList) {
        medicine.user = profileNotifier.currentProfile?.name;
        uploadMedicine(medicine, true, _onMedicineUploaded);
      }

      for (Exercise exercise in exerciseNotifier.exerciseList) {
        exercise.user = profileNotifier.currentProfile?.name;
        updateExercise(exercise);
      }

      for (Record record in recordNotifier.recordList) {
        record.name = profileNotifier.currentProfile?.name;
        updateRecord(record);
      }
    } else if (newPassword != "") {
      currentPassword = "";

      await createAlertDialogCustomForm(context);
      if (currentPassword != "") {
        setState(() {
          loading = true;
        });

        try {
          await authNotifier.user.reauthenticateWithCredential(
              EmailAuthProvider.getCredential(
                  email: authNotifier.user.email, password: currentPassword));
          authNotifier.user.updatePassword(newPassword);
          createAlertDialogCustom(context, 'Success',
              'Your password has been sucessfully updated.','https://static.wixstatic.com/media/6387f1_04ed003331da4d0193f3e47d597389a1~mv2.png/v1/fill/w_300,h_297/6387f1_04ed003331da4d0193f3e47d597389a1~mv2.png');
        } catch (error) {
          await createAlertDialogCustom(context, 'Error', error.toString(),'https://www.elegantthemes.com/blog/wp-content/uploads/2016/03/500-internal-server-error-featured-image-1.png');
        }

        setState(() {
          loading = false;
        });

      }
    }
  }

  createAlertDialogCustomForm(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Stack(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(
                        top: 66.0 + 16.0,
                        bottom: 16,
                        left: 16,
                        right: 16,
                      ),
                      margin: EdgeInsets.only(top: 66.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: const Offset(0.0, 10.0),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child:
                        Column(
                          mainAxisSize: MainAxisSize.min, // To make the card compact
                          children: <Widget>[
                            Text(
                              'Warning',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Please enter your current password to validate identity:',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            Form(
                              key: _formKey2,
                              child:
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
                              ),),
                            SizedBox(height: 24.0),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: FlatButton(
                                onPressed: () => {
                                  Navigator.of(context).pop(), // To close the dialog
                                  _formKey2.currentState.save(),
                                },
                                child: Text('Submit'),
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage('https://www.vippng.com/png/detail/19-195880_triangle-warning-sign.png'),
                        backgroundColor: Colors.blueAccent,
                        maxRadius: 66,
                      ),
                    ],
                  ),
                ],
              )
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
                  backgroundImage: NetworkImage(profileNotifier.currentProfile?.image != null
                          ? profileNotifier.currentProfile?.image
                          : 'user'),
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
                                profileNotifier.currentProfile?.name,
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 15),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              profileNotifier.currentProfile?.name =
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
