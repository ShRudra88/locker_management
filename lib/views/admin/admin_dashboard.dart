import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Admin!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text('Manage Lockers'),
                    onTap: () {
                      Get.toNamed('/manage-lockers');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text('Manage Users'),
                    onTap: () {
                      Get.toNamed('/manage-users');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Send Notifications'),
                    onTap: () {
                      Get.toNamed('/send-notification');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.report),
                    title: const Text('Generate Reports'),
                    onTap: () {
                      Get.toNamed('/reports');
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
