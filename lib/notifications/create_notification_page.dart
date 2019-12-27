import 'package:diabetes_app/login/auth_notifier.dart';
import 'package:diabetes_app/medicine/medicine.dart';
import 'package:diabetes_app/medicine/medicine_api.dart';
import 'package:diabetes_app/medicine/medicine_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'notification_data.dart';

class CreateNotificationPage extends StatefulWidget {
  @override
  _CreateNotificationPageState createState() => _CreateNotificationPageState();
}

class _CreateNotificationPageState extends State<CreateNotificationPage> {

  TimeOfDay selectedTime = TimeOfDay.now();
  List<DropdownMenuItem<Medicine>> _dropdownMenuItems;
  Medicine _selectedCompany;

  @override
  void initState() {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    MedicineNotifier medicineNotifier =
        Provider.of<MedicineNotifier>(context, listen: false);
    getMedicine(medicineNotifier, authNotifier.user.displayName);
    super.initState();
  }

  buildDropDownMenuItems(List medicine) {
    List<DropdownMenuItem<Medicine>> items = List();
    for (Medicine medicine in medicine) {
      items.add(DropdownMenuItem(
        value: medicine,
        child: Text(medicine.name),
      ));
    }
    return items;
  }

  onChangeDropdownItem(Medicine selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
    });
  }

  @override
  Widget build(BuildContext context) {
    MedicineNotifier medicineNotifier = Provider.of<MedicineNotifier>(context);
    _dropdownMenuItems = buildDropDownMenuItems(medicineNotifier.medicineList);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Create Notification',
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Container(
        height: 180.0,
        margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.symmetric(
          horizontal: 15.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Select time to schedule:',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                OutlineButton(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                  onPressed: selectTime,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.access_time),
                      SizedBox(width: 4),
                      Text(selectedTime.format(context)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Select medicine to schedule:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            OutlineButton(
              child: DropdownButton(
                value: _selectedCompany,
                items: _dropdownMenuItems,
                onChanged: onChangeDropdownItem,
              ),
            ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: createNotification,
        child: Icon(Icons.add_alarm),
      ),
    );
  }

  Future<void> selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  void createNotification() {

    final title =
        'Medicine Intake Reminder @ ${selectedTime.hour>10?selectedTime.hour:"0${selectedTime.hour}"}:${selectedTime.minute>10?selectedTime.minute:"0${selectedTime.minute}"}';
    final description =
        'Hi, it is time to take your: ${_selectedCompany.name}.';
    final time = Time(selectedTime.hour, selectedTime.minute);

    final notificationData = NotificationData(title, description, time);
    Navigator.of(context).pop(notificationData);
  }
}
