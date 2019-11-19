import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {

  final Function onCompleted;

  NewTransaction({@required this.onCompleted});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final priceController = TextEditingController();

  final titleController = TextEditingController();
  DateTime _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
              onSubmitted: (_) => _handleDataAddition(),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _handleDataAddition(),
            ),
            Container(
              height: 70.0,
              child: Row(
                children: <Widget>[
                  Text(_selectedDate == null ? 'No date selected' : DateFormat.yMd().format(_selectedDate)),
                  FlatButton(
                    onPressed: _presentDatePicker,
                    textColor: Theme.of(context).primaryColor,
                    child: Text('Select date'),
                  )
                ],
              ),
            ),
            RaisedButton(
              child: Text('Add Transaction'),
              onPressed: _handleDataAddition,
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).buttonColor,
            )
          ],
        ),
      ),
    );
  }

  _handleDataAddition(){
    final price = priceController.text;
    final title = titleController.text;

    if(price.isEmpty)
      return;

    if(double.parse(price) < 1 || title.isEmpty || _selectedDate == null)
      return;

    widget.onCompleted(title,price,_selectedDate);
  }

  _presentDatePicker(){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now()
    ).then((pd){
      if(pd == null)
        return;
      setState(() {
        _selectedDate = pd;
      });
    });
  }
}