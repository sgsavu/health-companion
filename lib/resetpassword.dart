import 'package:diabetes_app/global_api.dart';
import 'package:diabetes_app/loading.dart';
import 'package:diabetes_app/login/login_api.dart';
import 'package:flutter/material.dart';

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

        if (value.isNotEmpty) {
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
      await createAlertDialogCustom(context, 'Success', 'Password reset email has been successfully sent.', AssetImage('assets/check.png'));
      Navigator.pop(context);
    }catch (error){
      createAlertDialogCustom(context, 'Error', error.toString(), AssetImage('assets/wrong.png'));
    }

    setState(() {
      loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return loading?Loading():Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Reset Password',
          style: TextStyle(color: Colors.blue),
        ),
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
