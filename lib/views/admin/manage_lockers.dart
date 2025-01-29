import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageLockerPage extends StatefulWidget {
  @override
  _ManageLockerPageState createState() => _ManageLockerPageState();
}

class _ManageLockerPageState extends State<ManageLockerPage> {
  final List<Map<String, dynamic>> lockers = [
    {'id': 'L101', 'status': 'Available'},
    {'id': 'L202', 'status': 'Booked'},
    {'id': 'L303', 'status': 'Under Maintenance'},
  ];

  void _addLocker() {
    TextEditingController lockerIdController = TextEditingController();
    String status = 'Available';

    Get.defaultDialog(
      title: "Add New Locker",
      content: Column(
        children: [
          TextField(
            controller: lockerIdController,
            decoration: InputDecoration(labelText: "Locker ID"),
          ),
          SizedBox(height: 10),
          DropdownButton<String>(
            value: status,
            items: ['Available', 'Booked', 'Under Maintenance']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {
              setState(() {
                status = value!;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (lockerIdController.text.isNotEmpty) {
                setState(() {
                  lockers.add({
                    'id': lockerIdController.text.trim(),
                    'status': status,
                  });
                });
                Get.back();
              }
            },
            child: Text("Add Locker"),
          ),
        ],
      ),
    );
  }

  void _updateLocker(int index) {
    TextEditingController lockerIdController =
    TextEditingController(text: lockers[index]['id']);
    String status = lockers[index]['status'];

    Get.defaultDialog(
      title: "Update Locker",
      content: Column(
        children: [
          TextField(
            controller: lockerIdController,
            decoration: InputDecoration(labelText: "Locker ID"),
          ),
          SizedBox(height: 10),
          DropdownButton<String>(
            value: status,
            items: ['Available', 'Booked', 'Under Maintenance']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {
              setState(() {
                status = value!;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                lockers[index]['id'] = lockerIdController.text.trim();
                lockers[index]['status'] = status;
              });
              Get.back();
            },
            child: Text("Update Locker"),
          ),
        ],
      ),
    );
  }

  void _deleteLocker(int index) {
    Get.defaultDialog(
      title: "Delete Locker?",
      content: Text("Are you sure you want to delete this locker?"),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              lockers.removeAt(index);
            });
            Get.back();
          },
          child: Text("Delete"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Lockers')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addLocker,
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: lockers.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(
                  lockers[index]['status'] == 'Booked'
                      ? Icons.lock
                      : lockers[index]['status'] == 'Available'
                      ? Icons.lock_open
                      : Icons.build,
                  color: lockers[index]['status'] == 'Booked'
                      ? Colors.red
                      : lockers[index]['status'] == 'Available'
                      ? Colors.green
                      : Colors.orange,
                ),
                title: Text('Locker ID: ${lockers[index]['id']}'),
                subtitle: Text('Status: ${lockers[index]['status']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _updateLocker(index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteLocker(index),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
