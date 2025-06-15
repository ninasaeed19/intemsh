import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// --- Import Services & Controllers ---
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'services/paymentservice.dart';
import 'controllers/role_controller.dart';
import 'controllers/user_controller.dart';
import 'controllers/event_controller.dart';
import 'controllers/booking_controller.dart';
import 'controllers/theme_controller.dart';


// --- Import All Screens ---
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/users/home_screen.dart';
import 'screens/users/event_detail_screen.dart';
import 'screens/users/profile_screen.dart';
import 'screens/users/my_booking_screen.dart';
import 'screens/users/edit_profile_screen.dart';
import 'screens/users/settings.dart';
import 'screens/users/tickets_screen.dart';
import 'screens/payment/payment_screen.dart';
import 'screens/payment/payment_succes_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/admin/manage_event_screen.dart';
import 'screens/admin/create_event_screen.dart';
import 'screens/admin/admin_profilescreen.dart';
import 'screens/admin/user_management.dart';


class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.pink,
    primaryColor: const Color(0xFFE91E63),
    scaffoldBackgroundColor: const Color(0xFFFCE4EC),
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFE91E63),
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.pink,
    primaryColor: const Color(0xFFE91E63),
    scaffoldBackgroundColor: const Color(0xFF121212),
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F1F1F),
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    ),
  );
}


// This function initializes all our GetX services before the app runs.
Future<void> initServices() async {
  Get.put<AuthService>(AuthService(), permanent: true);
  Get.put<DatabaseService>(DatabaseService(), permanent: true);
  Get.put<PaymentService>(PaymentService(), permanent: true);
  // Get.put<StorageService>(StorageService(), permanent: true); // REMOVED
  Get.put<RoleController>(RoleController(), permanent: true);
  Get.put<UserController>(UserController(), permanent: true);
  Get.put<EventController>(EventController(), permanent: true);
  Get.put<BookingController>(BookingController(), permanent: true);
  Get.put<ThemeController>(ThemeController(), permanent: true);
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
    final ThemeController themeController = Get.find<ThemeController>();

    return GetMaterialApp(
      title: 'University Events',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeController.themeMode.value,
      initialRoute: '/login',
      getPages: [
        // Auth
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),

        // User
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/event_detail', page: () => const EventDetailScreen()),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
        GetPage(name: '/my_bookings', page: () => MyBookingsScreen()),
        GetPage(name: '/edit_profile', page: () => const EditProfileScreen()),
        GetPage(name: '/settings', page: () => const SettingsScreen()),
        GetPage(name: '/ticket', page: () => const TicketScreen()),

        // Payment
        GetPage(name: '/payment', page: () => const PaymentScreen()),
        GetPage(name: '/payment_success', page: () => const PaymentSuccessScreen()),

        // Admin
        GetPage(name: '/admin/dashboard', page: () => const AdminDashboardScreen()),
        GetPage(name: '/admin/manage_events', page: () => const ManageEventsScreen()),
        GetPage(name: '/admin/create_event', page: () => const CreateEventScreen()),
        GetPage(name: '/admin/profile', page: () => const AdminProfileScreen()),
        GetPage(name: '/admin/manage_users', page: () => const UserManagementScreen()),
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
