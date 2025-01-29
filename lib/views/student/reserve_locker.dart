import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReserveLockerPage extends StatelessWidget {
  final List<Map<String, dynamic>> lockers = [
    {'id': 'L1', 'size': 'Medium', 'location': 'Hall A', 'available': true},
    {'id': 'L2', 'size': 'Large', 'location': 'Hall B', 'available': false},
    {'id': 'L3', 'size': 'Small', 'location': 'Hall C', 'available': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reserve a Locker')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: lockers.length,
          itemBuilder: (context, index) {
            var locker = lockers[index];
            return Card(
              child: ListTile(
                title: Text('Locker ${locker['id']}'),
                subtitle: Text('Size: ${locker['size']} - Location: ${locker['location']}'),
                trailing: locker['available']
                    ? ElevatedButton(
                  onPressed: () {
                    Get.snackbar('Success', 'Locker ${locker['id']} reserved!');
                  },
                  child: Text('Reserve'),
                )
                    : Icon(Icons.lock, color: Colors.red),
              ),
            );
          },
        ),
      ),
    );
  }
}
