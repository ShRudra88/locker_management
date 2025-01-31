import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReverseLockerPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> returnLocker(String lockerId) async {
    try {
      await _firestore.collection('lockers').doc(lockerId).update({
        'status': 'available',
        'reservedBy': null,
        'reservedUntil': null,
        'userName': null,
      });

      Get.snackbar('Success', 'Locker $lockerId returned successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to return locker: $e');
    }
  }

  Widget buildLockerList(String lockerType) {
    return StreamBuilder(
      stream: _firestore.collection('lockers').where('type', isEqualTo: lockerType).where('status', isEqualTo: 'reserved').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var lockers = snapshot.data!.docs;

        if (lockers.isEmpty) {
          return const Center(child: Text('No active lockers.'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: lockers.length,
          itemBuilder: (context, index) {
            var locker = lockers[index];
            String lockerId = locker.id;
            String userName = locker['userName'] ?? 'Unknown';
            String duration = locker['reservedUntil'] ?? 'Unknown';

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: const Icon(Icons.lock_open, color: Colors.blue, size: 30),
                title: Text('Locker ID: $lockerId', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('User: $userName\nExpires on: $duration'),
                trailing: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Confirm Return'),
                          content: Text('Are you sure you want to return Locker $lockerId?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                returnLocker(lockerId);
                              },
                              child: const Text('Confirm'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Return'),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reverse Locker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Student Lockers', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            buildLockerList('student'),
            const SizedBox(height: 20),
            const Text('Visitor Lockers', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            buildLockerList('visitor'),
          ],
        ),
      ),
    );
  }
}
