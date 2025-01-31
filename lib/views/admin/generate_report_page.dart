import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GenerateReportsPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   GenerateReportsPage({super.key});

  Future<List<Map<String, dynamic>>> fetchReports() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generate Reports')),
      body: FutureBuilder(
        future: fetchReports(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return ListTile(
                title: Text(user['email']),
                subtitle: Text(user['role']),
                trailing: Text(user['approved'] ? 'Approved' : 'Pending'),
              );
            },
          );
        },
      ),
    );
  }
}