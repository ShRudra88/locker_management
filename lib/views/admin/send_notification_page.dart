import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SendNotificationPage extends StatefulWidget {
  const SendNotificationPage({super.key});

  @override
  _SendNotificationPageState createState() => _SendNotificationPageState();
}

class _SendNotificationPageState extends State<SendNotificationPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendNotification() async {
    String title = titleController.text.trim();
    String message = messageController.text.trim();

    if (title.isEmpty || message.isEmpty) {
      Get.snackbar("Error", "Title and Message cannot be empty!",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('role', whereIn: ['Student', 'Visitor'])
        .get();

    List<String> tokens = snapshot.docs
        .map((doc) => doc['fcmToken'] as String)
        .where((token) => token.isNotEmpty)
        .toList();

    if (tokens.isEmpty) {
      Get.snackbar("Error", "No students or visitors found!",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    await sendFCMNotification(tokens, title, message);

    Get.snackbar("Success", "Notification Sent!",
        snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> sendFCMNotification(
      List<String> tokens, String title, String message) async {
    const String serverKey =
        'SERVER_KEY'; // need to update
    const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode({
        'registration_ids': tokens,
        'notification': {
          'title': title,
          'body': message,
        },
        'priority': 'high',
      }),
    );

    if (response.statusCode != 200) {
      Get.snackbar("Error", "Failed to send notification",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Send Notification")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(labelText: "Message"),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendNotification,
              child: const Text("Send Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
