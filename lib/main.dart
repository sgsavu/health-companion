import 'package:diabetes_app/login/auth_notifier.dart';
import 'package:diabetes_app/home.dart';
import 'package:diabetes_app/login/login.dart';
import 'package:diabetes_app/medicine/medicine_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() => runApp(MultiProvider(
  providers: [
    ChangeNotifierProvider(
      builder: (context) => AuthNotifier(),
    ),
    ChangeNotifierProvider(
      builder: (context) => MedicineNotifier(),
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
      ),
      home: Consumer<AuthNotifier>(
        builder: (context, notifier, child) {
          return notifier.user != null ? HomePage() : Login();
        },
      ),
    );
  }
}
