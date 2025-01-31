import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyReservationsPage extends StatelessWidget {
  final List<Map<String, String>> reservations = [
    {'id': 'L1', 'size': 'Medium', 'location': 'Hall A', 'expires': 'Oct 30, 2024'},
    {'id': 'L3', 'size': 'Small', 'location': 'Hall C', 'expires': 'Nov 5, 2024'},
  ];

   MyReservationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Reservations')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            var locker = reservations[index];
            return Card(
              child: ListTile(
                title: Text('Locker ${locker['id']}'),
                subtitle: Text(
                    'Size: ${locker['size']} - Location: ${locker['location']} \nExpires: ${locker['expires']}'),
                trailing: ElevatedButton(
                  onPressed: () {
                    Get.snackbar('Cancelled', 'Locker ${locker['id']} reservation cancelled!');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Cancel'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
