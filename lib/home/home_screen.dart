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

  double _calculateMonthlyIncome(List<Transaction> transactions) {
    final now = DateTime.now();
    return transactions
        .where(
          (t) =>
              t.type == TransactionType.income &&
              t.date.month == now.month &&
              t.date.year == now.year,
        )
        .fold(0, (total, t) => total + t.amount);
  }

  double _calculateMonthlyExpense(List<Transaction> transactions) {
    final now = DateTime.now();
    return transactions
        .where(
          (t) =>
              t.type == TransactionType.expense &&
              t.date.month == now.month &&
              t.date.year == now.year,
        )
        .fold(0, (total, t) => total + t.amount);
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: StreamBuilder<List<Transaction>>(
        stream: _transactionsStream,
        builder: (context, snapshot) {
          final transactions = snapshot.data ?? [];
          final totalBalance = _calculateTotalBalance(transactions);
          final monthlyIncome = _calculateMonthlyIncome(transactions);
          final monthlyExpense = _calculateMonthlyExpense(transactions);
          final recentTransactions = transactions.take(5).toList();

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildBalanceCard(totalBalance),
                  const SizedBox(height: 20),
                  _buildQuickStats(monthlyIncome, monthlyExpense),
                  const SizedBox(height: 24),
                  _buildRecentActivity(recentTransactions),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Container(
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
                builder: (context) => TransactionFormScreen(
                  onSuccess: () {
                    widget.onViewAllTap?.call();
                  },
                ),
              ),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add_rounded, size: 28),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selamat Datang! 👋', style: AppTheme.bodyMedium),
            const SizedBox(height: 4),
            Text('Dashboard Keuangan', style: AppTheme.headlineMedium),
          ],
        ),
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
      ],
    );
  }

  Widget _buildBalanceCard(double totalBalance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Saldo',
                style: AppTheme.bodyLarge.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'IDR',
                      style: AppTheme.labelLarge.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(formatCurrency(totalBalance), style: AppTheme.amountLarge),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  totalBalance >= 0
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  totalBalance >= 0 ? 'Keuangan Sehat' : 'Perlu Perhatian',
                  style: AppTheme.bodyMedium.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(double monthlyIncome, double monthlyExpense) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Pemasukan',
            formatCurrency(monthlyIncome),
            Icons.arrow_downward_rounded,
            AppTheme.incomeGreen,
            AppTheme.incomeGreenLight,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Pengeluaran',
            formatCurrency(monthlyExpense),
            Icons.arrow_upward_rounded,
            AppTheme.expenseRed,
            AppTheme.expenseRedLight,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String amount,
    IconData icon,
    Color iconColor,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(title, style: AppTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(
            amount,
            style: AppTheme.titleMedium.copyWith(color: iconColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(List<Transaction> recentTransactions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Aktivitas Terkini', style: AppTheme.titleLarge),
            TextButton(
              onPressed: widget.onViewAllTap,
              child: Text(
                'Lihat Semua',
                style: AppTheme.labelLarge.copyWith(color: AppTheme.accentBlue),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppTheme.softShadow,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentTransactions.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: AppTheme.softBlue.withValues(alpha: 0.5),
              indent: 72,
            ),
            itemBuilder: (context, index) {
              final transaction = recentTransactions[index];
              return _buildTransactionItem(transaction);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final isIncome = transaction.type == TransactionType.income;
    final dateFormat = DateFormat('dd/MM/yyyy');

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      subtitle: Text(
        dateFormat.format(transaction.date),
        style: AppTheme.bodyMedium,
      ),
      trailing: Text(
        '${isIncome ? '+' : '-'} ${formatCurrency(transaction.amount)}',
        style: AppTheme.titleMedium.copyWith(
          color: isIncome ? AppTheme.incomeGreen : AppTheme.expenseRed,
        ),
      ),
    );
  }
}
