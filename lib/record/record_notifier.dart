import 'dart:collection';
import 'package:diabetes_app/record/record.dart';
import 'package:flutter/cupertino.dart';

class RecordNotifier with ChangeNotifier{

  List<Record> _recordList = [];
  Record _currentRecord;

  UnmodifiableListView<Record> get recordList => UnmodifiableListView(_recordList);

  Record get currentRecord => _currentRecord;

  set recordList (List<Record> recordList){
    _recordList = recordList;
    notifyListeners();
  }

  set currentRecord(Record record){
    _currentRecord = record;
    notifyListeners();
  }

  addRecord(Record record){

    _recordList.insert(0, record);
    notifyListeners();
  }



}