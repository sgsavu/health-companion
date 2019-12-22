import 'package:diabetes_app/notifications/create_notification_page.dart';
import 'package:diabetes_app/notifications/notification_data.dart';
import 'package:diabetes_app/notifications/notification_plugin.dart';
import 'package:diabetes_app/notifications/notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsTab extends StatefulWidget {
  @override
  _NotificationsTabState createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab>{

  final NotificationPlugin _notificationPlugin = NotificationPlugin();
  Future<List<PendingNotificationRequest>> notificationFuture;

  @override
  void initState() {

    super.initState();
    notificationFuture = _notificationPlugin.getScheduledNotifications();
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


  Future<void> dismissNotification(int id) async {
    await _notificationPlugin.cancelNotification(id);
    refreshNotification();
  }

  void refreshNotification() {
    setState(() {
      notificationFuture = _notificationPlugin.getScheduledNotifications();
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
      await _notificationPlugin.getScheduledNotifications();
      int id = 0;
      for (var i = 0; i < 100; i++) {
        bool exists = _notificationPlugin.checkIfIdExists(notificationList, i);
        if (!exists) {
          id = i;
        }
      }
      await _notificationPlugin.showDailyAtTime(
        notificationData.time,
        id,
        notificationData.title,
        notificationData.description,
      );
      refreshNotification();
    }
  }
}
