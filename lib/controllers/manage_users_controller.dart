import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ManageUsersController extends GetxController {
  var usersList = <Map<String, dynamic>>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      usersList.value = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'email': doc['email'],
          'role': doc['role'],
          'approved': doc['approved'] ?? false,
        };
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch users');
    }
  }

  Future<void> approveUser(String userId) async {
    await _firestore.collection('users').doc(userId).update({'approved': true});
    fetchUsers();
    Get.snackbar('Success', 'User approved');
  }

  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
    fetchUsers();
    Get.snackbar('Success', 'User deleted');
  }
}
