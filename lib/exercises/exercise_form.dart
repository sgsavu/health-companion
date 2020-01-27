import 'package:diabetes_app/global_api.dart';
import 'package:diabetes_app/loading.dart';
import 'package:flutter/material.dart';


class ExerciseForm extends StatefulWidget{



  ExerciseForm();

  @override
  _ExerciseFormState createState() => _ExerciseFormState();
}

class _ExerciseFormState extends State<ExerciseForm>{


  @override
  void initState(){
    Future.delayed(const Duration(milliseconds: 1000), () {

      Navigator.pop(context);
      createAlertDialogCustom(context,'Success!','A reminder has been set for the selected workout plan. Head over to the Notifications Tab if you wish to view/delete the current workout plan reminder.', AssetImage('assets/check.png'));

    });
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Loading();
  }
}
