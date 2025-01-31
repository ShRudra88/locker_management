import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:locker_management/theme_data.dart';
import 'controllers/auth_controller.dart';
import 'views/admin/admin_dashboard.dart';
import 'views/admin/manage_lockers_page.dart';
import 'views/admin/manage_users_page.dart';
import 'views/admin/generate_report_page.dart';
import 'views/admin/send_notification_page.dart';
import 'views/auth/forgot_password_page.dart';
import 'views/auth/login_page.dart';
import 'views/auth/registration_page.dart';
import 'views/splash_screen.dart';
import 'views/student/my_revervation_page.dart';
import 'views/student/student_dashboard.dart';
import 'views/visitor/reserve_locker.dart';
import 'views/visitor/visitor_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      //
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegistrationPage()),
        GetPage(name: '/forgot-password', page: () => ForgotPasswordPage()),
        GetPage(name: '/admin-dashboard', page: () => const AdminDashboard()),
        GetPage(name: '/student-dashboard', page: () => const StudentDashboard()),
        GetPage(name: '/visitor-dashboard', page: () => const VisitorDashboard()),
        GetPage(name: '/manage-users', page: () => ManageUsersPage()),
        GetPage(name: '/reports', page: () => GenerateReportsPage()),
        GetPage(name: '/manage-lockers', page: () => ManageLockerPage()),
        GetPage(name: '/send-notification', page: () => const SendNotificationPage()),
        GetPage(name: '/reserve-locker', page: () => ReverseLockerPage()),
        GetPage(name: '/my-reservations', page: () => MyReservationsPage()),
      ],
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
    );
  }
}
