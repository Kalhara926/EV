// lib/screens/all_transactions_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/transaction_tile.dart'; // Import the reusable widget

class AllTransactionsScreen extends StatelessWidget {
  const AllTransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('All Transactions')),
        body: const Center(child: Text('Please log in to see transactions.')),
      );
    }

    final transactionsCollectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('transactions');

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: transactionsCollectionRef
            .orderBy('startTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No transactions found.'));
          }

          final transactions = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final data = transactions[index].data() as Map<String, dynamic>;
              final type = data['type'] ?? 'unknown';
              final isTopUp = type == 'top_up';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: TransactionTile(
                  type: type,
                  title: isTopUp
                      ? 'Top Up'
                      : (data['stationName'] ?? 'Charging Session'),
                  date: (data['startTime'] as Timestamp).toDate(),
                  amount: isTopUp ? (data['amount'] ?? 0) : (data['cost'] ?? 0),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
