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
}
