import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_app/loading.dart';
import 'package:diabetes_app/resetpassword.dart';
import 'package:diabetes_app/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_api.dart';
import 'package:diabetes_app/login/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diabetes_app/login/auth_notifier.dart';

enum AuthMode { Signup, Login }

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();

  AuthMode _authMode = AuthMode.Login;
  bool loading = false;
  User _user = User();

  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier);

    super.initState();
  }

  login(User user, AuthNotifier authNotifier) async {

    AuthResult authResult;

    try{
      authResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: user.email, password: user.password);
    }catch(error){
      createAlertDialog(context, 'Error', error.toString());
    }

    if (authResult != null) {
      FirebaseUser firebaseUser = authResult.user;

      if (firebaseUser != null) {
        print("Log In: $firebaseUser");
        authNotifier.setUser(firebaseUser);
      }
    } else {
      setState(() => loading = false);
    }
  }

  createAlertDialog(BuildContext context,String title,String message) {
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
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }


  signup(User user, AuthNotifier authNotifier) async {

    AuthResult authResult;

    try{
      authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: user.email, password: user.password);
    }catch(error){
      createAlertDialog(context, 'Error', error.toString());
    }

    if (authResult != null) {
      Profile profile = Profile();

      CollectionReference profileRef =
          await Firestore.instance.collection('Profile');

      profile.createdAt = Timestamp.now();

      DocumentReference documentRef = await profileRef.add(profile.toMap());
      profile.id = documentRef.documentID;
      profile.name = user.displayName;
      profile.email = user.email;
      profile.image = "https://www.sackettwaconia.com/wp-content/uploads/default-profile.png";
      profile.quizScore = 0;

      print('uploaded profile succesfully: ${profile.toString()}');

      await documentRef.setData(profile.toMap(), merge: true);

      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = user.displayName;
      FirebaseUser firebaseUser = authResult.user;

      if (firebaseUser != null) {
        await firebaseUser.updateProfile(updateInfo);

        await firebaseUser.reload();

        print("Sign up: $firebaseUser");

        FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
        authNotifier.setUser(currentUser);
      }
    } else {
      setState(() => loading = false);
    }
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() => loading = true);

    _formKey.currentState.save();

    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    if (_authMode == AuthMode.Login) {
      login(_user, authNotifier);
    } else {
      signup(_user, authNotifier);
    }
  }

  Widget _buildDisplayNameField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Full Name',
          labelStyle: TextStyle(
            fontSize: 15.0,
          ),
          hintText: 'John Markus',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 12.0,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          prefixIcon: Icon(Icons.person_pin)),
      keyboardType: TextInputType.text,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Full Name is required';
        }

        if (value.length < 3) {
          return 'Full Name must be at least 3 characters';
        }

        return null;
      },
      onSaved: (String value) {
        _user.displayName = value;
      },
    );
  }

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
        _user.email = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(
            fontSize: 15.0,
          ),
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 12.0,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          prefixIcon: Icon(Icons.lock)),
      obscureText: true,
      controller: _passwordController,
      validator: (String value) {
        if (!value.isEmpty) {
          if (value.length < 5 || value.length > 20) {
            return 'Password must be betweem 5 and 20 characters';
          }
        }

        return null;
      },
      onSaved: (String value) {
        _user.password = value;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Confirm Password',
          labelStyle: TextStyle(
            fontSize: 15.0,
          ),
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 12.0,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          prefixIcon: Icon(Icons.lock_outline)),
      obscureText: true,
      validator: (String value) {
        if (_passwordController.text != value) {
          return 'Passwords do not match';
        }

        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: Container(
              color: Colors.white,
              constraints: BoxConstraints.expand(
                height: MediaQuery.of(context).size.height,
              ),
              child: Form(
                autovalidate: true,
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(32, 50, 32, 15),
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          maxRadius: MediaQuery.of(context).size.height/8,
                          backgroundImage: AssetImage('assets/vitamin.png'),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "Health Companion",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          '${_authMode == AuthMode.Signup ? 'Account creation' : 'Authentication'}',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _authMode == AuthMode.Signup
                            ? SizedBox(height: 20)
                            : SizedBox(height: 5),
                        _authMode == AuthMode.Signup
                            ? _buildDisplayNameField()
                            : Container(),
                        SizedBox(height: 15),
                        _buildEmailField(),
                        SizedBox(height: 15),
                        _buildPasswordField(),
                        SizedBox(height: 15),
                        _authMode == AuthMode.Signup
                            ? _buildConfirmPasswordField()
                            : SizedBox(height: 0),
                        _authMode == AuthMode.Signup
                            ? SizedBox(height: 15)
                            : SizedBox(height: 0),
                        ButtonTheme(
                          minWidth: 200,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                            padding: const EdgeInsets.all(0.0),
                            textColor: Colors.white,
                            onPressed: () => _submitForm(),
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
                              child: Text(
                                _authMode == AuthMode.Login
                                    ? 'Login'
                                    : 'Sign up',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        _authMode == AuthMode.Signup?
                        SizedBox(
                          height: 16,
                        ):SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _authMode == AuthMode.Login? Text('Forgot password?'):SizedBox(),
                              _authMode == AuthMode.Login? ButtonTheme(
                                child: FlatButton(
                                  textColor: Colors.white,
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
                                        left: 5.0,
                                        top: 2.0,
                                        right: 5.0,
                                        bottom: 2.0),
                                    child: Text(
                                      'Reset password',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (BuildContext context) {
                                      return ResetPassword();
                                    }));
                                  },
                                ),
                              ):SizedBox(),
                            ],
                          ),

                            Text(
                                '${_authMode == AuthMode.Login ? "Don't have an account?" : "Have an account?"}'),
                            ButtonTheme(
                              child: FlatButton(
                                textColor: Colors.white,
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
                                      left: 10.0,
                                      top: 5.0,
                                      right: 10.0,
                                      bottom: 5.0),
                                  child: Text(
                                    '${_authMode == AuthMode.Login ? 'Sign up' : 'Log in'}',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _authMode = _authMode == AuthMode.Login
                                        ? AuthMode.Signup
                                        : AuthMode.Login;
                                  });
                                },
                              ),
                            ),





                        Text(
                          _authMode == AuthMode.Login
                              ? ''
                              : 'By signing up, you agree to our Terms, Data Policy and Cookies Policy',
                          style: TextStyle(fontSize: 9.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
