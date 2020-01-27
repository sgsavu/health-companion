import 'package:diabetes_app/feedback.dart';
import 'package:diabetes_app/feedback_api.dart';
import 'package:diabetes_app/global_api.dart';
import 'package:diabetes_app/loading.dart';
import 'package:diabetes_app/login/auth_notifier.dart';
import 'package:diabetes_app/profile/profile_api.dart';
import 'package:diabetes_app/profile/profile_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String currentMessage;
  bool loading=false;
  FeedbackModel feedbackModel = FeedbackModel();

  void initState() {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    ProfileNotifier profileNotifier =
    Provider.of<ProfileNotifier>(context, listen: false);
    getProfile(profileNotifier,authNotifier.user.email);
  }


  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Feedback',
          labelStyle: TextStyle(
            fontSize: 15.0,
          ),
          hintText: 'I really love the app.',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 12.0,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          prefixIcon: Icon(Icons.feedback)),
      cursorColor: Colors.white,
      validator: (String value) {




        return null;
      },
      onSaved: (String value) {
        currentMessage = value;
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

    ProfileNotifier profileNotifier = Provider.of<ProfileNotifier>(context);

    feedbackModel.userName=profileNotifier.currentProfile.name;
    feedbackModel.userEmail=profileNotifier.currentProfile.email;
    feedbackModel.message=currentMessage;

    try{
      uploadFeedback(feedbackModel);
      await createAlertDialogCustom(context, 'Success', 'Your feedback has been successfully sent to us..', AssetImage('assets/check.png'));
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
                      'Send us your feedback',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 50,),
                    Text(
                      'Please enter your message below:',
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
