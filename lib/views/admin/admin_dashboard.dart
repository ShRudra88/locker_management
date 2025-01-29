import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Admin!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Manage Lockers'),
                    onTap: () {
                      // Navigate to manage lockers page
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text('Manage Users'),
                    onTap: () {
                      // Navigate to manage users page
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('Send Notifications'),
                    onTap: () {
                      // Navigate to notifications page
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.report),
                    title: Text('Generate Reports'),
                    onTap: () {
                      // Navigate to reports page
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
