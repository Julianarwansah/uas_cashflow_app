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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterTabs(),
            Expanded(child: _buildTransactionList()),
          ],
        ),
      ),
      // FAB
    );
  }

  Widget _buildHeader() {
    // ... same as before
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Riwayat Transaksi', style: AppTheme.headlineMedium),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: AppTheme.accentBlue,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppTheme.softShadow,
                ),
                child: Icon(Icons.search_rounded, color: AppTheme.accentBlue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.softShadow,
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppTheme.accentBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppTheme.textSecondary,
        labelStyle: AppTheme.labelLarge,
        padding: const EdgeInsets.all(6),
        tabs: const [
          Tab(text: 'Semua'),
          Tab(text: 'Masuk'),
          Tab(text: 'Keluar'),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return StreamBuilder<List<Transaction>>(
      stream: _transactionsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final allTransactions = snapshot.data ?? [];
        return Container(); // Coming soon
      },
    );
  }
}
