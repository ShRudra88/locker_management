import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageUsersPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   ManageUsersPage({super.key});

  Future<void> approveUser(String userId) async {
    await _firestore.collection('users').doc(userId).update({'approved': true});
    Get.snackbar('Success', 'User approved');
  }

  Future<void> removeUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
    Get.snackbar('Success', 'User removed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Users')),
      body: StreamBuilder(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return ListTile(
                title: Text(user['email']),
                subtitle: Text(user['role']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!user['approved'])
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () => approveUser(user.id),
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removeUser(user.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}