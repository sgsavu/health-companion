import 'package:diabetes_app/medicine/medicine_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diabetes_app/medicine/medicine_notifier.dart';
import 'medicine_form.dart';
import 'package:diabetes_app/medicine/medicine.dart';

class MedicineDetail extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    MedicineNotifier medicineNotifier = Provider.of<MedicineNotifier>(context);

    _onMedicineDeleted(Medicine medicine){
      Navigator.pop(context);
      medicineNotifier.deleteMedicine(medicine);

    }

    return Scaffold(

      body:
      SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Image.network(
                  medicineNotifier.currentMedicine.image != null
                      ? medicineNotifier.currentMedicine.image
                      : 'https://www.afd.fr/sites/afd/files/styles/visuel_principal/public/2019-10-09-27-46/flickr-marco-verch.jpg?itok=XH4x7-Y4',
                  fit: BoxFit.fitWidth,),
                SizedBox(height: 32,),
                Text(medicineNotifier.currentMedicine.name,
                  style: TextStyle(fontSize: 40),),
                Text(medicineNotifier.currentMedicine.category,style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,

                ),),
                Container(
                  padding: EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0, bottom: 20.0),
                  child:Text(medicineNotifier.currentMedicine.description, style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 15,
                  ),) ,
                )
              ],

            ),
          ),
        ),
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
        FloatingActionButton(
          heroTag: "btn1",
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
              return MedicineForm(isUpdating: true,);
            }));
          },
          child: Icon(Icons.edit),
        ) ,
        SizedBox(height: 20,),
        FloatingActionButton(
          heroTag: "btn 2",
          onPressed: () => deleteMedicine(medicineNotifier.currentMedicine, _onMedicineDeleted),
          child: Icon(Icons.delete),
          backgroundColor: Colors.red,
        ) ,
      ],)
    );
  }
}