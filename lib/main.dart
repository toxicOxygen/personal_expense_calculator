import 'package:flutter/material.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/chart.dart';


void main(){
  runApp(App());
}


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Personal Expense",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'OpenSans',
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(fontFamily: 'OpenSans',fontSize: 20.0,fontWeight: FontWeight.bold)
          ),
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
          title: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold)
        )
      ),
      home: HomePage(),
    );
  }
}




class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Transaction> _transactions = [
    // Transaction(id: "t1",price: 10.99,title: "Bought shoes",date: DateTime.now()),
    // Transaction(id: "t2",price: 15.99,title: "Bought eggs",date: DateTime.now()),
  ];

  List<Transaction> get _recentTransaction{
    return _transactions.where((tx){
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Expense"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startAddingNewTransaction(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Chart(recentTransactions: _recentTransaction,),
            TransactionList(userTransactions: _transactions,onDelete: _deleteTransaction,)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=> _startAddingNewTransaction(context),
      ),
    );
  } 

  _startAddingNewTransaction(BuildContext ctx){
    showModalBottomSheet(
      context: ctx,
      builder: (BuildContext context){
        return NewTransaction(onCompleted: _addNewTransaction,);
      }
    );
  }

  _addNewTransaction(String title,String price,DateTime dateTime){
    final newTx = Transaction(
      date: dateTime,
      price: double.parse(price),
      title: title,
      id: DateTime.now().toString()
    );

    setState(() {
      _transactions.add(newTx);
    });
    Navigator.of(context).pop();
  }

  _deleteTransaction(String id){
    setState(() {
      _transactions.removeWhere((tx)=> tx.id == id);
    });
  }
}