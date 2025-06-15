import 'package:get/get.dart';
import '../models/event.dart';
import '../models/booking.dart';
import '../services/database_service.dart';
import 'user_controller.dart';

class BookingController extends GetxController {
  static BookingController get to => Get.find();

  final DatabaseService _dbService = Get.find<DatabaseService>();
  final UserController _userController = Get.find<UserController>();

  final RxBool isLoading = true.obs;
  final RxList<Event> bookedEvents = <Event>[].obs;

  @override
  void onInit() {
    super.onInit();
    // When the user logs in, fetch their bookings.
    ever(_userController.user, (user) {
      if (user != null) {
        fetchUserBookings(user.id);
      } else {
        bookedEvents.clear();
      }
    });
  }

  Future<void> fetchUserBookings(String userId) async {
    isLoading.value = true;
    final stream = _dbService.getUserBookingsStream(userId);
    bookedEvents.bindStream(stream);
    ever(bookedEvents, (_) => isLoading.value = false);
  }
}
