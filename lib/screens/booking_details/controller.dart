import 'dart:convert';
import 'package:eldoriaCare/utils/const.dart';
import 'package:eldoriaCare/widget/care_desk_buttons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:eldoriaCare/data_handler/repository.dart';
import 'package:eldoriaCare/model/client_models.dart';
import 'package:eldoriaCare/utils/logger.dart';
import 'package:eldoriaCare/utils/preference.dart';
import 'package:eldoriaCare/utils/toasty.dart';

class BookingDetailController extends GetxController {
  static BookingDetailController get to => Get.find();

  static const List<String> flowSteps = [
    'requested',
    'confirmed',
    'assigned',
    'on_the_way',
    'in_progress',
    'completed',
  ];

  static const Map<String, String> flowLabels = {
    'requested': 'Request received',
    'confirmed': 'Booking confirmed',
    'assigned': 'Staff assigned',
    'on_the_way': 'Staff on the way',
    'in_progress': 'Visit in progress',
    'completed': 'Visit completed',
  };

  final Rxn<BookingItem> booking = Rxn<BookingItem>();
  final RxBool isLoading = false.obs;
  final RxBool showCancelConfirm = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments?.toString();
    if (args != null && args.isNotEmpty) {
      loadBooking(args);
    }
  }

  Future<void> loadBooking(String bookingId) async {
    isLoading.value = true;
    try {
      // 1. Try local SharedPreferences first
      final bStr = LocalDB.clientBookingsJson;
      if (bStr.isNotEmpty) {
        final List raw = jsonDecode(bStr);
        final list = raw
            .map((e) => BookingItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        final matched = list.firstWhereOrNull(
              (b) => b.id == bookingId || b.code == bookingId,
        );
        if (matched != null) {
          booking.value = matched;
        }
      }

      // 2. Fetch fresh bookings from API
      final response = await Repository.instance.getBookings();
      if (response != null && response is Map) {
        final parsed = BookingsResponse.fromJson(
          Map<String, dynamic>.from(response),
        );
        if (parsed.success && parsed.data.isNotEmpty) {
          final matched = parsed.data.firstWhereOrNull(
                (b) => b.id == bookingId || b.code == bookingId,
          );
          if (matched != null) {
            booking.value = matched;
          }
        }
      }
    } catch (e) {
      Logger.e(tag: 'Load Booking Error', value: e);
    } finally {
      isLoading.value = false;
    }
  }

  StaffItem? getStaff(String staffId) {
    return null;
  }

  Future<void> cancelBooking(String bookingId, {String? reason}) async {
    final b = booking.value;
    if (b == null) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    final updatedHistory = List<HistoryEntry>.from(b.history)
      ..add(
        HistoryEntry(
          status: 'cancelled',
          at: now,
          by: 'client',
          note: reason ?? 'Cancelled by client',
        ),
      );

    final updatedBooking = b.copyWith(
      status: 'cancelled',
      cancelReason: reason ?? 'Cancelled by client',
      history: updatedHistory,
    );

    booking.value = updatedBooking;
    showCancelConfirm.value = false;

    // Persist to SharedPreferences
    try {
      final bStr = LocalDB.clientBookingsJson;
      if (bStr.isNotEmpty) {
        final List raw = jsonDecode(bStr);
        final list = raw
            .map((e) => BookingItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        final idx = list.indexWhere(
              (x) => x.id == bookingId || x.code == bookingId,
        );
        if (idx != -1) {
          list[idx] = updatedBooking;
          await LocalDB.setClientBookingsJson(
            jsonEncode(list.map((e) => e.toJson()).toList()),
          );
        }
      }
    } catch (_) {}

    Toasty.normal('Booking cancelled');
  }

  void makePhoneCall(String? phone) {
    CareDeskButtons.launchCall(phone);
  }

  void openWhatsApp(String? phone, {String? text}) {
    CareDeskButtons.launchWhatsApp(phone, text: text);
  }

  String formatDate(String iso) {
    try {
      final parts = iso.split('-');
      if (parts.length == 3) {
        final d = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
        return DateFormat('EEE, d MMM').format(d);
      }
    } catch (_) {}
    return iso;
  }

  String formatTimeAgo(int timestamp) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final diffMin = ((now - timestamp) / 60000).round();
    if (diffMin < 1) return 'Just now';
    if (diffMin < 60) return '${diffMin}m ago';
    final diffHours = (diffMin / 60).round();
    if (diffHours < 24) return '${diffHours}h ago';
    final diffDays = (diffHours / 24).round();
    return '${diffDays}d ago';
  }

  String formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';
    if (timestamp is int) {
      final d = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateFormat('d MMM, h:mm a').format(d);
    }
    if (timestamp is String) {
      final dt = DateTime.tryParse(timestamp);
      if (dt != null) return DateFormat('d MMM, h:mm a').format(dt);
      final intMs = int.tryParse(timestamp);
      if (intMs != null) {
        return DateFormat(
          'd MMM, h:mm a',
        ).format(DateTime.fromMillisecondsSinceEpoch(intMs));
      }
      return timestamp;
    }
    return timestamp.toString();
  }

  String cityName(String cityId) {
    final c = Const.cities.firstWhereOrNull(
          (x) =>
      x.id.toLowerCase() == cityId.toLowerCase() ||
          x.name.toLowerCase() == cityId.toLowerCase(),
    );
    return c?.name ?? cityId;
  }
}
