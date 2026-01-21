import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../apis/api_service.dart';
import 'package:get/get.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();
  static FirebaseMessaging? _firebaseMessaging;
  static final ApiService _apiService = ApiService();

  static bool _initialized = false;

  /// Initialiser le service de notifications
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Configuration des notifications locales
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      final firebaseReady = await _ensureFirebaseInitialized();
      if (firebaseReady) {
        _firebaseMessaging ??= FirebaseMessaging.instance;
      } else {
        print(
          '⚠️ NotificationService: Firebase non configuré, seules les notifications locales seront disponibles.',
        );
      }

      // Demander les permissions
      await _requestPermissions();

      if (_firebaseMessaging != null) {
        // Obtenir le token FCM
        final token = await _firebaseMessaging!.getToken();
        if (token != null) {
          await _apiService.registerNotificationToken(token);
          print('✅ NotificationService: Token FCM enregistré: $token');
        }

        // Écouter les nouveaux tokens
        _firebaseMessaging!.onTokenRefresh.listen((newToken) {
          _apiService.registerNotificationToken(newToken);
          print('✅ NotificationService: Nouveau token FCM: $newToken');
        });

        // Écouter les messages en foreground
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

        // Écouter les messages en background (quand l'app est ouverte depuis une notification)
        FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
      }

      _initialized = true;
      print('✅ NotificationService: Service initialisé');
    } catch (e) {
      print('❌ NotificationService: Erreur lors de l\'initialisation: $e');
    }
  }

  /// Demander les permissions
  static Future<void> _requestPermissions() async {
    // Android 13+
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // iOS
    if (_firebaseMessaging != null) {
      await _firebaseMessaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  /// Gérer les notifications en foreground
  static void _handleForegroundMessage(RemoteMessage message) {
    print('📱 NotificationService: Message reçu en foreground: ${message.notification?.title}');
    
    // Afficher une notification locale
    showLocalNotification(
      title: message.notification?.title ?? 'Nouvelle notification',
      body: message.notification?.body ?? '',
      payload: message.data.toString(),
    );
  }

  /// Gérer les messages en background
  static void _handleBackgroundMessage(RemoteMessage message) {
    print('📱 NotificationService: Message ouvert depuis background: ${message.notification?.title}');
    // Navigation peut être gérée ici
  }

  /// Callback quand une notification est tapée
  static void _onNotificationTapped(NotificationResponse response) {
    print('📱 NotificationService: Notification tapée: ${response.payload}');
    // Navigation peut être gérée ici selon le payload
  }

  /// Afficher une notification locale
  static Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'e_taxe_channel',
      'E-TAXE Notifications',
      channelDescription: 'Notifications pour l\'application E-TAXE',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id ?? DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Planifier une notification
  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    int? id,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'e_taxe_channel',
      'E-TAXE Notifications',
      channelDescription: 'Notifications pour l\'application E-TAXE',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.zonedSchedule(
      id ?? DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Planifier un rappel de clôture de journée
  static Future<void> scheduleClosingReminder(DateTime closingTime) async {
    // Rappel 30 minutes avant
    final reminderTime = closingTime.subtract(const Duration(minutes: 30));
    
    if (reminderTime.isAfter(DateTime.now())) {
      await scheduleNotification(
        title: 'Rappel de clôture',
        body: 'N\'oubliez pas de clôturer votre journée dans 30 minutes',
        scheduledDate: reminderTime,
        id: 9999, // ID fixe pour le rappel de clôture
      );
      print('✅ NotificationService: Rappel de clôture planifié pour $reminderTime');
    }
  }

  /// Annuler une notification planifiée
  static Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Annuler toutes les notifications
  static Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  static Future<bool> _ensureFirebaseInitialized() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      return true;
    } catch (e) {
      print('⚠️ NotificationService: Impossible d\'initialiser Firebase: $e');
      return false;
    }
  }
}

