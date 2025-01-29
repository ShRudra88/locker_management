import 'package:flutter/material.dart';

class ManageUsersPage extends StatelessWidget {
  final List<Map<String, dynamic>> users = [
    {'name': 'John Doe', 'role': 'Student', 'status': 'Pending'},
    {'name': 'Jane Smith', 'role': 'Visitor', 'status': 'Approved'},
    {'name': 'Alice Johnson', 'role': 'Student', 'status': 'Declined'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Users'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'User Management',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(user['name'][0]),
                      ),
                      title: Text(user['name']),
                      subtitle: Text('Role: ${user['role']}'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          // Handle user approval/decline
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'approve',
                            child: Text('Approve'),
                          ),
                          PopupMenuItem(
                            value: 'decline',
                            child: Text('Decline'),
                          ),
                        ],
                      ),
                      tileColor: user['status'] == 'Pending'
                          ? Colors.yellow.shade100
                          : user['status'] == 'Approved'
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
