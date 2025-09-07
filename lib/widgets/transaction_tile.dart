// lib/widgets/transaction_tile.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final String type;
  final String title;
  final DateTime date;
  final num amount;

  const TransactionTile({
    Key? key,
    required this.type,
    required this.title,
    required this.date,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isTopUp = type == 'top_up';
    final String amountText =
        '${isTopUp ? '+' : '-'} ${amount.toStringAsFixed(0)} Points';
    final Color amountColor = isTopUp ? Colors.green : Colors.red;
    final IconData iconData =
        isTopUp ? Icons.arrow_upward : Icons.arrow_downward;

    return ListTile(
      leading: Icon(iconData, color: amountColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(DateFormat('MMM d, yyyy - hh:mm a').format(date)),
      trailing: Text(
        amountText,
        style: TextStyle(
          color: amountColor,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }
}
