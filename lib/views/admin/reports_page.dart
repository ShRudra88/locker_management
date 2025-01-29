import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  final Map<String, int> lockerSummary = {
    'Booked Lockers': 50,
    'Available Lockers': 30,
    'Maintenance Lockers': 10,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Locker Reports',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: lockerSummary.keys.length,
                itemBuilder: (context, index) {
                  String key = lockerSummary.keys.elementAt(index);
                  int value = lockerSummary[key]!;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Icon(
                        key == 'Booked Lockers'
                            ? Icons.lock
                            : key == 'Available Lockers'
                            ? Icons.lock_open
                            : Icons.build,
                      ),
                      title: Text(key),
                      trailing: Text(
                        '$value',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
