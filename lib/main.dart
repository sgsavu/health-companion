import 'package:diabetes_app/exercises/exercise_notifier.dart';
import 'package:diabetes_app/login/auth_notifier.dart';
import 'package:diabetes_app/app.dart';
import 'package:diabetes_app/login/login.dart';
import 'package:diabetes_app/medicine/medicine_notifier.dart';
import 'package:diabetes_app/profile/profile_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diabetes_app/record/record_notifier.dart';


void main() => runApp(MultiProvider(
  providers: [
    ChangeNotifierProvider(
      builder: (context) => AuthNotifier(),
    ),
    ChangeNotifierProvider(
      builder: (context) => MedicineNotifier(),
    ),
    ChangeNotifierProvider(
      builder: (context) => RecordNotifier(),
    ),
    ChangeNotifierProvider(
      builder: (context) => ExerciseNotifier(),
    ),
    ChangeNotifierProvider(
      builder: (context) => ProfileNotifier(),
    ),
  ],
  child: MyApp(),
)
);


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'Diabetes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
          primaryColor: Colors.blueAccent
      ),
      home: Consumer<AuthNotifier>(
        builder: (context, notifier, child) {
          return notifier.user != null ? HomePage() : Login();
        },
      ),
    );
  }
}
