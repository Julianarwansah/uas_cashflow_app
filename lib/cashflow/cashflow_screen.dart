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
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isDateFilterActive = false;

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
            _buildDateFilterSection(),
            Expanded(child: _buildTransactionList()),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildHeader() {
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

        // Client-side filtering
        final transactions = allTransactions.where((t) {
          if (_selectedFilter == 1) return t.type == TransactionType.income;
          if (_selectedFilter == 2) return t.type == TransactionType.expense;
          return true;
        }).toList();

        if (transactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 80,
                  color: AppTheme.textSecondary.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada transaksi',
                  style: AppTheme.titleMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        // Group transactions by date
        final groupedTransactions = <String, List<Transaction>>{};
        final dateFormat = DateFormat('dd/MM/yyyy');

        for (var transaction in transactions) {
          final dateKey = dateFormat.format(transaction.date);
          groupedTransactions.putIfAbsent(dateKey, () => []);
          groupedTransactions[dateKey]!.add(transaction);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: groupedTransactions.length,
          itemBuilder: (context, index) {
            final date = groupedTransactions.keys.elementAt(index);
            final dayTransactions = groupedTransactions[date]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    date,
                    style: AppTheme.labelLarge.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dayTransactions.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: AppTheme.softBlue.withValues(alpha: 0.5),
                      indent: 72,
                    ),
                    itemBuilder: (context, i) {
                      return _buildTransactionItem(dayTransactions[i]);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final isIncome = transaction.type == TransactionType.income;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TransactionFormScreen(transaction: transaction),
          ),
        );
      },
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isIncome
              ? AppTheme.incomeGreenLight
              : AppTheme.expenseRedLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          Transaction.getCategoryIcon(transaction.category),
          color: isIncome ? AppTheme.incomeGreen : AppTheme.expenseRed,
          size: 22,
        ),
      ),
      title: Text(transaction.category, style: AppTheme.titleMedium),
      subtitle: transaction.note != null
          ? Text(
              transaction.note!,
              style: AppTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${isIncome ? '+' : '-'} ${formatCurrency(transaction.amount)}',
            style: AppTheme.titleMedium.copyWith(
              color: isIncome ? AppTheme.incomeGreen : AppTheme.expenseRed,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentBlue.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TransactionFormScreen(),
            ),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }
}
