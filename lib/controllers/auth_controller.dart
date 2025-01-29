import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  /// **Login Function**
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
        isLoading.value = false;
        Get.snackbar('Error', 'User data not found');
        return;
      }

      String role = userDoc['role'];

      isLoading.value = false;
      if (role == 'Admin') {
        Get.offNamed('/admin-dashboard');
      } else if (role == 'Student') {
        Get.offNamed('/student-dashboard');
      } else if (role == 'Visitor') {
        Get.offNamed('/visitor-dashboard');
      } else {
        Get.snackbar('Error', 'Unknown role');
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.message ?? 'Login failed');
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

    List<String> validRoles = ['Admin', 'Student', 'Visitor'];
    if (!validRoles.contains(role)) {
      Get.snackbar('Error', 'Invalid role. Choose Admin, Student, or Visitor.');
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
        'role': role,
        'approved': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      isLoading.value = false;

      Get.snackbar(
        'Success',
        'Registration Successful! Wait for admin approval.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );

      Future.delayed(const Duration(seconds: 2), () {
        Get.offNamed('/login');
      });
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.message ?? 'Registration failed');
    }
  }



  /// **Logout Function**
  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
  }

  /// **Send Password Reset OTP**
  Future<void> sendOtp(String email) async {
    if (email.isEmpty) {
      Get.snackbar('Error', 'Email cannot be empty');
      return;
    }

    isLoading.value = true;
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      isLoading.value = false;
      Get.snackbar(
        'Success',
        'Link sent to your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      Get.toNamed('/login');
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.message ?? 'Failed to send OTP');
    }
  }

}
