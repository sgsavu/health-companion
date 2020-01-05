import 'package:diabetes_app/loading.dart';
import 'package:diabetes_app/login/auth_notifier.dart';
import 'package:diabetes_app/login/login_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String currentEmail;
  bool loading=false;


  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(
            fontSize: 15.0,
          ),
          hintText: 'example@gmail.com',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 12.0,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          prefixIcon: Icon(Icons.email)),
      cursorColor: Colors.white,
      validator: (String value) {

        if (!value.isEmpty) {
          if (!RegExp(
              r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
              .hasMatch(value)) {
            return 'Please enter a valid email address';
          }
        }


        return null;
      },
      onSaved: (String value) {
        currentEmail = value;
      },
    );
  }

  createAlertDialog2(BuildContext context, String title, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Container(
              child: Text(message),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  setState(() {
                    loading = false;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }


  saveForm() async{

    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      loading = true;
    });

    try{
      await sendPasswordResetEmail(currentEmail);
      await createAlertDialog2(context, 'Success', 'Password reset email has been successfully sent.');
      Navigator.pop(context);
    }catch (error){
      createAlertDialog2(context, 'Error', error.toString());
    }

    print('sent');
  }


  @override
  Widget build(BuildContext context) {
    return loading?Loading():Scaffold(
      appBar: AppBar(
            backgroundColor: Colors.white.withOpacity(0.0),
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0.0,
          ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
              height: MediaQuery.of(context).size.height * 0.90,
              child: Padding(
                padding: EdgeInsets.fromLTRB(32, 10, 32, 15),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Reset your password',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 50,),
                    Text(
                      'Please enter your email below:',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    SizedBox(height: 8,),
                    Form(
                      key: _formKey,
                      child: _buildEmailField(),
                    ),
                    SizedBox(height: 16,),
                    ButtonTheme(
                      minWidth: 200,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        padding: const EdgeInsets.all(0.0),
                        textColor: Colors.white,
                        onPressed: () => {
                          saveForm()
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFF0D47A1),
                                Color(0xFF1976D2),
                                Color(0xFF42A5F5),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.only(
                              left: 90.0,
                              top: 10.0,
                              right: 90.0,
                              bottom: 12.0),
                          child: Text('Submit',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ),
        ),
      )

    );
  }
}
