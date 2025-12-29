import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  FlutterLocalNotificationsPlugin? _notifications;
  bool _isInitialized = false;
  final _firestore = FirebaseFirestore.instance;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _notifications = FlutterLocalNotificationsPlugin();

      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications!.initialize(initSettings);

      await _requestPermissions();

      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) debugPrint('NotificationService init error: $e');
    }
  }

  Future<void> _requestPermissions() async {
    if (_notifications == null) return;

    try {
      final androidPlugin = _notifications!
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidPlugin != null) {
        await androidPlugin.requestNotificationsPermission();
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Permission request error: $e');
    }
  }

  Future<void> showTransactionNotification({
    required double amount,
    required bool isIncome,
  }) async {
    try {
      if (!_isInitialized || _notifications == null) {
        await initialize();
      }

      if (_notifications == null) return;

      final formatter = NumberFormat('#,###', 'id_ID');
      final formattedAmount = formatter.format(amount);
      final type = isIncome ? 'Pemasukan' : 'Pengeluaran';

      const androidDetails = AndroidNotificationDetails(
        'transaction_channel',
        'Transaksi',
        channelDescription: 'Notifikasi untuk transaksi',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        playSound: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications!.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        '$type Berhasil Dicatat! ✅',
        'Transaksi Rp $formattedAmount berhasil dicatat!',
        notificationDetails,
      );

      await _saveNotificationToFirestore(
        title: '$type Berhasil Dicatat! ✅',
        message: 'Transaksi Rp $formattedAmount berhasil dicatat!',
        amount: amount,
        isIncome: isIncome,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('Notification error: $e');
    }
  }
}
