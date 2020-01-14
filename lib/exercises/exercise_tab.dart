import 'package:diabetes_app/app.dart';
import 'package:diabetes_app/exercises/exercise_api.dart';
import 'package:diabetes_app/exercises/exercise_form.dart';
import 'package:diabetes_app/exercises/exercise_notifier.dart';
import 'package:diabetes_app/login/auth_notifier.dart';
import 'package:diabetes_app/notifications/notification_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class ExerciseTab extends StatefulWidget {
  @override
  _ExerciseTabState createState() => _ExerciseTabState();
}

class _ExerciseTabState extends State<ExerciseTab> {
  void initState() {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    ExerciseNotifier exerciseNotifier =
        Provider.of<ExerciseNotifier>(context, listen: false);
    getExercise(exerciseNotifier,authNotifier.user.email);
    super.initState();
    _initializeNotifications();
    notificationFuture = getScheduledNotifications();
  }

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  Future<List<PendingNotificationRequest>> notificationFuture;

  bool canShow = false;
  bool showButton = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  int selectedIndex;


  @override
  Widget build(BuildContext context) {
    ExerciseNotifier exerciseNotifier = Provider.of<ExerciseNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.0),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        centerTitle: true,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(canShow?showButton?130.0:90:50),
            child: Column(
              children: <Widget>[
                Container(
                  child: canShow
                      ? Text(
                          'Selected workout plan: ${exerciseNotifier.currentExercise.name} ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      : Text(
                          'No workout plan selected',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                ),
                SizedBox(height: 10,),
                canShow
                    ? SizedBox()
                    : Text(
                  'Select any of the plans below to set a reminder',
                  style: TextStyle(
                      fontSize: 13),
                ),
                Container(
                  child:canShow? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Select time daily:   '),
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
                  ): SizedBox()
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 0,
                    top: 15,
                    right: 0,
                    bottom: 15,
                  ),
                  alignment: Alignment.center,
                  child: showButton?FloatingActionButton.extended(
                    backgroundColor: Colors.blueAccent,
                    icon: Icon(Icons.done_outline),
                    label: Text('Save workout plan'),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (BuildContext context) {
                        return ExerciseForm();
                      }));
                      navigateToNotificationCreation(exerciseNotifier.currentExercise.name);
                    },
                  ):SizedBox(),
                )
              ],
            )),
      ),
      body: ListView.builder(
        itemCount: exerciseNotifier.exerciseList.length,
        itemBuilder: (BuildContext context, int index) {
          if(index==selectedIndex)
            {
              return GestureDetector(
                  onTap: () async {
                    exerciseNotifier.currentExercise =
                    exerciseNotifier.exerciseList[index];
                    canShow = true;
                    selectedIndex=index;
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                          height: 200,
                          width: double.infinity,
                          margin:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          padding:
                          EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 2),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: <Widget>[
                                Text(
                                  exerciseNotifier.exerciseList[index].name,
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),
                                ),
                                Text(
                                  exerciseNotifier.exerciseList[index].type,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '○  ${exerciseNotifier.exerciseList[index].set1}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white
                                      ),
                                    ),
                                    Text(
                                      '○  ${exerciseNotifier.exerciseList[index].set2}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                          color: Colors.white
                                      ),
                                    ),

                                    Text(
                                      '○  ${exerciseNotifier.exerciseList[index].set3}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                          color: Colors.white
                                      ),
                                    ),
                                    Text(
                                      '○  ${exerciseNotifier.exerciseList[index].set4}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                          color: Colors.white
                                      ),
                                    ),
                                    Text(
                                      '○  ${exerciseNotifier.exerciseList[index].set5}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                          color: Colors.white
                                      ),

                                    ),
                                  ],
                                )

                              ],
                            ),
                          )
                      ),
                    ],
                  ));
            }
          return GestureDetector(
              onTap: () async {
                exerciseNotifier.currentExercise =
                    exerciseNotifier.exerciseList[index];
                canShow = true;
                selectedIndex=index;
              },
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    height: 200.0,
                    width: double.infinity,
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
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
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          Text(
                            exerciseNotifier.exerciseList[index].name,
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            exerciseNotifier.exerciseList[index].type,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '○  ${exerciseNotifier.exerciseList[index].set1}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                              Text(
                                '○  ${exerciseNotifier.exerciseList[index].set2}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),

                              Text(
                                '○  ${exerciseNotifier.exerciseList[index].set3}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                              Text(
                                '○  ${exerciseNotifier.exerciseList[index].set4}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                              Text(
                                '○  ${exerciseNotifier.exerciseList[index].set5}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          )

                        ],
                      ),
                    )
                  ),
                ],
              ));
        },
      ),
    );
  }

  Future<List<PendingNotificationRequest>> getScheduledNotifications() async {
    final pendingNotifications =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications;
  }

  Future<void> navigateToNotificationCreation(String workoutName) async {

    NotificationData notificationData = NotificationData(
        '$workoutName reminder @ ${selectedTime.hour>10?selectedTime.hour:"0${selectedTime.hour}"}:${selectedTime.minute>10?selectedTime.minute:"0${selectedTime.minute}"}',
        'Hi, it\'s time to do some sport. Head over to the Exercise section for a full description of your selected plan.',
        Time(selectedTime.hour, selectedTime.minute));

    if (notificationData != null) {
      final notificationList = await getScheduledNotifications();
      int id = 0;
      for (var i = 0; i < 100; i++) {
        bool exists = checkIfIdExists(notificationList, i);
        if (!exists) {
          id = i;
        }
      }
      await showDailyAtTime(
        notificationData.time,
        id,
        notificationData.title,
        notificationData.description,
      );
      refreshNotification();
    }

  }

  bool checkIfIdExists(List<PendingNotificationRequest> notifications, int id) {
    for (final notification in notifications) {
      if (notification.id == id) {
        return true;
      }
    }
    return false;
  }

  Future<void> showDailyAtTime(
      Time time, int id, String title, String description) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'test ticker');
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.showDailyAtTime(
      id,
      title,
      description,
      time,
      platformChannelSpecifics,
    );
  }

  void refreshNotification() {
    setState(() {
      notificationFuture = getScheduledNotifications();
    });
  }

  void _initializeNotifications() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS,
    );
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
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
    showButton = true;
  }
}
