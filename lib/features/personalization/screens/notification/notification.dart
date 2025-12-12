import 'package:flutter/material.dart';
import 'package:ec402_app/services/notification_service.dart';
import 'package:ec402_app/utils/helpers/user_session.dart'; // nếu bạn lưu JWT

// TAppBar
import 'package:ec402_app/common/widgets/appbar/appbar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> notifications = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final jwt = await UserSession.getToken();   // tuỳ theo bạn lưu token
    final data = await NotificationService.fetchNotifications(jwt.toString());
    setState(() {
      notifications = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (loading) {
      return Scaffold(
        appBar: TAppBar(title: const Text("Notifications"), showBackArrow: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: TAppBar(title: const Text("Notifications"), showBackArrow: true),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) {
          final item = notifications[index];
          final isRead = item["is_read"] == 1;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isRead
                  ? theme.cardColor
                  : theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["title"],
                  style: TextStyle(
                    fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(item["body"]),
                const SizedBox(height: 6),
                Text(
                  item["created_at"],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
