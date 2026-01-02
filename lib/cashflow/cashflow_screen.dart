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

  Widget _buildDateFilterSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Tanggal',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
              if (_isDateFilterActive)
                TextButton(
                  onPressed: _resetDateFilter,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Reset',
                    style: AppTheme.labelMedium.copyWith(
                      color: AppTheme.expenseRed,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDateButton(
                  label: _startDate != null
                      ? DateFormat('dd/MM/yyyy').format(_startDate!)
                      : 'Dari Tanggal',
                  icon: Icons.calendar_today_rounded,
                  onTap: () => _selectStartDate(),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.arrow_forward,
                color: AppTheme.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateButton(
                  label: _endDate != null
                      ? DateFormat('dd/MM/yyyy').format(_endDate!)
                      : 'Sampai Tanggal',
                  icon: Icons.calendar_today_rounded,
                  onTap: () => _selectEndDate(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: _endDate ?? DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.accentBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
        _isDateFilterActive = _startDate != null || _endDate != null;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.accentBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
        _isDateFilterActive = _startDate != null || _endDate != null;
      });
    }
  }

  Widget _buildDateButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.softBlue.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.accentBlue.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: AppTheme.accentBlue),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: AppTheme.labelMedium.copyWith(
                  color: AppTheme.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetDateFilter() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _isDateFilterActive = false;
    });
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
          // Type filter (All/Income/Expense)
          bool typeMatch = true;
          if (_selectedFilter == 1) return t.type == TransactionType.income;
          if (_selectedFilter == 2) return t.type == TransactionType.expense;

          // Date filter
          bool dateMatch = true;
          if (_isDateFilterActive) {
            if (_startDate != null && _endDate != null) {
              // Both dates selected
              final transactionDate = DateTime(
                t.date.year,
                t.date.month,
                t.date.day,
              );
              final start = DateTime(
                _startDate!.year,
                _startDate!.month,
                _startDate!.day,
              );
              final end = DateTime(
                _endDate!.year,
                _endDate!.month,
                _endDate!.day,
                23,
                59,
                59,
              );
              dateMatch =
                  transactionDate.isAfter(
                    start.subtract(const Duration(seconds: 1)),
                  ) &&
                  transactionDate.isBefore(end.add(const Duration(seconds: 1)));
            } else if (_startDate != null) {
              // Only start date selected
              final transactionDate = DateTime(
                t.date.year,
                t.date.month,
                t.date.day,
              );
              final start = DateTime(
                _startDate!.year,
                _startDate!.month,
                _startDate!.day,
              );
              dateMatch = transactionDate.isAfter(
                start.subtract(const Duration(seconds: 1)),
              );
            } else if (_endDate != null) {
              // Only end date selected
              final transactionDate = DateTime(
                t.date.year,
                t.date.month,
                t.date.day,
              );
              final end = DateTime(
                _endDate!.year,
                _endDate!.month,
                _endDate!.day,
                23,
                59,
                59,
              );
              dateMatch = transactionDate.isBefore(
                end.add(const Duration(seconds: 1)),
              );
            }
          }

          return typeMatch && dateMatch;
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
