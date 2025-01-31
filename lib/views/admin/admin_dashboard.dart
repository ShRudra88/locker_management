import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'generate_report_page.dart';
import 'manage_lockers_page.dart';
import 'manage_users_page.dart';
import 'send_notification_page.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed('/login');
            },
          ),
        ],
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
                      Get.to(() => ManageLockerPage());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text('Manage Users'),
                    onTap: () {
                      Get.to(() => ManageUsersPage());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Send Notifications'),
                    onTap: () {
                      Get.to(() => SendNotificationPage());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.report),
                    title: const Text('Generate Reports'),
                    onTap: () {
                      Get.to(() => GenerateReportsPage());
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