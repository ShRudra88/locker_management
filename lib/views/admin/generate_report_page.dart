import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GenerateReportsPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  GenerateReportsPage({super.key});

  Future<Map<String, dynamic>> fetchLockerReports() async {
    QuerySnapshot snapshot = await _firestore.collection('lockers').get();
    List<Map<String, dynamic>> lockers =
    snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    int availableCount =
        lockers.where((locker) => locker['status'] == 'Available').length;
    int bookedCount =
        lockers.where((locker) => locker['status'] == 'Booked').length;
    int maintenanceCount =
        lockers.where((locker) => locker['status'] == 'Under Maintenance').length;

    return {
      'Available': availableCount,
      'Booked': bookedCount,
      'Under Maintenance': maintenanceCount,
      'Lockers': lockers,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Locker Reports')),
      body: FutureBuilder(
        future: fetchLockerReports(),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var reportData = snapshot.data!;
          var lockers = reportData['Lockers'] as List<Map<String, dynamic>>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Colors.blue.shade100,
                  child: ListTile(
                    title: const Text("Available Lockers"),
                    trailing: Text(reportData['Available'].toString(),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                Card(
                  color: Colors.red.shade100,
                  child: ListTile(
                    title: const Text("Booked Lockers"),
                    trailing: Text(reportData['Booked'].toString(),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                Card(
                  color: Colors.orange.shade100,
                  child: ListTile(
                    title: const Text("Under Maintenance"),
                    trailing: Text(reportData['Under Maintenance'].toString(),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: lockers.length,
                    itemBuilder: (context, index) {
                      var locker = lockers[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text('Locker ID: ${locker['id']}'),
                          subtitle: Text('Status: ${locker['status']}'),
                          leading: Icon(
                            locker['status'] == 'Booked'
                                ? Icons.lock
                                : locker['status'] == 'Available'
                                ? Icons.lock_open
                                : Icons.build,
                            color: locker['status'] == 'Booked'
                                ? Colors.red
                                : locker['status'] == 'Available'
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
