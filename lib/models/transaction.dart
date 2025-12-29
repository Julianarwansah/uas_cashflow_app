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

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'type': type == TransactionType.income ? 'income' : 'expense',
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map, String id) {
    return Transaction(
      id: id,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
      type: map['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      note: map['note'] as String?,
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Transaction copyWith({
    String? id,
    double? amount,
    String? category,
    DateTime? date,
    TransactionType? type,
    String? note,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      type: type ?? this.type,
      note: note ?? this.note,
      createdAt: createdAt,
    );
  }

  // Category icons mapping
  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'gaji':
        return Icons.account_balance_wallet;
      case 'bonus':
        return Icons.card_giftcard;
      case 'makanan':
        return Icons.restaurant;
      case 'transportasi':
        return Icons.directions_car;
      case 'belanja':
        return Icons.shopping_bag;
      case 'hiburan':
        return Icons.movie;
      case 'kesehatan':
        return Icons.local_hospital;
      case 'pendidikan':
        return Icons.school;
      case 'tagihan':
        return Icons.receipt_long;
      case 'investasi':
        return Icons.trending_up;
      case 'hadiah':
        return Icons.redeem;
      case 'lainnya':
      default:
        return Icons.category;
    }
  }

  static List<String> get incomeCategories => [
    'Gaji',
    'Bonus',
    'Investasi',
    'Hadiah',
    'Lainnya',
  ];

  static List<String> get expenseCategories => [
    'Makanan',
    'Transportasi',
    'Belanja',
    'Hiburan',
    'Kesehatan',
    'Pendidikan',
    'Tagihan',
    'Lainnya',
  ];
}
