import 'package:Expenses/widgets/chart_bar.dart';

import '../models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.00;

      for (var i = 0; i < recentTransactions.length; i++) {
        DateTime tDate = recentTransactions[i].date;
        if (tDate.day == weekDay.day &&
            tDate.month == weekDay.month &&
            tDate.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.00, (sum, element) {
      return sum + element['amount'];
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
          children: groupedTransactionValues.map((tx) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  label: tx['day'],
                  spendingAmount: tx['amount'],
                  spendingPctOfTotal: totalSpending == 0.00
                      ? 0.00
                      : (tx['amount'] as double) / totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
