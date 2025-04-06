import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Ініціалізація Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExpenseList(),
    );
  }
}

class ExpenseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expense Tracker')),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('expenses').get(),  // Отримання витрат з Firestore
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }
          final expenses = snapshot.data!.docs;
          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              final amount = expense['amount'];
              final category = expense['category'];
              final date = expense['date'].toDate();
              return ListTile(
                title: Text('$category: \$${amount.toString()}'),
                subtitle: Text('Date: ${date.toLocal()}'),
              );
            },
          );
        },
      ),
    );
  }
}

