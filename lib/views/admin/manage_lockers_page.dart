import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageLockerPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addLocker() {
    TextEditingController lockerIdController = TextEditingController();
    String status = 'Available';

    Get.defaultDialog(
      title: "Add New Locker",
      content: Column(
        children: [
          TextField(
            controller: lockerIdController,
            decoration: const InputDecoration(labelText: "Locker ID"),
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: status,
            items: ['Available', 'Booked', 'Under Maintenance']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {
              status = value!;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (lockerIdController.text.isNotEmpty) {
                await _firestore.collection('lockers').add({
                  'id': lockerIdController.text.trim(),
                  'status': status,
                });
                Get.back();
              }
            },
            child: const Text("Add Locker"),
          ),
        ],
      ),
    );
  }

  void _updateLocker(String docId, String currentId, String currentStatus) {
    TextEditingController lockerIdController = TextEditingController(text: currentId);
    String status = currentStatus;

    Get.defaultDialog(
      title: "Update Locker",
      content: Column(
        children: [
          TextField(
            controller: lockerIdController,
            decoration: const InputDecoration(labelText: "Locker ID"),
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: status,
            items: ['Available', 'Booked', 'Under Maintenance']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {
              status = value!;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await _firestore.collection('lockers').doc(docId).update({
                'id': lockerIdController.text.trim(),
                'status': status,
              });
              Get.back();
            },
            child: const Text("Update Locker"),
          ),
        ],
      ),
    );
  }

  void _deleteLocker(String docId) {
    Get.defaultDialog(
      title: "Delete Locker?",
      content: const Text("Are you sure you want to delete this locker?"),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            await _firestore.collection('lockers').doc(docId).delete();
            Get.back();
          },
          child: const Text("Delete"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Lockers')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addLocker,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('lockers').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No lockers found.'));
          }

          var lockers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: lockers.length,
            itemBuilder: (context, index) {
              var locker = lockers[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
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
                  title: Text('Locker ID: ${locker['id']}'),
                  subtitle: Text('Status: ${locker['status']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _updateLocker(
                          locker.id,
                          locker['id'],
                          locker['status'],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteLocker(locker.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
