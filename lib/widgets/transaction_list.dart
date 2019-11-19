import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {

  final List<Transaction> userTransactions;
  final Function onDelete;

  TransactionList({@required this.userTransactions,@required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      child: userTransactions.isEmpty?
      Column(children: <Widget>[
        Text('Nothing added to list',style: Theme.of(context).textTheme.title,),
        SizedBox(height: 20.0,),
        Container(
          height: 200.0,
          child: Image.asset('assets/images/waiting.png',fit: BoxFit.cover,)
        )
      ],):
      ListView.builder(
        itemCount: userTransactions.length,
        itemBuilder: (context,index){
          return Card(
            margin: EdgeInsets.all(10.0),
            elevation: 3.0,
            child: ListTile(
              leading: CircleAvatar(
                radius: 30.0,
                child: Text(
                  "\$${userTransactions[index].price}"
                ),
              ),
              title: Text(
                userTransactions[index].title,
                style: Theme.of(context).textTheme.title,
              ),
              subtitle: Text(
                DateFormat('yyyy-MM-dd').format(userTransactions[index].date)
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: ()=> onDelete(userTransactions[index].id),
              ),
            ),
          );
        },
              
      ),
    );
  }
}

// Card(
//   elevation: 3.0,
//   child: Container(
//     padding: EdgeInsets.all(10.0),
//     child: Row(
//       children: <Widget>[
//         Container(
//           padding: EdgeInsets.all(10.0),
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: Theme.of(context).primaryColor,
//               width: 2.0
//             )
//           ),
//           child: Text(
//             "\$${userTransactions[index].price.toStringAsFixed(2)}",
//             style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),
//           ),
//         ),
//         SizedBox(width: 10,),
//         Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               "${userTransactions[index].title}",
//               style: Theme.of(context).textTheme.title,
//             ),
//             Text(DateFormat('yyyy-MM-dd').format(userTransactions[index].date))
//           ],
//         )
//       ],
//     ),
//   ),
// );