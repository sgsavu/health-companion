import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_data.dart';
import '../custom_input_field.dart';

class CreateNotificationPage extends StatefulWidget {
  @override
  _CreateNotificationPageState createState() => _CreateNotificationPageState();
}

class _CreateNotificationPageState extends State<CreateNotificationPage> {

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Create Notification',style: TextStyle(
          color: Colors.blue
        ),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child:Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      CustomInputField(
                        controller: _titleController,
                        hintText: 'Title',
                        inputType: TextInputType.text,
                        autoFocus: true,
                      ),
                      SizedBox(height: 12),
                      CustomInputField(
                        controller: _descriptionController,
                        hintText: 'Description',
                        inputType: TextInputType.text,
                        autoFocus: true,
                      ),
                      SizedBox(height: 12),
                      OutlineButton(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
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
                ),
              ),

          ],
        ),
      ),
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
    if (_formKey.currentState.validate()) {
      final title = _titleController.text;
      final description = _descriptionController.text;
      final time = Time(selectedTime.hour, selectedTime.minute);

      final notificationData = NotificationData(title, description, time);
      Navigator.of(context).pop(notificationData);
    }
  }
}