import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportsPage extends StatelessWidget {
  final List<Map<String, dynamic>> reportData = [
    {'lockerId': 'L101', 'status': 'Booked'},
    {'lockerId': 'L202', 'status': 'Available'},
    {'lockerId': 'L303', 'status': 'Under Maintenance'},
    {'lockerId': 'L404', 'status': 'Booked'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generate Reports')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Locker Reports',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: reportData.length,
                itemBuilder: (context, index) {
                  final report = reportData[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Icon(
                        report['status'] == 'Booked'
                            ? Icons.lock
                            : report['status'] == 'Available'
                            ? Icons.lock_open
                            : Icons.build,
                        color: report['status'] == 'Booked'
                            ? Colors.red
                            : report['status'] == 'Available'
                            ? Colors.green
                            : Colors.orange,
                      ),
                      title: Text('Locker ID: ${report['lockerId']}'),
                      subtitle: Text('Status: ${report['status']}'),
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
