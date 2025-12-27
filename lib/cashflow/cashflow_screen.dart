import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/transaction.dart';
import '../notifications/notification_screen.dart';
import 'transaction_form_screen.dart';

class CashflowScreen extends StatefulWidget {
  const CashflowScreen({super.key});

  @override
  State<CashflowScreen> createState() => _CashflowScreenState();
}

class _CashflowScreenState extends State<CashflowScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedFilter = 0; // 0: All, 1: Income, 2: Expense
  late Stream<List<Transaction>> _transactionsStream;

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() => _selectedFilter = _tabController.index);
    });

    _initStream();
  }

  void _initStream() {
    // Placeholder
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
