import 'package:diabetes_app/login/auth_notifier.dart';
import 'package:diabetes_app/medicine/medicine_detail.dart';
import 'package:diabetes_app/medicine/medicine_api.dart';
import 'package:diabetes_app/medicine/medicine_form.dart';
import 'package:diabetes_app/medicine/medicine_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MedicineTab extends StatefulWidget {
  @override
  _MedicineTabState createState() => _MedicineTabState();
}

class _MedicineTabState extends State<MedicineTab>{


  @override
  void initState() {

    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    MedicineNotifier medicineNotifier =
    Provider.of<MedicineNotifier>(context, listen: false);
    getMedicine(medicineNotifier, authNotifier.user.displayName);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    MedicineNotifier medicineNotifier = Provider.of<MedicineNotifier>(context);

    return Scaffold(
      body: ListView.builder(
        itemCount: medicineNotifier.medicineList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () async {
                medicineNotifier.currentMedicine =
                medicineNotifier.medicineList[index];
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return MedicineDetail();
                }
                )
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    height: 200.0,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 10.0
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: NetworkImage(medicineNotifier.medicineList[index].image != null
                            ? medicineNotifier.medicineList[index].image
                            : 'https://www.afd.fr/sites/afd/files/styles/visuel_principal/public/2019-10-09-27-46/flickr-marco-verch.jpg?itok=XH4x7-Y4',),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0,2),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(60.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white70,
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          medicineNotifier.medicineList[index].name,
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(medicineNotifier.medicineList[index].intake,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                          ),

                        ),
                      ],
                    ),
                  )
                ],
              )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          medicineNotifier.currentMedicine = null;
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return MedicineForm(
              isUpdating: false,
            );
          }));
        },
        child: Icon(Icons.add),
      ),
    );

  }


}