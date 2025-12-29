import 'package:flutter/material.dart';

enum TransactionType { income, expense }

class Transaction {
  final String id;
  final double amount;
  final String category;
  final DateTime date;
  final TransactionType type;
  final String? note;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    this.note,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
