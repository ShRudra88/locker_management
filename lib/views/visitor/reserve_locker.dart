import 'package:flutter/material.dart';

class ReverseLockerPage extends StatelessWidget {
  final List<Map<String, dynamic>> activeLockers = [
    {'lockerId': 'L101', 'user': 'John Doe', 'duration': '6 months'},
    {'lockerId': 'L202', 'user': 'Jane Smith', 'duration': '3 months'},
    {'lockerId': 'L303', 'user': 'Alice Johnson', 'duration': '1 year'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reverse Locker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Lockers',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: activeLockers.length,
                itemBuilder: (context, index) {
                  final locker = activeLockers[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.lock_open,
                        color: Colors.blue,
                        size: 30,
                      ),
                      title: Text(
                        'Locker ID: ${locker['lockerId']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'User: ${locker['user']}\nDuration: ${locker['duration']}',
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Add functionality to reverse locker here
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Confirm Return'),
                                content: Text(
                                    'Are you sure you want to return Locker ${locker['lockerId']}?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      // Logic to reverse locker goes here
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'Locker ${locker['lockerId']} returned successfully!'),
                                      ));
                                    },
                                    child: Text('Confirm'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Return'),
                      ),
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
