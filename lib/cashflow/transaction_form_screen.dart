import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/transaction.dart';
import '../services/notification_service.dart';

// ... class and imports same as before

class TransactionFormScreen extends StatefulWidget {
  final Transaction? transaction;
  final VoidCallback? onSuccess;

  const TransactionFormScreen({super.key, this.transaction, this.onSuccess});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  // ... state, variables, helpers, future methods

  bool _isIncome = true;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  bool get isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      final t = widget.transaction!;
      _isIncome = t.type == TransactionType.income;
      _amountController.text = t.amount.toStringAsFixed(0);
      _noteController.text = t.note ?? '';
      _selectedCategory = t.category;
      _selectedDate = t.date;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  List<String> get categories =>
      _isIncome ? Transaction.incomeCategories : Transaction.expenseCategories;

  // ... Helpers and Actions are same as last step, ensuring they are present
  String formatCurrency(String value) {
    if (value.isEmpty) return '';
    final number = int.tryParse(value.replaceAll('.', '')) ?? 0;
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveTransaction() async {
    // ... logic (same as before)
    if (_amountController.text.isEmpty) {
      _showSnackBar('Masukkan nominal transaksi');
      return;
    }
    if (_selectedCategory == null) {
      _showSnackBar('Pilih kategori');
      return;
    }

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showSnackBar('User tidak ditemukan, silakan login ulang');
        return;
      }

      final amount = double.parse(
        _amountController.text.replaceAll('.', '').replaceAll(',', ''),
      );

      final transactionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions');

      if (isEditing) {
        final updatedTransaction = widget.transaction!.copyWith(
          amount: amount,
          category: _selectedCategory,
          date: _selectedDate,
          type: _isIncome ? TransactionType.income : TransactionType.expense,
          note: _noteController.text,
        );

        await transactionRef
            .doc(widget.transaction!.id)
            .update(updatedTransaction.toMap())
            .timeout(const Duration(seconds: 5));
      } else {
        final newTransaction = Transaction(
          id: '',
          amount: amount,
          category: _selectedCategory!,
          date: _selectedDate,
          type: _isIncome ? TransactionType.income : TransactionType.expense,
          note: _noteController.text,
        );

        await transactionRef
            .add(newTransaction.toMap())
            .timeout(const Duration(seconds: 5));
      }

      await NotificationService().showTransactionNotification(
        amount: amount,
        isIncome: _isIncome,
      );

      if (mounted) {
        Navigator.pop(context);
        widget.onSuccess?.call();
      }
    } on TimeoutException catch (_) {
      if (mounted) {
        Navigator.pop(context);
        widget.onSuccess?.call();
        _showSnackBar('Disimpan (Menunggu koneksi)');
      }
    } catch (e) {
      if (e is TimeoutException || e.toString().contains('TimeoutException')) {
        if (mounted) {
          Navigator.pop(context);
          widget.onSuccess?.call();
          _showSnackBar('Disimpan (Menunggu koneksi)');
        }
      } else {
        if (mounted) {
          _showSnackBar('Gagal menyimpan transaksi: $e');
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteTransaction() async {
    // ... logic (same as before)
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Hapus Transaksi?', style: AppTheme.titleLarge),
        content: Text(
          'Transaksi ini akan dihapus secara permanen.',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Batal', style: AppTheme.labelLarge),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.expenseRed,
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);

              final user = FirebaseAuth.instance.currentUser;
              if (user == null || widget.transaction == null) return;

              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('transactions')
                    .doc(widget.transaction!.id)
                    .delete();

                if (mounted) {
                  Navigator.pop(context);
                  _showSnackBar('Transaksi dihapus');
                }
              } catch (e) {
                if (mounted) {
                  _showSnackBar('Gagal menghapus: $e');
                }
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        // ... AppBar content same as before
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppTheme.softShadow,
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: AppTheme.textPrimary,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditing ? 'Edit Transaksi' : 'Tambah Transaksi',
          style: AppTheme.titleLarge,
        ),
        centerTitle: true,
        actions: isEditing
            ? [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.expenseRedLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      size: 20,
                      color: AppTheme.expenseRed,
                    ),
                  ),
                  onPressed: _deleteTransaction,
                ),
                const SizedBox(width: 8),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTypeToggle(),
            const SizedBox(height: 24),
            _buildAmountField(),
            const SizedBox(height: 20),
            _buildCategorySelector(),
            const SizedBox(height: 20),
            _buildDateSelector(),
            const SizedBox(height: 20),
            _buildNoteField(),
            const SizedBox(height: 32),
            _buildSaveButton(),
            if (isEditing) ...[const SizedBox(height: 16), _buildAuditInfo()],
          ],
        ),
      ),
    );
  }

  Widget _buildTypeToggle() {
    // ... Type toggle same as before
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isIncome = true;
                  _selectedCategory = null;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _isIncome ? AppTheme.incomeGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_downward_rounded,
                      color: _isIncome ? Colors.white : AppTheme.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Pemasukan',
                      style: AppTheme.labelLarge.copyWith(
                        color: _isIncome
                            ? Colors.white
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isIncome = false;
                  _selectedCategory = null;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: !_isIncome ? AppTheme.expenseRed : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_upward_rounded,
                      color: !_isIncome ? Colors.white : AppTheme.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Pengeluaran',
                      style: AppTheme.labelLarge.copyWith(
                        color: !_isIncome
                            ? Colors.white
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nominal', style: AppTheme.labelLarge),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.softShadow,
          ),
          child: TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: AppTheme.amountMedium.copyWith(
              color: _isIncome ? AppTheme.incomeGreen : AppTheme.expenseRed,
            ),
            decoration: InputDecoration(
              prefixText: 'Rp ',
              prefixStyle: AppTheme.amountMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
              hintText: '0',
              hintStyle: AppTheme.amountMedium.copyWith(
                color: AppTheme.textSecondary.withValues(alpha: 0.5),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
            ),
            onChanged: (value) {
              final formatted = formatCurrency(value);
              if (formatted != value) {
                _amountController.value = TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kategori', style: AppTheme.labelLarge),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: categories.map((category) {
            final isSelected = _selectedCategory == category;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (_isIncome ? AppTheme.incomeGreen : AppTheme.expenseRed)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppTheme.softShadow,
                  border: Border.all(
                    color: isSelected ? Colors.transparent : AppTheme.softBlue,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Transaction.getCategoryIcon(category),
                      size: 18,
                      color: isSelected ? Colors.white : AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category,
                      style: AppTheme.labelLarge.copyWith(
                        color: isSelected ? Colors.white : AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Container();
  }

  Widget _buildNoteField() {
    return Container();
  }

  Widget _buildSaveButton() {
    return Container();
  }

  Widget _buildAuditInfo() {
    return Container();
  }
}
