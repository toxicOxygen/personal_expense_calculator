import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;

  ChartBar({@required this.label,@required this.spendingAmount,@required this.spendingPctOfTotal});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FittedBox(child: Text("\$${spendingAmount.toStringAsFixed(0)}")),
        SizedBox(height: 10.0,),
        Container(
          height: 60.0,
          width: 10.0,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(220, 220, 220, 1),
                  border: Border.all(width: 2.0,color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
              FractionallySizedBox(
                heightFactor: spendingPctOfTotal,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2.0,color: Theme.of(context).primaryColor),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10.0,),
        Text(label)
      ],
    );
  }
}