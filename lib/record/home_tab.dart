import 'package:diabetes_app/login/auth_notifier.dart';
import 'package:diabetes_app/login/login_api.dart';
import 'package:diabetes_app/medicine/medicine.dart';
import 'package:diabetes_app/medicine/medicine_api.dart';
import 'package:diabetes_app/medicine/medicine_notifier.dart';
import 'package:diabetes_app/record/record_api.dart';
import 'package:diabetes_app/record/record_notifier.dart';
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
  Medicine _selectedCompany;
  bool canShow = false;

  @override
  void initState() {
    RecordNotifier recordNotifier =
        Provider.of<RecordNotifier>(context, listen: false);
    getRecord(recordNotifier);

    MedicineNotifier medicineNotifier =
        Provider.of<MedicineNotifier>(context, listen: false);
    getMedicine(medicineNotifier);

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

  onChangeDropdownItem(Medicine selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
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
                        type: _selectedCompany.name);
                  }));
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

    _dropdownMenuItems = buildDropDownMenuItems(medicineNotifier.medicineList);

    return Container(
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
                  "Welcome back, ${authNotifier.user != null ? authNotifier.user.displayName : "Feed"}!",
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
                          value: _selectedCompany,
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
                      Divider(
                        color: Colors.black,
                      ),
                      Text(
                        'Medicine Intake History',
                        style: TextStyle(
                          letterSpacing: 1.5,
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w900),
                      ),

                      SizedBox(height: 5,)
                    ]))),
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(
                        "${authNotifier.user != null ? authNotifier.user.displayName : "Feed"}"),
                    accountEmail: Text(
                        "${authNotifier.user != null ? authNotifier.user.email : "Feed"}"),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://upload.wikimedia.org/wikipedia/commons/0/04/John_Legend_2019_by_Glenn_Francis.jpg'),
                    ),
                  ),
                  ListTile(
                    title: Text('About'),
                    trailing: Icon(Icons.info),
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
