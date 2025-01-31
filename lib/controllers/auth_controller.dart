import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  /// **Login Function (Only Approved Users Can Login)**
  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email and Password cannot be empty');
      return;
    }

    isLoading.value = true;
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        Get.snackbar('Error', 'User data not found');
        await _auth.signOut();
        return;
      }

      bool isApproved = userDoc['approved'] ?? false;
      String role = userDoc['role'] ?? 'Unknown';

      if (!isApproved) {
        Get.snackbar('Error', 'Your account is not approved yet.');
        await _auth.signOut();
        return;
      }

      switch (role) {
        case 'Admin':
          Get.offNamed('/admin-dashboard');
          break;
        case 'Student':
          Get.offNamed('/student-dashboard');
          break;
        case 'Visitor':
          Get.offNamed('/visitor-dashboard');
          break;
        default:
          Get.snackbar('Error', 'Unknown role');
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Login failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(
      String email, String password, String confirmPassword, String role) async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || role.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    // Convert role to lowercase for case-insensitive comparison
    role = role.trim().toLowerCase();

    if (!['admin', 'student', 'visitor'].contains(role)) {
      Get.snackbar('Error', 'Invalid role selected.');
      return;
    }

    isLoading.value = true;
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email.trim(),
        'role': role.capitalizeFirst, // Store role with proper capitalization
        'approved': false, // Default: Not approved
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Success',
        'Registration Successful! Wait for approval.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );

      // ✅ Redirect to login page after successful registration
      Future.delayed(const Duration(seconds: 2), () {
        Get.offNamed('/login');
      });

    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Registration failed');
      // ❌ Do not navigate away from the registration page if an error occurs
    } finally {
      isLoading.value = false;
    }
  }

  /// **Admin: Approve a User (Only Admin Can Approve)**
  Future<void> approveUser(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'approved': true,
    });

    Get.snackbar('Success', 'User approved successfully', backgroundColor: Colors.green, colorText: Colors.white);
  }

  /// **Admin: Reject a User**
  Future<void> rejectUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
    Get.snackbar('Success', 'User rejected and deleted successfully', backgroundColor: Colors.red, colorText: Colors.white);
  }

  /// **Developer Only: Approve an Admin (Done Manually in Firestore)**
  Future<void> approveAdmin(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'approved': true,
    });

    Get.snackbar('Success', 'Admin approved successfully', backgroundColor: Colors.blue, colorText: Colors.white);
  }

  /// **Admin Only: Promote a User to Admin**
  Future<void> makeAdmin(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'role': 'Admin',
      'approved': false, // Even promoted Admins need developer approval
    });

    Get.snackbar('Success', 'User promoted to Admin (Pending Approval)', backgroundColor: Colors.orange, colorText: Colors.white);
  }

  /// **Logout Function**
  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
  }

  /// **Send Password Reset Email**
  Future<void> sendOtp(String email) async {
    if (email.isEmpty) {
      Get.snackbar('Error', 'Email cannot be empty');
      return;
    }

    isLoading.value = true;
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      Get.snackbar(
        'Success',
        'Password reset link sent to your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      Get.toNamed('/login');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Failed to send OTP');
    } finally {
      isLoading.value = false;
    }
  }
}
