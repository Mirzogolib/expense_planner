import 'package:expense_planner/widgets/chart_bar.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupTransactionValues {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;
      for (int i = 0; i < recentTransactions.length; i++) {
        final Transaction currentTransaction = recentTransactions[i];
        if (currentTransaction.date.day == weekday.day &&
            currentTransaction.date.month == weekday.month &&
            currentTransaction.date.year == weekday.year) {
          totalSum += currentTransaction.amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get maxSpending {
    return groupTransactionValues.fold(0.0, (previousValue, element) {
      return previousValue + element['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupTransactionValues.map(
            (element) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    element['day'],
                    element['amount'],
                    maxSpending == 0.0
                        ? 0.0
                        : (element['amount'] as double) / maxSpending),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
