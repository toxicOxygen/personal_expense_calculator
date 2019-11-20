import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/chart.dart';


void main(){
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown
  // ]);
  runApp(App());
}


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // if(Platform.isIOS){
    //   return CupertinoApp(
    //     title: 'Personal Expenses',
    //     debugShowCheckedModeBanner: false,
    //     theme: CupertinoThemeData(
          
    //     ),
    //     home: HomePage(),
    //   );
    // }
    return MaterialApp(
      title: "Personal Expenses",
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

  bool _showCart = false;

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
    
    final isLandScape = MediaQuery.of(context).orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = Platform.isIOS ?
    CupertinoNavigationBar(
      middle: Text('Personal Expenses'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: () => _startAddingNewTransaction(context),
            child: Icon(CupertinoIcons.add),
          )
        ],
      ),
    ):
    AppBar(
      title: Text("Personal Expenses"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddingNewTransaction(context),
        )
      ],
    );

    final deviceHeight = (
      MediaQuery.of(context).size.height - 
      MediaQuery.of(context).padding.top - 
      appBar.preferredSize.height
    );

    final txList = Container(
      height: deviceHeight*0.7,
      child: TransactionList(userTransactions: _transactions,onDelete: _deleteTransaction,)
    );

    final chart = Container(
      height: isLandScape? deviceHeight*0.6: deviceHeight*0.3,
      child: Chart(recentTransactions: _recentTransaction,)
    );

    final pageBody = Column(
      children: <Widget>[
        if(isLandScape) Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("show chart"),
            Switch.adaptive(
              value: _showCart,
              onChanged: (val) => setState((){ _showCart = val; }),
            )
          ],
        ),

        if(isLandScape) _showCart ? chart : txList,
        if(!isLandScape) chart,
        if(!isLandScape) txList
        
      ],
    );

    //for IOS view
    if(Platform.isIOS){
      return CupertinoPageScaffold(
        child: pageBody,
        navigationBar: appBar,
      );
    }

    return Scaffold(
      appBar: appBar,
      body: pageBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS ? 
      Container():
      FloatingActionButton(
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