// import 'dart:io';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:eldoriaCare/model/local_notification.dart';
// import 'package:eldoriaCare/utils/db/db.dart';
// import 'package:eldoriaCare/utils/helper.dart';
// import 'package:eldoriaCare/utils/logger.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class NotifHelper {
//   static final FlutterLocalNotificationsPlugin localNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   static Future<void> init() async {
//     await NotificationDbHelper().database;
//     await _initializeLocalNotifications();
//     await _requestNotificationPermission();
//
//     // FCM Handlers
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//     FirebaseMessaging.onMessage.listen((message) {
//       Logger.m(tag: '📩 Foreground Message', value: message.data);
//       _showLocalNotification(message);
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       _handleNotificationClick(message);
//     });
//
//     FirebaseMessaging.instance.getInitialMessage().then((message) {
//       if (message != null) _handleNotificationClick(message);
//     });
//
//     // Print token
//     String? token = await FirebaseMessaging.instance.getToken();
//     Logger.m(tag: '🔑 FCM Token', value: token);
//
//     // Optional: subscribe to topic
//     await FirebaseMessaging.instance.subscribeToTopic('Mindir_topic');
//
//     await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//   }
//
//   static Future<String?> getFcmToken() async {
//     try {
//       return await FirebaseMessaging.instance.getToken();
//     } catch (e) {
//       Logger.m(tag: 'FCM Token Error', value: e.toString());
//       return null;
//     }
//   }
//
//   static Future<void> _initializeLocalNotifications() async {
//     const AndroidInitializationSettings androidInitSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings initSettings = InitializationSettings(
//       android: androidInitSettings,
//     );
//
//     await localNotificationsPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (response) {
//         Logger.m(tag: '🔔 Notification Clicked', value: response.payload);
//       },
//     );
//
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'default_channel',
//       'Default Notifications',
//       description: 'Used for all regular notifications',
//       importance: Importance.high,
//     );
//
//     await localNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(channel);
//   }
//
//   static Future<void> _requestNotificationPermission() async {
//     if (Platform.isAndroid) {
//       var status = await Permission.notification.status;
//       if (!status.isGranted) await Permission.notification.request();
//     } else {
//       await FirebaseMessaging.instance.requestPermission();
//     }
//   }
//
//   static Future<void> _showLocalNotification(RemoteMessage message) async {
//     final notification = message.notification;
//     final data = message.data;
//
//     if (notification != null) {
//       const AndroidNotificationDetails androidDetails =
//           AndroidNotificationDetails(
//             'default_channel',
//             'Default Notifications',
//             importance: Importance.max,
//             priority: Priority.high,
//             playSound: true,
//             sound: RawResourceAndroidNotificationSound('temple_bell'),
//           );
//
//       const NotificationDetails platformDetails = NotificationDetails(
//         android: androidDetails,
//       );
//
//       /// single notification on notification panel
//       // await localNotificationsPlugin.show(
//       //   0,
//       //   notification.title ?? data['title'] ?? 'Notification',
//       //   notification.body ?? data['body'] ?? '',
//       //   platformDetails,
//       //   payload: 'foreground',
//       // );
//
//       /// multiple notification on notification panel
//       await localNotificationsPlugin.show(
//         DateTime.now().millisecondsSinceEpoch ~/ 1000,
//         notification.title ?? data['title'] ?? 'Notification',
//         notification.body ?? data['body'] ?? '',
//         platformDetails,
//         payload: 'foreground',
//       );
//
//       await NotificationDbHelper().insertNotification(
//         LocalNotification(
//           title: notification.title ?? data['title'] ?? 'Notification',
//           body: notification.body ?? data['body'] ?? '',
//           data: data.toString(),
//           timestamp: Helper.getCurrentDate(Helper.DATE_FORMAT_2),
//         ),
//       );
//     }
//   }
//
//   static Future<void> _firebaseMessagingBackgroundHandler(
//     RemoteMessage message,
//   ) async {
//     await Firebase.initializeApp();
//
//     Logger.m(tag: '🔥 Background Message', value: message.data);
//
//     if (message.notification != null) {
//       const AndroidNotificationDetails androidDetails =
//           AndroidNotificationDetails(
//             'default_channel',
//             'Default Notifications',
//             importance: Importance.max,
//             priority: Priority.high,
//             playSound: true,
//             sound: RawResourceAndroidNotificationSound('temple_bell'),
//           );
//
//       const NotificationDetails platformDetails = NotificationDetails(
//         android: androidDetails,
//       );
//
//       await NotifHelper.localNotificationsPlugin.show(
//         0,
//         message.notification?.title ?? 'New Notification',
//         message.notification?.body ?? '',
//         platformDetails,
//         payload: 'background',
//       );
//
//       await NotificationDbHelper().insertNotification(
//         LocalNotification(
//           title: message.notification?.title ?? 'New Notification',
//           body: message.notification?.body ?? '',
//           data: message.data.toString(),
//           timestamp: Helper.getCurrentDate(Helper.DATE_FORMAT_2),
//         ),
//       );
//     }
//   }
//
//   static void _handleNotificationClick(RemoteMessage message) {
//     Logger.m(tag: '🧭 Notification Opened', value: message.data);
//     // TODO: Navigate to specific screen if required
//   }
// }
