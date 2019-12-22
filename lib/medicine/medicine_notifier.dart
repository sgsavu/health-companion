import 'dart:collection';
import 'package:diabetes_app/medicine/medicine.dart';
import 'package:flutter/cupertino.dart';

class MedicineNotifier with ChangeNotifier{
  List<Medicine> _medicineList = [];
  Medicine _currentMedicine;

  UnmodifiableListView<Medicine> get medicineList => UnmodifiableListView(_medicineList);

  Medicine get currentMedicine => _currentMedicine;

  set medicineList (List<Medicine> medicineList){
    _medicineList = medicineList;
    notifyListeners();
  }

  set currentMedicine(Medicine medicine){
    _currentMedicine = medicine;
    notifyListeners();
  }

  addMedicine(Medicine medicine){

    _medicineList.insert(0, medicine);
    notifyListeners();
  }

  deleteMedicine(Medicine medicine){
    _medicineList.removeWhere((_medicine) => _medicine.id == medicine.id );
    notifyListeners();

  }


}