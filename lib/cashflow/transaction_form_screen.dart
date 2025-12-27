import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/transaction.dart';
import '../services/notification_service.dart';

class TransactionFormScreen extends StatefulWidget {
  final Transaction? transaction;
  final VoidCallback? onSuccess;

  const TransactionFormScreen({super.key, this.transaction, this.onSuccess});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  // ... (previous variables and methods)
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
    return Container();
  }
}
