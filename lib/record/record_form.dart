import 'package:diabetes_app/loading.dart';
import 'package:diabetes_app/record/record.dart';
import 'package:diabetes_app/record/record_api.dart';
import 'package:diabetes_app/record/record_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RecordForm extends StatefulWidget{

  final String bro;
  final String type;
  final String email;

  RecordForm({

    @required this.bro,
    @required this.type,
    @required this.email
  });

  @override
  _RecordFormState createState() => _RecordFormState();
}

class _RecordFormState extends State<RecordForm>{

  Record _currentRecord;

  @override
  void initState(){
    super.initState();
    RecordNotifier recordNotifier = Provider.of<RecordNotifier>(context, listen: false);

    if(recordNotifier.currentRecord != null){
      _currentRecord = recordNotifier.currentRecord;
    } else{
      _currentRecord = Record();
    }

    uploadRecord(_currentRecord, _onRecordUploaded, widget.bro, widget.type, widget.email);
  }

  _onRecordUploaded(Record record){

    RecordNotifier recordNotifier = Provider.of<RecordNotifier>(context);

    recordNotifier.addRecord(record);

    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Loading();
  }
}
