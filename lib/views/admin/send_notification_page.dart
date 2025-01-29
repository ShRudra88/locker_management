import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendNotificationPage extends StatefulWidget {
  const SendNotificationPage({super.key});

  @override
  _SendNotificationPageState createState() => _SendNotificationPageState();
}

class _SendNotificationPageState extends State<SendNotificationPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  void sendNotification() async {
    String title = titleController.text.trim();
    String message = messageController.text.trim();

    if (title.isEmpty || message.isEmpty) {
      Get.snackbar("Error", "Title and Message cannot be empty!",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    Get.snackbar("Success", "Notification Sent!",
        snackPosition: SnackPosition.BOTTOM);
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
