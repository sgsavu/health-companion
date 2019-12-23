import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    Key key,
    @required this.notification,
    @required this.deleteNotification,
  }) : super(key: key);

  final PendingNotificationRequest notification;
  final Function(int id) deleteNotification;

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    notification.title,
                    style: textTheme.title.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  smallHeight,
                  Text(
                    notification.body,
                    style: textTheme.subtitle.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  smallHeight,
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        size: 28,
                        color: Theme.of(context).accentColor,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Every day',
                        style: textTheme.headline.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => deleteNotification(notification.id),
              icon: Icon(Icons.delete, size: 32),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox get smallHeight => SizedBox(height: 8);
}