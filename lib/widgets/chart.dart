import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart({this.recentTransactions});

  List<Map<String,Object>> get groupedTransaction {
    return List.generate(7, (index){
      final weekday = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;

      for(int i = 0; i < recentTransactions.length; i++){
        if(weekday.day == recentTransactions[i].date.day &&
          weekday.month == recentTransactions[i].date.month &&
          weekday.year == recentTransactions[i].date.year
        ){
          totalSum += recentTransactions[i].price;
        }
      }

      return {
        'day':DateFormat.E().format(weekday),
        'amount':totalSum
      };
    });
  }

  double get totalSum{
    return groupedTransaction.fold(0.0, (sum,item){
      return sum + item["amount"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupedTransaction.map((tx){
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: tx["day"],
                spendingAmount: tx["amount"],
                spendingPctOfTotal: totalSum <= 0 ? 0.0 : (tx["amount"] as double)/totalSum,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}