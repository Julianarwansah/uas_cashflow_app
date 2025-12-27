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
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
