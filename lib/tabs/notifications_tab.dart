import 'package:diabetes_app/app.dart';
import 'package:diabetes_app/notifications/create_notification_page.dart';
import 'package:diabetes_app/notifications/notification_data.dart';
import 'package:diabetes_app/notifications/notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsTab extends StatefulWidget {
  @override
  _NotificationsTabState createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab>{

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  Future<List<PendingNotificationRequest>> notificationFuture;

  @override
  void initState() {

    super.initState();
    _initializeNotifications();
    notificationFuture = getScheduledNotifications();

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:Center(
        child: Column(
          children: <Widget>[
            FutureBuilder<List<PendingNotificationRequest>>(
              future: notificationFuture,
              initialData: [],
              builder: (context, snapshot) {
                final notifications = snapshot.data;
                if (notifications.isEmpty)
                  return Expanded(
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        height: 300,
                        width: 300,
                        child: Text('There are no scheduled reminders set.'),
                      ),
                    ),
                  );
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 30),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return NotificationTile(
                        notification: notification,
                        deleteNotification: dismissNotification,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToNotificationCreation,
        child: Icon(Icons.notifications),
      ),
    );


  }


  Future<void> showWeeklyAtDayAndTime(Time time, Day day, int id, String title, String description) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'show weekly channel id',
      'show weekly channel name',
      'show weekly description',
    );
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
      id,
      title,
      description,
      day,
      time,
      platformChannelSpecifics,
    );
  }

  Future<void> showDailyAtTime(Time time, int id, String title, String description) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel id',
        'channel name',
        'channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'test ticker'
    );
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

  Future<List<PendingNotificationRequest>> getScheduledNotifications() async {
    final pendingNotifications = await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications;
  }

  Future cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  bool checkIfIdExists(List<PendingNotificationRequest> notifications, int id) {
    for (final notification in notifications) {
      if (notification.id == id) {
        return true;
      }
    }
    return false;
  }



  void _initializeNotifications() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
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
    await Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()
    ));
  }

  Future<void> dismissNotification(int id) async {
    await cancelNotification(id);
    refreshNotification();
  }

  void refreshNotification() {
    setState(() {
      notificationFuture = getScheduledNotifications();
    });
  }

  Future<void> navigateToNotificationCreation() async {
    NotificationData notificationData = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateNotificationPage(),
      ),
    );
    if (notificationData != null) {
      final notificationList =
      await getScheduledNotifications();
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
}
