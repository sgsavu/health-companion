import 'package:diabetes_app/tabs/diet_tab.dart';
import 'package:diabetes_app/tabs/exercise_tab.dart';
import 'package:diabetes_app/tabs/home_tab.dart';
import 'package:diabetes_app/tabs/medicine_tab.dart';
import 'package:diabetes_app/tabs/notifications_tab.dart';
import 'package:flutter/material.dart';



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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          unselectedFontSize: 11,
          selectedFontSize: 13,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.local_hospital),
                title: Text('Medicine'),
                backgroundColor: Colors.red),
            BottomNavigationBarItem(
                icon: Icon(Icons.restaurant),
                title: Text('Diet'),
                backgroundColor: Colors.deepOrange),
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.accessibility_new),
                title: Text('Exercise'),
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.message),
                title: Text('Notifications'),
                backgroundColor: Colors.purple),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        )
    );
  }

}

