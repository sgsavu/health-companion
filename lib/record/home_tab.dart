import 'package:diabetes_app/about.dart';
import 'package:diabetes_app/feedback_screen.dart';
import 'package:diabetes_app/global_api.dart';
import 'package:diabetes_app/loading.dart';
import 'package:diabetes_app/login/auth_notifier.dart';
import 'package:diabetes_app/login/login_api.dart';
import 'package:diabetes_app/medicine/medicine.dart';
import 'package:diabetes_app/medicine/medicine_api.dart';
import 'package:diabetes_app/medicine/medicine_notifier.dart';
import 'package:diabetes_app/profile/profile_api.dart';
import 'package:diabetes_app/profile/profile_notifier.dart';
import 'package:diabetes_app/quiz_screen.dart';
import 'package:diabetes_app/record/record.dart';
import 'package:diabetes_app/record/record_api.dart';
import 'package:diabetes_app/record/record_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:diabetes_app/record/record_form.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<DropdownMenuItem<Medicine>> _dropdownMenuItems;
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  Medicine _selectedMedicine;
  bool canShow = false;
  String currentPassword ="";
  bool loading = false;

  @override
  void initState() {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    authNotifier.user.reload();
    initializeCurrentUser(authNotifier);
    initializeCurrentUser(authNotifier);
    RecordNotifier recordNotifier =
        Provider.of<RecordNotifier>(context, listen: false);
    getRecord(recordNotifier,authNotifier.user.email);

    MedicineNotifier medicineNotifier =
        Provider.of<MedicineNotifier>(context, listen: false);
    getMedicine(medicineNotifier,authNotifier.user.email);

    ProfileNotifier profileNotifier =
    Provider.of<ProfileNotifier>(context, listen: false);
    getProfile(profileNotifier,authNotifier.user.email);


    super.initState();
  }


  buildDropDownMenuItems(List medicine) {
    List<DropdownMenuItem<Medicine>> items = List();
    for (Medicine medicine in medicine) {

      items.add(DropdownMenuItem(
        value: medicine,
        child: Text(medicine.name),
      ));
    }
    return items;
  }

  onChangeDropdownItem(Medicine selectedMedicine) {
    setState(() {
      _selectedMedicine = selectedMedicine;
      canShow=true;
    });
  }

  createAlertDialog(BuildContext context, AuthNotifier authNotifier,
      RecordNotifier recordNotifier) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Medicine Intake History'),
            content: Container(
              child: Text('Are you sure you want to create a database record of your medicine intake at the current time? \nPlease make sure that this is the right time for you to take your medication as this action cannot be revoked.\nThis information is shared with your GP for your own safety.\nIf you\'ve added an entry by mistake please contact your GP to avoid any confusion.\n'),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  recordNotifier.currentRecord = null;
                  Navigator.pop(context);
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return RecordForm(
                        bro: authNotifier.user.displayName,
                        type: _selectedMedicine.name,
                        email: authNotifier.user.email);
                  }));
                },
              )
            ],
          );
        });
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


  deleteAccountandData() async{

    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    ProfileNotifier profileNotifier = Provider.of<ProfileNotifier>(context);
    RecordNotifier recordNotifier = Provider.of<RecordNotifier>(context);
    MedicineNotifier medicineNotifier = Provider.of<MedicineNotifier>(context);

    await createAlertDialogCustomForm(context);
    if (currentPassword != "") {
      setState(() {
        loading = true;
      });



      try {
        await authNotifier.user.reauthenticateWithCredential(
            EmailAuthProvider.getCredential(
                email: authNotifier.user.email, password: currentPassword));

        deleteProfile(profileNotifier.currentProfile);

        for (Record record in recordNotifier.recordList) {
          deleteRecord(record);
        }

        for (Medicine medicine in medicineNotifier.medicineList) {
          deleteMedicine(medicine,()=>{
            print('deleted')
          });
        }

        authNotifier.user.delete();


        await createAlertDialogCustom(context, 'Success',
            'Your account has been deleted',NetworkImage('https://static.wixstatic.com/media/6387f1_04ed003331da4d0193f3e47d597389a1~mv2.png/v1/fill/w_300,h_297/6387f1_04ed003331da4d0193f3e47d597389a1~mv2.png'));
        signout(authNotifier);

      } catch (error) {
        await createAlertDialogCustom(context, 'Error', error.toString(),NetworkImage('https://www.elegantthemes.com/blog/wp-content/uploads/2016/03/500-internal-server-error-featured-image-1.png'));
    }

      setState(() {
        loading = false;
      });

    }
  }


  createAlertDialogDeletion(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Warning'),
            content: Container(
              child: Text('Are you sure you want to permanently delete your accont along with all its information? \nThis action cannot be revoked, so please make sure that this is what you intend to do.'),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  deleteAccountandData();
                },
              )
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    RecordNotifier recordNotifier = Provider.of<RecordNotifier>(context);
    MedicineNotifier medicineNotifier = Provider.of<MedicineNotifier>(context);
    ProfileNotifier profileNotifier = Provider.of<ProfileNotifier>(context);

    _dropdownMenuItems = buildDropDownMenuItems(medicineNotifier.medicineList);



      return loading?Loading():Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            /*Image.network(
            '',
            fit: BoxFit.cover,
          ),*/
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                  backgroundColor: Colors.white.withOpacity(0.0),
                  iconTheme: IconThemeData(color: Colors.black),
                  elevation: 0.0,
                  title: Text(
                    "Welcome back, ${profileNotifier.currentProfile?.name!=null?profileNotifier.currentProfile?.name:'User'}!",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  centerTitle: true,
                  bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(200.0),
                      child: Column(children: <Widget>[
                        canShow?Container():Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Text('Step 1: Select medicine to intake:',style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                        OutlineButton(
                          child: DropdownButton(
                            hint: Text('Medicine'),
                            value: _selectedMedicine,
                            items: _dropdownMenuItems,
                            onChanged: onChangeDropdownItem,
                          ),
                        ),
                        canShow?
                        Container(
                            margin: EdgeInsets.only(
                              left: 0,
                              top: 10,
                              right: 0,
                              bottom: 0,
                            ),
                            alignment: Alignment.center,
                            child: Text('Step 2: Click the button below',style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),)
                        ):Container(
                          margin: EdgeInsets.only(
                            left: 0,
                            top: 10,
                            right: 0,
                            bottom: 0,
                          ),
                          alignment: Alignment.center,
                        ),
                        canShow?
                        Container(
                          margin: EdgeInsets.only(
                            left: 0,
                            top: 15,
                            right: 0,
                            bottom: 15,
                          ),
                          alignment: Alignment.center,
                          child: FloatingActionButton.extended(
                            backgroundColor: Colors.blueAccent,
                            icon: Icon(Icons.done_outline),
                            label: Text('Take medicine'),
                            onPressed: () {

                              createAlertDialog(
                                  context, authNotifier, recordNotifier);

                            },
                          ),
                        ):Container(
                          margin: EdgeInsets.only(
                            left: 0,
                            top: 25,
                            right: 0,
                            bottom: 5,
                          ),
                          alignment: Alignment.center,
                        ),
                        Divider(),//or SizedBox(height:15,);
                        Container(
                          height: 20.0,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 2),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: Text('Medicine Intake History',style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                          ),)
                        ),

                        SizedBox(height: 5,)
                      ]))),
              drawer: Drawer(
                child: ListView(
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      accountName: Text(
                          "${profileNotifier.currentProfile?.name!=null?profileNotifier.currentProfile?.name:'null'}"),
                      accountEmail: Text(
                          "${authNotifier.user != null ? authNotifier.user.email : "Feed"}"),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: NetworkImage(profileNotifier.currentProfile?.image!=null?profileNotifier.currentProfile?.image:'null'),
                      ),
                    ),
                    ListTile(
                      title: Text('Edit Profile'),
                      trailing: Icon(Icons.edit),
                      onTap: () => {Navigator.of(context)
                          .push(MaterialPageRoute(builder: (BuildContext context) {
                      return AboutPage();
                      })),

                      setState(() {
                      _selectedMedicine = null;
                      canShow=false;
                      })
                      },


                    ),
                    Divider(
                      color: Colors.black,
                      height: 5,
                    ),
                    ListTile(
                      title: Text('Diabetes Quiz'),
                      trailing: Icon(Icons.stars),
                      onTap: () => {Navigator.of(context)
                          .push(MaterialPageRoute(builder: (BuildContext context) {
                        return QuizScreen();
                      })),},
                    ),
                    Divider(
                      color: Colors.black,
                      height: 5,
                    ),
                    ListTile(
                      title: Text('Feedback'),
                      trailing: Icon(Icons.feedback),
                      onTap: () => {Navigator.of(context)
                          .push(MaterialPageRoute(builder: (BuildContext context) {
                        return FeedbackScreen();
                      })),},
                    ),
                    Divider(
                      color: Colors.black,
                      height: 5,
                    ),
                    ListTile(
                      title: Text('Delete Account'),
                      trailing: Icon(Icons.delete_forever),
                      onTap: () => {createAlertDialogDeletion(context)},
                    ),
                    Divider(
                      color: Colors.black,
                      height: 5,
                    ),
                    ListTile(
                      title: Text('Logout'),
                      trailing: Icon(Icons.exit_to_app),
                      onTap: () => signout(authNotifier),
                    ),
                  ],
                ),
              ),
              body: ListView.builder(
                itemCount: recordNotifier.recordList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      Container(
                        height: 40.0,
                        width: double.infinity,
                        margin:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 2),
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              DateFormat('✓  kk:mm | dd-MM-yyyy').format(
                                  recordNotifier.recordList[index].createdAt
                                      .toDate()),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15),
                            ),
                            Container(
                              child: Text(
                                'Medicine: ${recordNotifier.recordList[index].type}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                ),
                              ) ,
                            )

                          ],
                        ),
                      ),
                    ],
                  );


                },
              ),
            ),
          ],
        ),
      );

  }
}
