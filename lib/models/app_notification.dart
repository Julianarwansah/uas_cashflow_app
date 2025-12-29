import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType { transaction, system }

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;
  final NotificationType type;
  final double? amount;
  final bool? isIncome;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
    this.type = NotificationType.transaction,
    this.amount,
    this.isIncome,
  });
}
