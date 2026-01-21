import 'package:get/get.dart';
import '../apis/api_service.dart';

class NotificationController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> notifications = <Map<String, dynamic>>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications({bool unreadOnly = false}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🔵 NotificationController: Chargement des notifications');
      final data = await _apiService.getNotifications(
        unreadOnly: unreadOnly ? true : null,
      );

      notifications.value = data;
      
      // Compter les non lues
      unreadCount.value = notifications.where((n) => n['read'] == false || n['read'] == null).length;

      print('✅ NotificationController: ${notifications.length} notifications chargées');
    } catch (e) {
      errorMessage.value = 'Erreur lors du chargement des notifications: $e';
      print('❌ NotificationController: Erreur: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      final success = await _apiService.markNotificationAsRead(notificationId);
      if (success) {
        // Mettre à jour localement
        final index = notifications.indexWhere((n) => n['id'] == notificationId);
        if (index != -1) {
          notifications[index]['read'] = true;
          notifications.refresh();
          unreadCount.value = notifications.where((n) => n['read'] == false || n['read'] == null).length;
        }
      }
    } catch (e) {
      print('❌ NotificationController: Erreur lors du marquage comme lu: $e');
    }
  }

  Future<void> deleteNotification(int notificationId) async {
    try {
      final success = await _apiService.deleteNotification(notificationId);
      if (success) {
        notifications.removeWhere((n) => n['id'] == notificationId);
        unreadCount.value = notifications.where((n) => n['read'] == false || n['read'] == null).length;
      }
    } catch (e) {
      print('❌ NotificationController: Erreur lors de la suppression: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      for (var notification in notifications) {
        if (notification['read'] == false || notification['read'] == null) {
          await markAsRead(notification['id'] as int);
        }
      }
    } catch (e) {
      print('❌ NotificationController: Erreur lors du marquage de tout comme lu: $e');
    }
  }
}

