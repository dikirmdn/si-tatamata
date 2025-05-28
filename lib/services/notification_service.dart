import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:typed_data';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    
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
    
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification click
        if (response.payload != null) {
          // Buka aplikasi
          _notifications.getNotificationAppLaunchDetails().then((details) {
            if (details?.didNotificationLaunchApp ?? false) {
              // Aplikasi akan terbuka otomatis
            }
          });
        }
      },
    );
    
    // Buat channel notifikasi dengan suara dan getaran
    final androidChannel = AndroidNotificationChannel(
      'jadwal_kontrol_channel',
      'Jadwal Kontrol',
      description: 'Notifikasi untuk jadwal kontrol',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 1000, 1000, 1000, 1000]),
      sound: RawResourceAndroidNotificationSound('alarm'),
    );
    
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(androidChannel);
      // Request izin getaran
      await androidPlugin.requestPermission();
    }
  }

  // Method untuk kompatibilitas dengan kode lama
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    return scheduleAlarm(
      id: id,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      isAlarm: false,
    );
  }

  Future<void> scheduleAlarm({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    bool isAlarm = true,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'jadwal_kontrol_channel',
      'Jadwal Kontrol',
      channelDescription: 'Notifikasi untuk jadwal kontrol',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('alarm'),
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 1000, 1000, 1000, 1000]),
      enableLights: true,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      channelShowBadge: true,
      visibility: NotificationVisibility.public,
      additionalFlags: Int32List.fromList(<int>[4]), // FLAG_INSISTENT
      actions: <AndroidNotificationAction>[
        const AndroidNotificationAction('open_app', 'Buka Aplikasi'),
      ],
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'alarm.wav',
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'open_app', // Payload untuk membuka aplikasi
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
} 