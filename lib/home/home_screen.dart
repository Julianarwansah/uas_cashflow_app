import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/transaction.dart';
import '../cashflow/transaction_form_screen.dart';
import '../notifications/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onViewAllTap;

  const HomeScreen({super.key, this.onViewAllTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<List<Transaction>> _transactionsStream;

  @override
  void initState() {
    super.initState();
    _initStream();
  }

  void _initStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _transactionsStream = Stream.value([]);
      return;
    }

    _transactionsStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Transaction.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  double _calculateTotalBalance(List<Transaction> transactions) {
    return transactions.fold(0, (total, t) {
      return total + (t.type == TransactionType.income ? t.amount : -t.amount);
    });
  }
}
