import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// --- Import Services & Controllers ---
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'controllers/role_controller.dart';
import 'controllers/user_controller.dart';
import 'controllers/event_controller.dart'; // Import the EventController

// --- Import All Screens ---
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/users/home_screen.dart';
import 'screens/users/event_detail_screen.dart';
import 'screens/users/profile_screen.dart';
import 'screens/users/my_booking_screen.dart';
import 'screens/users/edit_profile_screen.dart';
import 'screens/users/settings.dart';
import 'screens/payment/payment_screen.dart';
import 'screens/payment/payment_succes_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/admin/manage_event_screen.dart';
import 'screens/admin/create_event_screen.dart';
import 'screens/admin/view_attendees_screen.dart';


// This function initializes all our GetX services before the app runs.
Future<void> initServices() async {
  print("Initializing services...");
  Get.put<AuthService>(AuthService(), permanent: true);
  Get.put<DatabaseService>(DatabaseService(), permanent: true);
  Get.put<RoleController>(RoleController(), permanent: true);
  Get.put<UserController>(UserController(), permanent: true);

  // **THE FIX IS HERE**: This line initializes the EventController.
  Get.put<EventController>(EventController(), permanent: true);

  print("Services initialized!");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'University Events',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: const Color(0xFFE91E63),
        scaffoldBackgroundColor: const Color(0xFFFCE4EC),
      ),
      initialRoute: '/login',
      getPages: [
        // ... (all your GetPage routes are correct and don't need to be changed)
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/event_detail', page: () => const EventDetailScreen()),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
        GetPage(name: '/my_bookings', page: () => const MyBookingsScreen()),
        GetPage(name: '/edit_profile', page: () => const EditProfileScreen()),
        GetPage(name: '/settings', page: () => const SettingsScreen()),
        GetPage(name: '/payment', page: () => const PaymentScreen()),
        GetPage(name: '/payment_success', page: () => const PaymentSuccessScreen()),
        GetPage(name: '/admin/dashboard', page: () => const AdminDashboardScreen()),
        GetPage(name: '/admin/manage_events', page: () => const ManageEventsScreen()),
        GetPage(name: '/admin/create_event', page: () => const CreateEventScreen()),
        GetPage(name: '/admin/view_attendees', page: () => const ViewAttendeesScreen()),
      ],
      unknownRoute: GetPage(name: '/notfound', page: () => const NotFoundScreen()),
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('404', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
            const Text('Page Not Found', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.offAllNamed('/login'),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
