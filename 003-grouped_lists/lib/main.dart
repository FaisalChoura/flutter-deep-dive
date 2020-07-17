import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

import 'models/transaction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<Transaction> transactions = [
    Transaction("Some Restaurant", 20, DateTime.utc(2020, 7, 7)),
    Transaction("Some Shop", 50, DateTime.utc(2020, 7, 7)),
    Transaction("Some Pharmacy", 8, DateTime.utc(2020, 7, 7)),
    Transaction("Other Restaurant", 32, DateTime.utc(2020, 9, 7)),
    Transaction("Some Coffee Shop", 6, DateTime.utc(2020, 9, 7)),
    Transaction("Other Restaurant", 16, DateTime.utc(2020, 14, 7)),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grouped Lists',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Grouped Lists"),
        ),
        body: GroupedListView<dynamic, DateTime>(
          elements: transactions,
          groupBy: (transaction) {
            return transaction.date;
          },
          groupSeparatorBuilder: (DateTime date) => TransactionGroupSeparator(
            date: date,
          ),
          order: GroupedListOrder.ASC,
          itemBuilder: (context, dynamic transaction) => Card(
            child: ListTile(
              title: Text(transaction.name),
              trailing: Text(
                "\$ ${transaction.amount}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionGroupSeparator extends StatelessWidget {
  final DateTime date;
  TransactionGroupSeparator({this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: Text(
          "${this.date.day}/${this.date.month}/${this.date.year}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
