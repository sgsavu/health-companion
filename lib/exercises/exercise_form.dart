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
      createAlertDialog2(context);

    });
    super.initState();

  }

  createAlertDialog2(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success!'),
            content: Container(
              child: Text('A reminder has been set for the selected workout plan. Head over to the Notifications Tab if you wish to view/delete the current workout plan reminder. \n'),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return Loading();
  }
}
