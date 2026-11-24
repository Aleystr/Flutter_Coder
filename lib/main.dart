import 'package:expenses/components/Transaction_form.dart';
import 'package:expenses/components/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'components/transaction_list.dart';
import 'models/transaction.dart';



main() => runApp(const ExpensesApp());

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Redaction50',
        textTheme: ThemeData.light().textTheme.copyWith(
          titleLarge: const TextStyle(
            fontSize: 18,
          ),
          labelLarge: TextStyle(
            color: Colors.white,
          )
        ),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.redAccent
          ).copyWith(
            secondary: Colors.deepPurpleAccent,
        ) 
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

    final List<Transaction> _transactions = [];
    bool _showChart = false;
   List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7)
      ));
    }).toList();
   }

    _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
        _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) {
        return tr.id == id;
      });
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_)  {
        return TransactionForm(_addTransaction);
      }
    );
  }


  @override
  Widget build(BuildContext context) {
  
  bool isLandScape = MediaQuery.of(context).orientation == Orientation.landscape;
  
  final appBar = AppBar( 
        title: Text(
          "Despesas Pessoais",
          style: TextStyle(
          ),
        ),
        backgroundColor: Colors.indigo,
        actions: <Widget> [
          if (isLandScape)
            IconButton(
              icon: Icon(_showChart ? Icons.list : Icons.pie_chart),
              onPressed: () {
                setState(() {
                  _showChart = !_showChart;
                });
              },
            ),
          IconButton(
            onPressed: () => _openTransactionFormModal(context),
            icon: Icon(Icons.add_circle_sharp)
          ),
        ],
      );
 
    final avaibleHeight = MediaQuery.of(context)
    .size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top;
    
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if(isLandScape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                Text('Exibir gráfico'),
                Switch(
                  value: _showChart, 
                  onChanged: (value) {
                    setState(() {
                      _showChart = value;
                    });
                  },
                ),
              ],
            ),
            if (_showChart || !isLandScape)
              Container(
              height: avaibleHeight * (isLandScape ? 0.7 : 0.3),
              child: Chart(_recentTransactions),
            ),
            if(!_showChart || !isLandScape)
              Container(
              height: avaibleHeight * 0.7,
              child: TransactionList(_transactions, _removeTransaction),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        child: Icon(Icons.add_circle_rounded),
        onPressed: () => _openTransactionFormModal(context)),
    );
  }
}