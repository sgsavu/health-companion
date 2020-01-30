import 'package:diabetes_app/diet/diet_tab.dart';
import 'package:diabetes_app/exercises/exercise_tab.dart';
import 'package:diabetes_app/record/home_tab.dart';
import 'package:diabetes_app/medicine/medicine_tab.dart';
import 'package:diabetes_app/notifications/notifications_tab.dart';
import 'package:flutter/material.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {

    final tabs = [
      //Medicine
      MedicineTab(),
      //Diet
      DietTab(),
      //Home
      HomeTab(),
      //Exercise
      ExerciseTab(),
      //Notifications
      NotificationsTab()
    ];

    return Scaffold(
        body: tabs[_currentIndex],
        bottomNavigationBar: TitledBottomNavigationBar(
          reverse: true,
            currentIndex: _currentIndex, // Use this to update the Bar giving a position
            onTap: (index){
              setState(() {
                _currentIndex=index;
              });
            },
            items: [
              TitledNavigationBarItem(title: 'Medicine', icon: Icons.local_hospital),
              TitledNavigationBarItem(title: 'Meals', icon: Icons.fastfood),
              TitledNavigationBarItem(title: 'Home', icon: Icons.home),
              TitledNavigationBarItem(title: 'Exercise', icon: Icons.accessibility_new),
              TitledNavigationBarItem(title: 'Notify', icon: Icons.notifications),
            ]
        )
    );
  }

}

