import 'package:expenses/components/Transaction_form.dart';
import 'package:expenses/components/chart.dart';
import 'package:flutter/material.dart';
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

    final List<Transaction> _transactions = [
    Transaction(
      id: 't1',
      title: 'Novo Tênis de Corrida',
      value: 310.76,
      date: DateTime.now().subtract(Duration(days: 3))),
    Transaction(
      id: 't2',
      title: 'Conta de Luz',
      value: 211.30,
      date: DateTime.now().subtract(Duration(days: 5))),
   ];

   List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7)
      ));
    }).toList();
   }

    _addTransaction(String title, double value) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: DateTime.now(),
    );

    setState(() {
        _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
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
    return Scaffold(
      appBar: AppBar( 
        title: Text("Despesas Pessoais"),
        backgroundColor: Colors.indigo,
        actions: <Widget> [
          IconButton(
            onPressed: () => _openTransactionFormModal(context),
            icon: Icon(Icons.add_circle_sharp))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Chart(_recentTransactions),
            TransactionList(_transactions)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        child: Icon(Icons.add_circle_rounded),
        onPressed: () => _openTransactionFormModal(context)),
    );
  }
}