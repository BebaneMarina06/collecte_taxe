import 'package:e_taxe/design/design.dart';
import 'package:e_taxe/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Notifcations extends StatelessWidget {
  const Notifcations({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController _controller = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: Design.primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.offNamed('/AccueilAgent');
          },
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Design.primaryColor,
        actions: [
          Obx(() => _controller.unreadCount.value > 0
              ? IconButton(
                  icon: const Icon(Icons.done_all),
                  onPressed: () => _controller.markAllAsRead(),
                  tooltip: 'Tout marquer comme lu',
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading.value && _controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  _controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _controller.loadNotifications(),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        if (_controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/notif.png',
                  width: 200,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.notifications_none, size: 100, color: Colors.grey);
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Aucune notification pour le moment',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'Restez informé ! C\'est ici que vous verrez les notifications',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _controller.loadNotifications(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = _controller.notifications[index];
              final isRead = notification['read'] == true;
              final dateFormat = DateFormat('dd/MM/yyyy à HH:mm', 'fr');
              DateTime? date;
              
              if (notification['created_at'] != null) {
                try {
                  date = DateTime.parse(notification['created_at']);
                } catch (e) {
                  date = null;
                }
              }

              return Card(
                elevation: isRead ? 2 : 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: isRead ? Design.inputColor : Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: isRead
                        ? Design.mediumGrey
                        : Design.secondColor,
                    child: Icon(
                      _getNotificationIcon(notification['type']),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    notification['title'] ?? 'Notification',
                    style: TextStyle(
                      fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        notification['message'] ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: isRead ? Colors.grey : Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (date != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          dateFormat.format(date),
                          style: TextStyle(
                            fontSize: 10,
                            color: Design.mediumGrey,
                          ),
                        ),
                      ],
                    ],
                  ),
                  trailing: !isRead
                      ? Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Design.secondColor,
                            shape: BoxShape.circle,
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20),
                          onPressed: () {
                            _controller.deleteNotification(notification['id'] as int);
                          },
                        ),
                  onTap: () {
                    if (!isRead) {
                      _controller.markAsRead(notification['id'] as int);
                    }
                    // Navigation selon le type de notification
                    _handleNotificationTap(notification);
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }

  IconData _getNotificationIcon(String? type) {
    switch (type) {
      case 'collecte':
        return Icons.payment;
      case 'cloture':
        return Icons.account_balance_wallet;
      case 'alerte':
        return Icons.warning;
      case 'system':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    final type = notification['type'];
    final data = notification['data'] as Map<String, dynamic>?;

    switch (type) {
      case 'collecte':
        if (data?['collecte_id'] != null) {
          Get.toNamed('/DetailsCollecte', arguments: data!['collecte_id']);
        }
        break;
      case 'cloture':
        Get.toNamed('/ClotureJournee');
        break;
      default:
        break;
    }
  }
}
